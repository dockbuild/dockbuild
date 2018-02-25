#
# Parameters
#

# Name of the docker executable
DOCKER = docker

# Docker organization to pull the images from
ORG = thewtex

# Docker project
PROJ = centos-build

# These images are built using the "build implicit rule"
IMAGES = centos5 centos6

#
# images: This target builds all IMAGES (because it is the first one, it is built by default)
#
images: $(IMAGES)

#
# display
#
display_images:
	for image in $(IMAGES); do echo $$image; done

$(VERBOSE).SILENT: display_images

#
# build implicit rule
#

$(IMAGES): %: %/Dockerfile
	$(DOCKER) build -t $(ORG)/$(PROJ):$@-latest \
		--build-arg IMAGE=$(ORG)/$(PROJ):$@-latest \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg VCS_URL=`git config --get remote.origin.url` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		$@

.PHONY: images display_images $(IMAGES)
