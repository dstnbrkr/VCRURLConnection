CONFIGURATION ?= "Debug"
BUILD_DIR = $(shell pwd)/build

clean:
	$(XCMD) clean
	rm -rf $(BUILD_DIR)

test:
	xctool -sdk $(SDK) \
               -project VCRURLConnection.xcodeproj \
	       -scheme $(SCHEME) \
               -configuration $(CONFIGURATION) \
	       CONFIGURATION_BUILD_DIR=$(BUILD_DIR) \
	       test

test_ios:
	$(MAKE) SDK=iphonesimulator SCHEME=Tests-iOS test

test_osx:
	$(MAKE) SDK=macosx SCHEME=Tests-OSX test

test_all:
	$(MAKE) test_ios test_osx


