package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#Secret: corev1.#Secret & {
	_config: #Config

	apiVersion: "v1"
	kind:       "Secret"
	metadata:   _config.metadata

	stringData: claim: _config.claim
}
