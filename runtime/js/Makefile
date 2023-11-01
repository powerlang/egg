MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
GIT_PATH := $(realpath $(dir $(MKFILE_PATH))/../..)
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
IMAGE_SEGMENTS_DIR=$(ROOT_DIR)/image-segments
POWERLANG_DIR=$(GIT_PATH)/bootstrap/pharo

.PHONY: all interpreter kernel

all: interpreter kernel

$(POWERLANG_DIR)/powerlangjs.image:
	make -C $(POWERLANG_DIR) bootstrap.image
	cd $(POWERLANG_DIR) && ./pharo bootstrap.image save powerlangjs
	cd $(POWERLANG_DIR) && ./pharo powerlangjs.image eval --save "Metacello new repository: 'github://powerlang/egg:main'; baseline: 'PowerlangJS'; load: 'base'"

kernel: $(IMAGE_SEGMENTS_DIR)/Kernel.json

interpreter/PowertalkEvaluator.js: $(POWERLANG_DIR)/powerlangjs.image
	cd $(POWERLANG_DIR) && ./pharo powerlangjs.image eval "JSTranspiler transpilePowerlangInterpreter"

interpreter: interpreter/PowertalkEvaluator.js

$(IMAGE_SEGMENTS_DIR)/Kernel.json: $(POWERLANG_DIR)/powerlangjs.image
	export IMAGE_SEGMENTS_DIR
	cd $(POWERLANG_DIR) && ./pharo powerlangjs.image eval "JSTranspiler generateKernelSegment"




