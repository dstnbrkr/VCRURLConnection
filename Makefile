NAME = VCRURLConnection
BUILD_DIR = $(shell pwd)/build

test:
	xcodebuild \
	-sdk $(SDK) \
	-derivedDataPath $(BUILD_DIR) \
	-project $(NAME).xcodeproj \
	-scheme $(SCHEME) \
	-configuration Debug \
	 -destination $(DEST) \
	test

test_iphonesimulator:
	$(MAKE) SDK=iphonesimulator SCHEME=libVCRURLConnection DEST="\"platform=iOS Simulator,name=iPhone 6\""

test_osx:
	$(MAKE) SCHEME=VCRURLConnection SDK=macosx DEST="arch=x86_64"

ci: test_iphonesimulator test_osx

clean:
	rm -rf build





