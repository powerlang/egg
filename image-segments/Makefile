MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
GIT_PATH := $(realpath $(dir $(MKFILE_PATH))/..)
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
IMAGE_SEGMENTS_DIR=$(ROOT_DIR)/image-segments
PHARO_DIR=$(GIT_PATH)/runtime/pharo

.PHONY: always_rebuild

always_rebuild:
	@true  # Always succeed, forces rebuild

%.json: always_rebuild
	export IMAGE_SEGMENTS_DIR
	cd $(PHARO_DIR) && ./pharo eggjs.image eval "EggBuilder forJSPlatform generateSegmentFromModuleNamed: '$*'"

%.ems: always_rebuild
	export IMAGE_SEGMENTS_DIR
	cd $(PHARO_DIR) && ./pharo eggjs.image eval "EggBuilder forNativePlatform generateSegmentFromModuleNamed: '$*'"

