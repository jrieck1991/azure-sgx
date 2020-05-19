.PHONY: base

# packer builds on Azure require AZ_SUBSCRIPTION_ID, AZ_CLIENT_ID, AZ_CLIENT_SECRET to be set

base:
	pushd base && \
	packer build build.json && \
	popd
