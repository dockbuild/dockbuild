
#
# Parameters
#

# Name of the docker-equivalent executable for building images.
# OCI: open container interface.
# Common values: docker, podman
DOCKER := $(or $(OCI_EXE), docker)
BUILD_DOCKER := $(or $(BUILD_DOCKER), $(DOCKER))

# The build sub-command. Use:
#
#   export "BUILD_CMD=buildx build --platform linux/amd64,linux/arm64"
#
# to generate multi-platform images.
BUILD_CMD := $(or $(BUILD_CMD), build)

# DockerHub organization to pull/push the images from/to
ORG = dockbuild

# Directory where to generate the dockbuild script for each images (e.g bin/dockbuild-centos5)
BIN = ./bin

IMAGES = \
  ubuntu1804-gcc7 \
  ubuntu2004-gcc9

# These images are built using the "build implicit rule"
ALL_IMAGES = $(IMAGES)

# On CircleCI, do not attempt to delete container
# See https://circleci.com/docs/docker-btrfs-error/
RM = --rm
ifeq ("$(CIRCLECI)", "true")
	RM =
endif

#
# images: This target builds all IMAGES (because it is the first one, it is built by default)
#
images: $(IMAGES)
.PHONY: images

#
# display
#
display_images:
	for image in $(ALL_IMAGES); do echo $$image; done

$(VERBOSE).SILENT: display_images
.PHONY: display_images


#
# build implicit rule
#
$(ALL_IMAGES): %: %/Dockerfile
	mkdir -p $@/imagefiles && cp --remove-destination -r imagefiles $@/
	$(eval OPERATING_SYSTEM := $(firstword $(subst -, ,$@)))
	$(eval REPO := $@)
	$(eval REPO_OS := $(OPERATING_SYSTEM))
	$(eval TAG := latest)
	$(eval BASEIMAGE := $(shell cat $@/Dockerfile | grep "^FROM" | head -n1 | cut -d" " -f2))
	$(eval IMAGEID := $(shell $(BUILD_DOCKER) images -q $(ORG)/$(REPO):$(TAG)))
	$(BUILD_DOCKER) $(BUILD_CMD) --cache-from=$(BASEIMAGE),$(ORG)/$(REPO):$(TAG) -t $(ORG)/$(REPO):$(TAG) \
		--build-arg IMAGE=$(ORG)/$(REPO):$(TAG) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg VCS_URL=`git config --get remote.origin.url` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		$@
	$(BUILD_DOCKER) tag $(ORG)/$(REPO):$(TAG) $(ORG)/$(REPO_OS):$(TAG)
	CURRENT_IMAGEID=$$($(BUILD_DOCKER) images -q $(ORG)/$(REPO)) && \
	if [ -n "$(IMAGEID)" ] && [ "$(IMAGEID)" != "$$CURRENT_IMAGEID" ]; then $(BUILD_DOCKER) rmi "$(IMAGEID)" || true; fi

.PHONY: $(ALL_IMAGES)


#
# run implicit rule
#
.SECONDEXPANSION:
$(addsuffix .run,$(ALL_IMAGES)):
	$(eval REPO := $(basename $@))
	$(eval TAG := latest)
	$(BUILD_DOCKER) run -ti --rm $(ORG)/$(REPO):$(TAG) bash

.PHONY: $(addsuffix .run,$(ALL_IMAGES))


clean:
	for d in $(ALL_IMAGES) ; do rm -rf $$d/imagefiles ; done


#
# test implicit rule
#
.SECONDEXPANSION:
$(addsuffix .test,$(ALL_IMAGES)): $$(basename $$@)
	$(eval REPO := $(basename $@))
	mkdir -p $(BIN)
	$(BUILD_DOCKER) run $(RM) dockbuild/$(REPO) > $(BIN)/dockbuild-$(REPO) && chmod +x $(BIN)/dockbuild-$(REPO)
	$(BIN)/dockbuild-$(REPO) python test/run.py $($@_ARGS)
	$(BIN)/dockbuild-$(REPO) python -c "import bz2; import ctypes; import lzma; import readline; import sqlite3"

.PHONY: $(addsuffix .test,$(ALL_IMAGES))

#
# pull implicit rule
#
.SECONDEXPANSION:
$(addsuffix .pull,$(ALL_IMAGES)):
	$(eval REPO := $(basename $@))
	$(eval TAG := latest)
	$(BUILD_DOCKER) pull $(ORG)/$(REPO):$(TAG)

pull: $(addsuffix .pull,$(ALL_IMAGES))

.PHONY: pull $(addsuffix .pull,$(ALL_IMAGES))
