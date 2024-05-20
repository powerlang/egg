
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

all: pharo-ui bootstrap.image

pharo pharo-ui Pharo.image:
	curl https://get.pharo.org/64/90+vm | bash || curl https://get.pharo.org/64/90+vm | bash

bootstrap.image: pharo Pharo.image
	./pharo Pharo.image save bootstrap
	./pharo $@ eval --save "(IceRepositoryCreator new url: '$(ICEBERG_URL)'; createRepository) register"
	./pharo $@ metacello install tonel://. BaselineOfPowerlang --groups=$(GROUP)
	./pharo $@ eval --save "SystemWindow closeTopWindow. GTPlayground openContents: 'first-steps.st' asFileReference contents withSqueakLineEndings"
	@echo ""
	@echo "To open Pharo bootstrap image run:"
	@echo ""
	@echo "    ./pharo-ui bootstrap.image"
	@echo ""
	git remote -v | grep -w pharo-bootstrap || git remote add pharo-bootstrap bootstrap/pharo/pharo-local/iceberg/local/egg/

test: bootstrap.image pharo
	./pharo $< test --junit-xml-output Powerlang-Tests
	mkdir -p test-reports
	mv Powerlang-Tests-Test.xml test-reports

test-ci: bootstrap.image pharo
	./pharo $< test --junit-xml-output Powerlang-Tests
	mkdir -p test-reports
	mv Powerlang-Tests-Test.xml test-reports

clean:
	rm -f bootstrap.image bootstrap.changes powerlangjs.image powerlangjs.changes

mrproper: clean
	rm -rf Pharo* pharo* icon-packs

powerlangjs-kernel: bootstrap.image pharo |
	test -n "$(KERNEL_FILE)" || (echo "you must define KERNEL_FILE variable to set the output filename" && exit 1)
	./pharo bootstrap.image eval \
		"| bootstrapper module runtime filename | \
		bootstrapper := PowertalkRingImage fromSpec wordSize: 8; genesis; bootstrap; fillClasses; fillSymbols; generateLMR. \
		module := bootstrapper loadBootstrapModule. \
		runtime := bootstrapper result. \
		filename := runtme newString: '$(KERNEL_FILE)'. \
		runtime sendLocal: #writeJsonKernelTo: to: module with: {filename}"



