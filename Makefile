
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
	
release-js:
	make -C runtime/js release

clean:
	make -C bootstrap/pharo clean
	make -C runtime/js clean
	#make -C runtime/js clean
	#make -C runtime/js clean


