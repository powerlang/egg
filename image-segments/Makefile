MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
GIT_PATH := $(realpath $(dir $(MKFILE_PATH))/..)
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
IMAGE_SEGMENTS_DIR=$(ROOT_DIR)/image-segments
PHARO_DIR=$(GIT_PATH)/runtime/pharo


%.json:
	export IMAGE_SEGMENTS_DIR
	cd $(PHARO_DIR) && ./pharo eggjs.image eval "EggBuilder forJSPlatform generateSegmentFromModuleNamed: '$*'"

%.ems:
	export IMAGE_SEGMENTS_DIR
	cd $(PHARO_DIR) && ./pharo eggjs.image eval "EggBuilder forNativePlatform generateSegmentFromModuleNamed: '$*'"

