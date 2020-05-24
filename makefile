.PHONY: base oasis

# TODO: figure out how to generate these with az cli
# packer builds on Azure require AZ_SUBSCRIPTION_ID, AZ_CLIENT_ID, AZ_CLIENT_SECRET to be set

base:
	pushd base && \
	time packer build build.json && \
	popd

oasis:
	pushd oasis && \
	time packer build build.json && \
	popd

pdb:
	pushd pdb && \
	time packer build build.json && \
	popd
