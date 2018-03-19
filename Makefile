#
# Parameters
#

# Name of the docker executable
DOCKER = docker

# Docker organization to pull the images from
ORG = dockbuild

IMAGES = centos5 centos6 centos7

# These images are built using the "build implicit rule"
ALL_IMAGES = $(IMAGES)

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
	$(DOCKER) build --cache-from=centos:$(subst centos,,$@),$(ORG)/$@:latest -t $(ORG)/$@:latest \
		--build-arg IMAGE=$(ORG)/$@:latest \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg VCS_URL=`git config --get remote.origin.url` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		$@ || \
	$(DOCKER) build -t $(ORG)/$@:latest \
		--build-arg IMAGE=$(ORG)/$@:latest \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg VCS_URL=`git config --get remote.origin.url` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		$@
	docker rmi $$(docker images -f "dangling=true" -q) || true

.SECONDEXPANSION:
$(addsuffix .run,$(ALL_IMAGES)):
	$(DOCKER) run -ti --rm $(ORG)/$(basename $@):latest bash

.PHONY: images display_images $(ALL_IMAGES) $(addsuffix .run,$(ALL_IMAGES))
