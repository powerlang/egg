MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
GIT_PATH := $(realpath $(dir $(MKFILE_PATH))/../..)
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
IMAGE_SEGMENTS_DIR=$(ROOT_DIR)/image-segments
POWERLANG_DIR=$(GIT_PATH)/runtime/pharo

.PHONY: all interpreter kernel compiler core-segments example-server

all: interpreter kernel compiler example-server

clean:

$(POWERLANG_DIR)/eggjs.image:
	make -C $(POWERLANG_DIR) egg.image
	cd $(POWERLANG_DIR) && ./pharo egg.image save eggjs
	cd $(POWERLANG_DIR) && ./pharo eggjs.image metacello install tonel://. BaselineOfPowerlang --groups=powerlangjs

kernel: $(IMAGE_SEGMENTS_DIR)/Kernel.json

interpreter/EggEvaluator.js: $(POWERLANG_DIR)/eggjs.image
	cd $(POWERLANG_DIR) && ./pharo eggjs.image eval "JSTranspiler transpileEggInterpreter"

interpreter: interpreter/EggEvaluator.js

$(IMAGE_SEGMENTS_DIR)/%.json: $(POWERLANG_DIR)/eggjs.image
	export IMAGE_SEGMENTS_DIR
	cd $(POWERLANG_DIR) && ./pharo eggjs.image eval "EggBuilder forJSPlatform generateSegmentFromModuleNamed: '$*'"

core-segments: $(POWERLANG_DIR)/eggjs.image
	export IMAGE_SEGMENTS_DIR
	cd $(POWERLANG_DIR) && ./pharo eggjs.image eval "EggBuilder forJSPlatform generateMainSegments"

kernel: $(IMAGE_SEGMENTS_DIR)/Kernel.json
compiler: $(IMAGE_SEGMENTS_DIR)/Compiler.json

example-server: kernel compiler core-segments

