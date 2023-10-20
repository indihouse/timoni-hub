package templates

import (
	netv1 "k8s.io/api/networking/v1"
)

#Ingress: netv1.#Ingress & {
	_config: #Config

	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata:   _config.metadata

	spec: {
		rules: [{
			host: _config.ingress.host
			http: paths: [{
				backend: service: {
					name: _config.metadata.name
					port: name: "http"
				}
				path:     "/"
				pathType: "Prefix"
			}]
		}]
	}
}
