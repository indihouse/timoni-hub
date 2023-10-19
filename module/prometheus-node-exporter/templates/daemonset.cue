package templates

import (
	"cue.indi.house/kue/pkg/k8s/container"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#DaemonSet: appsv1.#DaemonSet & {
	_config: #Config

	apiVersion: "apps/v1"
	kind:       "DaemonSet"
	metadata:   _config.metadata

	spec: appsv1.#DaemonSetSpec & {
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
						name:            "node-exporter"
						image:           _config.image.reference
						imagePullPolicy: _config.imagePullPolicy

						args: [
							"--path.sysfs=/host/sys",
							"--path.procfs=/host/proc",
							if _config.hostRootFs.enabled {
								"--path.rootfs=/host/root"
							},
						] + _config.extraArgs

						_ports: container.#Ports & {
							metrics: containerPort: 9100
						}
						ports: _ports.$out

						readinessProbe: {
							httpGet: {
								path: "/"
								port: _ports.metrics.name
							}
						}
						volumeMounts: [
							{
								name:             "proc"
								mountPath:        "/host/proc"
								mountPropagation: "HostToContainer"
								readOnly:         true
							},
							{
								name:             "sys"
								mountPath:        "/host/sys"
								mountPropagation: "HostToContainer"
								readOnly:         true
							},
							if _config.hostRootFs.enabled {
								{
									name:             "root"
									mountPath:        "/host/root"
									mountPropagation: "HostToContainer"
									readOnly:         true
								}
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
						name: "proc"
						hostPath: path: "/proc"
					},
					{
						name: "sys"
						hostPath: path: "/sys"
					},
					if _config.hostRootFs.enabled {
						{
							name: "root"
							hostPath: path: "/"
						}
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
