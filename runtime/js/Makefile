MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
GIT_PATH := $(realpath $(dir $(MKFILE_PATH))/../..)
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
IMAGE_SEGMENTS_DIR=$(ROOT_DIR)/image-segments
POWERLANG_DIR=$(GIT_PATH)/runtime/pharo

.PHONY: all interpreter kernel compiler

all: interpreter kernel compiler

clean:

$(POWERLANG_DIR)/powerlangjs.image:
	make -C $(POWERLANG_DIR) bootstrap.image
	cd $(POWERLANG_DIR) && ./pharo bootstrap.image save powerlangjs
	cd $(POWERLANG_DIR) && ./pharo powerlangjs.image metacello install tonel://. BaselineOfPowerlang --groups=powerlangjs

kernel: $(IMAGE_SEGMENTS_DIR)/Kernel.json

interpreter/EggEvaluator.js: $(POWERLANG_DIR)/powerlangjs.image
	cd $(POWERLANG_DIR) && ./pharo powerlangjs.image eval "JSTranspiler transpileEggInterpreter"

interpreter: interpreter/EggEvaluator.js

$(IMAGE_SEGMENTS_DIR)/Kernel.json: $(POWERLANG_DIR)/powerlangjs.image
	export IMAGE_SEGMENTS_DIR
	cd $(POWERLANG_DIR) && ./pharo powerlangjs.image eval "JSTranspiler generateKernelSegment"

compiler: $(IMAGE_SEGMENTS_DIR)/Compiler.json

$(IMAGE_SEGMENTS_DIR)/Compiler.json: $(POWERLANG_DIR)/powerlangjs.image
	export IMAGE_SEGMENTS_DIR
	cd $(POWERLANG_DIR) && ./pharo powerlangjs.image eval "JSTranspiler generateCompilerSegment"

