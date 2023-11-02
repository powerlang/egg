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
	cd $(POWERLANG_DIR) && ./pharo powerlangjs.image metacello install tonel://. BaselineOfPowerlangJS

kernel: $(IMAGE_SEGMENTS_DIR)/Kernel.json

interpreter/PowertalkEvaluator.js: $(POWERLANG_DIR)/powerlangjs.image
	cd $(POWERLANG_DIR) && ./pharo powerlangjs.image eval "JSTranspiler transpilePowerlangInterpreter"

interpreter: interpreter/PowertalkEvaluator.js

$(IMAGE_SEGMENTS_DIR)/Kernel.json: $(POWERLANG_DIR)/powerlangjs.image
	export IMAGE_SEGMENTS_DIR
	cd $(POWERLANG_DIR) && ./pharo powerlangjs.image eval "JSTranspiler generateKernelSegment"

release: all
	@test -n "$RELEASE_NAME" || (echo "RELEASE_NAME varible is not set!" && exit 1)
	mkdir -p build/tmp
	tar -czvf build/$(RELEASE_NAME).tar.gz --exclude=./build --exclude=node_modules . 
	tar -xzf build/$(RELEASE_NAME).tar.gz -C build/tmp && cd build/tmp && zip $(RELEASE_NAME).zip -r . && mv $(RELEASE_NAME).zip .. && cd .. && rm -rf tmp


