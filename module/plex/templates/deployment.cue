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
		replicas: _config.replicas
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
						name:            "plex"
						image:           _config.image.reference
						imagePullPolicy: _config.imagePullPolicy

						_ports: container.#Ports & {
							http: containerPort: 32400
						}
						ports: _ports.$out

						_env: container.#Env & {
							TZ: _config.timezone
							PLEX_CLAIM: secretKeyRef: {
								name: _config.metadata.name
								key:  "claim"
							}
							if _config.podSecurityContext.runAsUser != _|_ {
								PLEX_UID: _config.podSecurityContext.runAsUser
							}
							if _config.podSecurityContext.runAsGroup != _|_ {
								PLEX_GID: _config.podSecurityContext.runAsGroup
							}
							if _config.ingress.enabled {
								ADVERTISE_IP: "https://\(_config.ingress.host)"
							}
						}
						env: _env.$out

						readinessProbe: {
							tcpSocket: port: _ports.http.containerPort
						}

						volumeMounts: [
								{
								mountPath: "/config"
								name:      "config"
							},
							{
													mountPath: "/transcode"
													name:      "transcode"
												},
						] + [ for v in _config.extraVolumes {mountPath: v.mountPath, name: v.name}]
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
					{
						name: "transcode"
						_config.transcodeVolume
					},
				] + [ for v in _config.extraVolumes {
					name: v.name
					v.source
				}]
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
