package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#Service: corev1.#Service & {
	_config:    #Config
	apiVersion: "v1"
	kind:       "Service"
	metadata:   _config.metadata
	metadata: annotations: {
		"prometheus.io/scrape": "true"
		"prometheus.io/port":   "\(_config.service.port)"
	}

	spec: corev1.#ServiceSpec & {
		type:     corev1.#ServiceTypeClusterIP
		selector: _config.selector.labels
		ports: [
			{
				port:       _config.service.port
				protocol:   "TCP"
				name:       "metrics"
				targetPort: name
			},
		]
	}
}
