package templates

import (
	"list"
	"cue.indi.house/kue/pkg/k8s/container"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	_config:     #Config
	_secretName: string

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
				serviceAccountName: _config.metadata.name
				containers: [
					{
						name:            "aria2"
						image:           _config.image.reference
						imagePullPolicy: _config.imagePullPolicy

						args: [
							"--rpc-secret=$(RPC_TOKEN)",
							"--max-concurrent-downloads=\(_config.maxConcurrentDownload)",
							"--listen-port=\(_config.bittorrent.ports.start)-\(_config.bittorrent.ports.end)",
							"--console-log-level=\(_config.logLevel)",
						]

						_ports: container.#Ports & {
							rpc: containerPort: _config.rpc.port
						}
						_ports: {for i, port in list.Range(_config.bittorrent.ports.start, _config.bittorrent.ports.end, 1) {"bt-\(i)": containerPort: port}}
						ports: _ports.$out

						_env: container.#Env & {
							RPC_TOKEN: secretKeyRef: {
								name: _secretName
								key:  "rpcToken"
							}
						}
						env: _env.$out

						volumeMounts: [
							{
								mountPath: "/download"
								name:      "download"
							},
						]

						readinessProbe: httpGet: {
							path: "jsonrpc?method=system.listMethods&id=probes'"
							port: _ports.rpc.containerPort
						}

						startupProbe: httpGet: {
							path: "jsonrpc?method=system.listMethods&id=probes'"
							port: _ports.rpc.containerPort
						}

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
						name: "download"
						_config.downloadVolumeSource
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
