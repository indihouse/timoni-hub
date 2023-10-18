package main

values: {
	image: {
		digest:     "sha256:302028d1ea65a50a32d9ae81fda1a964e45a620a9575e36036b9a55a33395f16"
		tag:        "1.25.2"
	}
	extraArgs: ["--collector.filesystem.mount-points-exclude=^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/.+)($|/)"]
}
