package templates

import (
	"encoding/yaml"
	"strings"
	"uuid"

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

	// App settings
	rpc!: {
		token!: string
		port:   *6800 | int & >0 & <=65535
	}
	maxConcurrentDownload: *5 | int & >0
	logLevel:              "debug" | "info" | *"notice" | "warn" | "error"
	bittorrent: {
		name: *"\(metadata.name)-bittorrent" | string
		annotations?: {[ string]: string}
		ports: {
			start: *6666 | int & >0 & <=65535
			end:   *6676 | int & >start
		}
		service: type: *"LoadBalancer" | corev1.#enumServiceType
	}

	downloadVolumeSource: corev1.#VolumeSource

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
	image: repository: *"ghcr.io/indihouse/aria2" | string
	image: tag:        *"v1.36.0" | string
	imagePullPolicy: *"IfNotPresent" | string
	resources:       *{
		requests: {
			memory:              "128Mi"
			cpu:                 "100m"
			"ephemeral-storage": "100Mi"
		}
		limits: {
			"ephemeral-storage": "100Mi"
		}
	} | corev1.#ResourceRequirements
	securityContext: *{
		allowPrivilegeEscalation: false
		runAsUser:                11000
		runAsGroup:               11000
		readOnlyRootFilesystem:   true
	} | corev1.#SecurityContext
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		svc:    #Service & {_config:           config}
		svcBT:  #ServiceBitTorrent & {_config: config}
		secret: #Secret & {_config:            config}

		deploy: #Deployment & {
			_config: config & {
				podAnnotations: "house.indi.checksum/secret": strings.Split(uuid.SHA1(uuid.ns.DNS, yaml.Marshal(secret.stringData)), "-")[0]
			}
			_secretName: objects.secret.metadata.name
		}
	}
}
