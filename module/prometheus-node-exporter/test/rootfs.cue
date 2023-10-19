package main

values: {
	image: {
		digest: "sha256:302028d1ea65a50a32d9ae81fda1a964e45a620a9575e36036b9a55a33395f16"
		tag:    "1.25.2"
	}
	hostRootFs: enabled: true

	podSecurityContext: {
		runAsUser:  65532
		runAsGroup: 65532
		fsGroup:    65532
	}
	securityContext: {
		allowPrivilegeEscalation: false
		readOnlyRootFilesystem:   true
		runAsNonRoot:             true
		capabilities: drop: ["ALL"]
		seccompProfile: type: "RuntimeDefault"
	}
	resources: {
		requests: {
			memory:              "128Mi"
			cpu:                 "100m"
			"ephemeral-storage": "100Mi"
		}
		limits: {
			"ephemeral-storage": "100Mi"
		}
	}
}
