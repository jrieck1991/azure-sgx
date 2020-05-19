.PHONY: base

base:
	pushd base && \
	packer build build.json && \
	popd

