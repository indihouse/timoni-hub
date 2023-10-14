package templates

import (
	"list"

	corev1 "k8s.io/api/core/v1"
)

#ServiceBitTorrent: corev1.#Service & {
	_config: #Config

	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:      _config.bittorrent.name
		namespace: _config.metadata.namespace
		labels:    _config.metadata.labels
		if _config.bittorrent.annotations != _|_ {
			annotations: _config.bittorrent.annotations
		}
		if _config.metadata.annotations != _|_ {
			annotations: _config.metadata.annotations
		}
	}

	spec: corev1.#ServiceSpec & {
		type:     _config.bittorrent.service.type
		selector: _config.selector.labels
		ports: [ for i, v in list.Range(_config.bittorrent.ports.start, _config.bittorrent.ports.end, 1) {
			name:       "bt-\(i)"
			port:       v
			protocol:   "TCP"
			targetPort: port
		}]
	}
}
