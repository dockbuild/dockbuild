#
# Parameters
#

# Name of the docker executable
DOCKER = imagefiles/docker.sh

# DockerHub organization to pull/push the images from/to
ORG = dockbuild

# Directory where to generate the dockbuild script for each images (e.g bin/dockbuild-centos5)
BIN = ./bin

IMAGES = \
  centos7-devtoolset4-gcc5 \
  centos7-devtoolset7-gcc7 \
  ubuntu1804-gcc7 \
  ubuntu2004-gcc9 \
  ubuntu2104-gcc11

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
	$(eval IMAGEID := $(shell $(DOCKER) images -q $(ORG)/$(REPO):$(TAG)))
	$(DOCKER) build --cache-from=$(BASEIMAGE),$(ORG)/$(REPO):$(TAG) -t $(ORG)/$(REPO):$(TAG) \
		--build-arg IMAGE=$(ORG)/$(REPO):$(TAG) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg VCS_URL=`git config --get remote.origin.url` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		$@
	$(DOCKER) tag $(ORG)/$(REPO):$(TAG) $(ORG)/$(REPO_OS):$(TAG)
	CURRENT_IMAGEID=$$($(DOCKER) images -q $(ORG)/$(REPO)) && \
	if [ -n "$(IMAGEID)" ] && [ "$(IMAGEID)" != "$$CURRENT_IMAGEID" ]; then $(DOCKER) rmi "$(IMAGEID)" || true; fi
	rm -rf $@/imagefiles

.PHONY: $(ALL_IMAGES)


#
# run implicit rule
#
.SECONDEXPANSION:
$(addsuffix .run,$(ALL_IMAGES)):
	$(eval REPO := $(basename $@))
	$(eval TAG := latest)
	$(DOCKER) run -ti --rm $(ORG)/$(REPO):$(TAG) bash

.PHONY: $(addsuffix .run,$(ALL_IMAGES))


#
# test implicit rule
#
.SECONDEXPANSION:
$(addsuffix .test,$(ALL_IMAGES)): $$(basename $$@)
	$(eval REPO := $(basename $@))
	mkdir -p $(BIN)
	$(DOCKER) run $(RM) dockbuild/$(REPO) > $(BIN)/dockbuild-$(REPO) && chmod +x $(BIN)/dockbuild-$(REPO)
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
	$(DOCKER) pull $(ORG)/$(REPO):$(TAG)

pull: $(addsuffix .pull,$(ALL_IMAGES))

.PHONY: pull $(addsuffix .pull,$(ALL_IMAGES))
