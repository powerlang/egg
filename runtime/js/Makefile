ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
IMAGE_SEGMENTS_DIR=$(ROOT_DIR)/image-segments

.PHONY: all interpreter kernel

all: interpreter kernel

../bootstrap/powerlangjs.image: powerlang
	make -C powerlang bootstrap.image
	cd powerlang && ./pharo bootstrap.image save powerlangjs
	cd powerlang && ./pharo powerlangjs.image eval --save "Metacello new repository: 'github://powerlang/egg:main'; baseline: 'PowerlangJS'; load: 'base'"


kernel: $(IMAGE_SEGMENTS_DIR)/Kernel.json

interpreter/PowertalkEvaluator.js: powerlang/powerlangjs.image
	cd powerlang && ./pharo powerlangjs.image eval "JSTranspiler transpilePowerlangInterpreter"

interpreter: interpreter/PowertalkEvaluator.js

$(IMAGE_SEGMENTS_DIR)/Kernel.json: powerlang/powerlangjs.image powerlang/specs/current
	export IMAGE_SEGMENTS_DIR
	cd powerlang && ./pharo powerlangjs.image eval "JSTranspiler generateKernelSegment"




