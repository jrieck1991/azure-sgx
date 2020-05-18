.PHONY: image

image:
	PACKER_LOG=1 packer build build.json

