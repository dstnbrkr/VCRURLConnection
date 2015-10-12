NAME = VCRURLConnection
BUILD_DIR = $(shell pwd)/build

test:
	xcodebuild \
	-sdk $(SDK) \
	-derivedDataPath $(BUILD_DIR) \
	-project $(NAME).xcodeproj \
	-scheme $(NAME) \
	-configuration Debug \
	test

test_iphonesimulator:
	$(MAKE) SDK=iphonesimulator

test_osx:
	$(MAKE) SDK=macosx

