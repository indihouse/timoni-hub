// Code generated by timoni.
// Note that this file must have no imports and all values must be concrete.

@if(!debug)

package main

// Defaults
values: {
	image: {
		digest: "sha256:17b45f73fbfd15048aa9bbdb8af037f4b45139ffc49f56150834cbfe4cc2ac2f"
		tag:    "1.33.2"
	}
	timezone: "UTC"
	configVolume: emptyDir: {}

	ingress: {
		enabled: true
		host:    "overseerr.test.com"
	}

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