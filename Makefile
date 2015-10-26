NAME = VCRURLConnection
BUILD_DIR = $(shell pwd)/build

test:
	xcodebuild \
	-sdk $(SDK) \
	-derivedDataPath $(BUILD_DIR) \
	-project $(NAME).xcodeproj \
	-scheme $(NAME) \
	-configuration Debug \
	 -destination $(DEST) \
	test

test_iphonesimulator:
	$(MAKE) SDK=iphonesimulator DEST="\"platform=iOS Simulator,name=iPhone 6\""

test_osx:
	$(MAKE) SDK=macosx DEST="arch=x86_64"



