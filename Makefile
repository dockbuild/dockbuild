#
# Parameters
#

# Name of the docker executable
DOCKER = imagefiles/docker.sh

# Docker organization to pull the images from
ORG = dockbuild

# Directory where to generate the dockbuild script for each images (e.g bin/dockbuild-centos5)
BIN = ./bin

IMAGES = centos5 centos6 centos7

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

#
# display
#
display_images:
	for image in $(ALL_IMAGES); do echo $$image; done

$(VERBOSE).SILENT: display_images

#
# build implicit rule
#

$(ALL_IMAGES): %: %/Dockerfile
	mkdir -p $@/imagefiles && cp -r imagefiles $@/
	$(DOCKER) build --cache-from=`cat $@/Dockerfile | grep "^FROM" | head -n1 | cut -d" " -f2`,$(ORG)/$@:latest -t $(ORG)/$@:latest \
		--build-arg IMAGE=$(ORG)/$@:latest \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg VCS_URL=`git config --get remote.origin.url` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		$@
	$(DOCKER) rmi $$($(DOCKER) images -f "dangling=true" -q) || true
	rm -rf $@/imagefiles

#
# run implicit rule
#
.SECONDEXPANSION:
$(addsuffix .run,$(ALL_IMAGES)):
	$(DOCKER) run -ti --rm $(ORG)/$(basename $@):latest bash

#
# test implicit rule
#
.SECONDEXPANSION:
$(addsuffix .test,$(ALL_IMAGES)): $$(basename $$@)
	$(DOCKER) run $(RM) dockbuild/$(basename $@) > $(BIN)/dockbuild-$(basename $@) && chmod +x $(BIN)/dockbuild-$(basename $@)
	$(BIN)/dockbuild-$(basename $@) python test/run.py $($@_ARGS)

#
# test prerequisites implicit rule
#
test.prerequisites:
	mkdir -p $(BIN)

$(addsuffix .test,base $(ALL_IMAGES)): test.prerequisites

.PHONY: images display_images $(ALL_IMAGES) $(addsuffix .run,$(ALL_IMAGES))
