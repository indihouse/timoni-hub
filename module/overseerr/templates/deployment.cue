package templates

import (
	"cue.indi.house/kue/pkg/k8s/container"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	_config: #Config

	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata:   _config.metadata

	spec: appsv1.#DeploymentSpec & {
		replicas: 1
		selector: matchLabels: _config.selector.labels

		template: {
			metadata: {
				labels: _config.selector.labels
				if _config.podAnnotations != _|_ {
					annotations: _config.podAnnotations
				}
			}
			spec: corev1.#PodSpec & {
				containers: [
					{
						name:            "overseerr"
						image:           _config.image.reference
						imagePullPolicy: _config.imagePullPolicy

						_ports: container.#Ports & {
							http: containerPort: 5055
						}
						ports: _ports.$out

						_env: container.#Env & {
							TZ: _config.timezone
						}
						env: _env.$out

						livenessProbe: {
							httpGet: {
								path: "/api/v1/status/appdata"
								port: _ports.http.name
							}
						}
						readinessProbe: {
							httpGet: {
								path: "/api/v1/status"
								port: _ports.http.name
							}
						}
						volumeMounts: [
							{
								mountPath: "/app/config"
								name:      "config"
							},
						]
						if _config.resources != _|_ {
							resources: _config.resources
						}
						if _config.securityContext != _|_ {
							securityContext: _config.securityContext
						}
					},
				]
				volumes: [
					{
						name: "config"
						_config.configVolume
					},
				]
				if _config.podSecurityContext != _|_ {
					securityContext: _config.podSecurityContext
				}
				if _config.topologySpreadConstraints != _|_ {
					topologySpreadConstraints: _config.topologySpreadConstraints
				}
				if _config.affinity != _|_ {
					affinity: _config.affinity
				}
				if _config.tolerations != _|_ {
					tolerations: _config.tolerations
				}
				if _config.imagePullSecrets != _|_ {
					imagePullSecrets: _config.imagePullSecrets
				}
			}
		}
	}
}
