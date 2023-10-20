package templates

import (
	"cue.indi.house/kue/pkg/utils"

	corev1 "k8s.io/api/core/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

// Config defines the schema and defaults for the Instance values.
#Config: {
	// Runtime version info
	moduleVersion!: string
	kubeVersion!:   string

	// Metadata (common to all resources)
	metadata: timoniv1.#Metadata & {#Version: moduleVersion}

	// Label selector (common to all resources)
	selector: timoniv1.#Selector & {#Name: metadata.name}

	// Deployment
	replicas: *1 | int & >0

	// Pod
	podAnnotations?: {[ string]: string}
	podSecurityContext?: corev1.#PodSecurityContext
	imagePullSecrets?: [...corev1.LocalObjectReference]
	tolerations?: [ ...corev1.#Toleration]
	affinity?: corev1.#Affinity
	topologySpreadConstraints?: [...corev1.#TopologySpreadConstraint]

	// Container
	image: timoniv1.#Image
	image: repository: *"plexinc/pms-docker" | string
	imagePullPolicy:  *"IfNotPresent" | string
	resources?:       corev1.#ResourceRequirements
	securityContext?: corev1.#SecurityContext

	// Service
	service: port: *80 | int & >0 & <=65535

	// App settings
	timezone!: string
	claim!:    string

	// Ingester config
	ingress: {
		enabled: *false | bool
		host:    string
	}

	// Volumes config
	transcodeVolume!: corev1.#VolumeSource
	configVolume!:    corev1.#VolumeSource
	extraVolumes: [...{
		mountPath: string
		name:      string
		source:    corev1.#VolumeSource
	}]

}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		svc:    #Service & {_config: config}
		secret: #Secret & {_config:  config}

		deploy: #Deployment & {
			_config: config
			_config: podAnnotations: "checksum/secret": (utils.#Checksum & {$in: secret.stringData}).$out
		}

		if config.ingress.enabled {
			ingress: #Ingress & {_config: config}
		}
	}
}
