
# Metacello group to load.
GROUP ?= base

js:
	make -C runtime/js all

native-vm:
	make -C runtime/native vm

native-lmr:
	make -C runtime/native lmr

bootstrap/pharo:
	make -C bootstrap/pharo all

test: bootstrap/pharo
	./bootstrap/pharo/pharo $< test --junit-xml-output Powerlang-Tests
	mkdir -p test-reports
	mv Powerlang-Tests-Test.xml test-reports

test-ci: bootstrap.image pharo
	./pharo $< test --junit-xml-output Powerlang-Tests
	mkdir -p test-reports
	mv Powerlang-Tests-Test.xml test-reports

EGG=egg
EGGJS=$(EGG)js
JS_OUT := build/$(EGGJS)
RELEASE_NAME=$(EGGJS)-$(RELEASE_TAG)
release-js:
	@test -n "$RELEASE_TAG" || (echo "RELEASE_TAG varible is not set!" && exit 1)
	make -C runtime/js all
	mkdir -p $(JS_OUT) $(JS_OUT)/runtime/js
	rsync -vt * $(JS_OUT)
	rsync -av modules docs $(JS_OUT)
	rsync -av --exclude=*/node_modules runtime/js $(JS_OUT)/runtime
	cd build && tar -czvf $(RELEASE_NAME).tar.gz $(EGGJS)
	cd build && zip $(RELEASE_NAME).zip -r $(EGGJS)
	rm -rf $(JS_OUT)


clean:
	make -C bootstrap/pharo clean
	make -C runtime/js clean
	rm -rf build
	#make -C runtime/js clean
	#make -C runtime/js clean


