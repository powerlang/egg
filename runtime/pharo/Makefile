
# Metacello group to load.
GROUP ?= base
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
GIT_PATH := $(realpath $(dir $(MKFILE_PATH))/../..)

# distingish windows as iceberg url requires adding a / before C:/
ifdef OS # only defined in windows
  MIN_MAKE_VERSION := 3.81
  GREATER_VERSION := $(lastword $(shell printf "$(MAKE_VERSION)\n$(MIN_MAKE_VERSION)\n" | sort -V) )
  ifeq ($(GREATER_VERSION),$(MIN_MAKE_VERSION))
  $(error This version of make is too old and known to be buggy in Windows, update to some newer one (i.e. choco install make))
  endif
ICEBERG_URL=file:///$(GIT_PATH)
else
ICEBERG_URL=file://$(GIT_PATH)
endif

all: pharo-ui egg.image

pharo pharo-ui Pharo.image:
	curl https://get.pharo.org/64/90+vm | bash || curl https://get.pharo.org/64/90+vm | bash

egg.image: pharo Pharo.image
	./pharo Pharo.image save egg
	./pharo $@ eval --save "(IceRepositoryCreator new url: '$(ICEBERG_URL)'; createRepository) register"
	./pharo $@ metacello install tonel://. BaselineOfPowerlang --groups=$(GROUP)
	./pharo $@ eval --save "SystemWindow closeTopWindow. GTPlayground openContents: 'first-steps.st' asFileReference contents withSqueakLineEndings"

	@echo ""
	@echo "To open Pharo bootstrap image run:"
	@echo ""
	@echo "    ./pharo-ui egg.image"
	@echo ""
	git remote -v | grep -w pharo-egg || git remote add pharo-egg runtime/pharo/pharo-local/iceberg/local/egg/

test: egg.image pharo
	./pharo $< test --junit-xml-output Powerlang-Tests
	mkdir -p test-reports
	mv Powerlang-Tests-Test.xml test-reports

test-ci: egg.image pharo
	./pharo $< test --junit-xml-output Powerlang-Tests
	mkdir -p test-reports
	mv Powerlang-Tests-Test.xml test-reports

clean:
	rm -f egg.image egg.changes eggjs.image eggjs.changes

mrproper: clean
	rm -rf Pharo* pharo* icon-packs

eggjs-kernel: egg.image pharo |
	test -n "$(KERNEL_FILE)" || (echo "you must define KERNEL_FILE variable to set the output filename" && exit 1)
	./pharo egg.image eval \
		"| bootstrapper module runtime filename | \
		bootstrapper := EggRingImage fromSpec wordSize: 8; genesis; bootstrap; fillClasses; fillSymbols; generateMetacircularImage. \
		module := bootstrapper loadBootstrapModule. \
		runtime := bootstrapper result. \
		filename := runtme newString: '$(KERNEL_FILE)'. \
		runtime sendLocal: #writeJsonKernelTo: to: module with: {filename}"

webside:
	./pharo egg.image metacello install github://guillermoamaral/Pharo-Webside:main BaselineOfWebside
	./pharo egg.image eval --save "WebsideServer new baseUri: '/pharo/v1'; port: 9002; start"

.PHONY: webside

