
# Metacello group to load.
GROUP ?= base

all: pharo-ui bootstrap.image

pharo pharo-ui Pharo.image:
	curl https://get.pharo.org/64/90+vm | bash

bootstrap.image: pharo Pharo.image src
	./pharo Pharo.image save bootstrap
	./pharo $@ eval --save "(IceRepositoryCreator new location: '.' asFileReference; createRepository) register"
	./pharo $@ metacello install tonel://./src BaselineOfPowerlang --groups=$(GROUP)
	./pharo $@ eval --save "SystemWindow closeTopWindow. GTPlayground openContents: 'first-steps.st' asFileReference contents withSqueakLineEndings"
	@echo ""
	@echo "To open Pharo bootstrap image run:"
	@echo ""
	@echo "    ./pharo-ui bootstrap.image"
	@echo ""

test: bootstrap.image pharo
	./pharo $< test --junit-xml-output Powerlang-Tests
	mkdir -p test-reports
	mv Powerlang-Tests-Test.xml test-reports

test-ci: bootstrap.image pharo
	./pharo $< test --junit-xml-output Powerlang-Tests
	mkdir -p test-reports
	mv Powerlang-Tests-Test.xml test-reports

clean:
	rm -f bootstrap.image bootstrap.changes

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



