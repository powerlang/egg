
# Metacello group to load.
GROUP ?= base

.PHONY: pharo js cpp lmr release-js clean test test-ci

pharo:
	make -C runtime/pharo all

js:
	make -C runtime/js all

cpp:
	make -C runtime/cpp all

lmr:
	make -C runtime/lmr all

test: pharo
	./runtime/pharo/pharo $< test --junit-xml-output Powerlang-Tests
	mkdir -p test-reports
	mv Powerlang-Tests-Test.xml test-reports

test-ci: egg.image pharo
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
	rsync -av modules docs image-segments $(JS_OUT)
	rsync -av --exclude=*/node_modules runtime/js $(JS_OUT)/runtime
	cd build && tar -czvf $(RELEASE_NAME).tar.gz $(EGGJS)
	cd build && zip $(RELEASE_NAME).zip -r $(EGGJS)

EGGCPP=$(EGG)cpp
CPP_OUT := build/$(EGGCPP)
CPP_RELEASE_NAME=$(EGGCPP)-$(RELEASE_TAG)
release-cpp:
	@test -n "$RELEASE_TAG" || (echo "RELEASE_TAG varible is not set!" && exit 1)
	make -C runtime/cpp all core-segments
	mkdir -p $(CPP_OUT)
	rsync -t * $(CPP_OUT)
	rsync -a modules docs image-segments $(CPP_OUT)

ifeq ($(OS),Windows_NT) # Windows
	cp runtime/cpp/build/Debug/egg.exe $(CPP_OUT)/
	cd build && zip -q $(CPP_RELEASE_NAME).zip -r $(EGGCPP)
else # Linux or other Unix-like OS
	cp runtime/cpp/build/egg $(CPP_OUT)/
	cd build && tar -czf $(CPP_RELEASE_NAME).tar.gz $(EGGCPP)
endif

VERSION=0.1.0
CPP_OUT_SNAP=build/snap
release-cpp-snap: release-cpp
	mkdir -p $(CPP_OUT_SNAP)
	cp runtime/cpp/snapcraft.yaml $(CPP_OUT_SNAP)/
	sed -i "s/^version: .*/version: $(VERSION)/" $(CPP_OUT_SNAP)/snapcraft.yaml
	cd build && snapcraft

clean:
	make -C runtime/pharo clean
	make -C runtime/js clean
	rm -rf $(JS_OUT) $(CPP_OUT) $(CPP_OUT_SNAP)


