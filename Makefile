TEMPORARY_FOLDER?=/tmp/SourceKitten.dst
PREFIX?=/usr/local
BUILD_TOOL?=xcodebuild

XCODEFLAGS=-workspace 'SourceKitten.xcworkspace' -scheme 'sourcekitten' DSTROOT=$(TEMPORARY_FOLDER)

BUILT_BUNDLE=$(TEMPORARY_FOLDER)/Applications/sourcekitten.app
SOURCEKITTEN_FRAMEWORK_BUNDLE=$(BUILT_BUNDLE)/Contents/Frameworks/SourceKittenFramework.framework
SOURCEKITTEN_EXECUTABLE=$(BUILT_BUNDLE)/Contents/MacOS/sourcekitten

FRAMEWORKS_FOLDER=$(PREFIX)/Frameworks
BINARIES_FOLDER=$(PREFIX)/bin

OUTPUT_PACKAGE=SourceKitten.pkg

VERSION_STRING=$(shell agvtool what-marketing-version -terse1)
COMPONENTS_PLIST=Source/sourcekitten/Components.plist

SWIFT_SNAPSHOT=swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a
SWIFT_COMMAND=/Library/Developer/Toolchains/$(SWIFT_SNAPSHOT).xctoolchain/usr/bin/swift
SWIFT_BUILD_COMMAND=$(SWIFT_COMMAND) build
SWIFT_TEST_COMMAND=$(SWIFT_COMMAND) test

.PHONY: all bootstrap clean install package test uninstall

all: bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) build

bootstrap:
	script/bootstrap

test: clean bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) test

clean:
	rm -f "$(OUTPUT_PACKAGE)"
	rm -rf "$(TEMPORARY_FOLDER)"
	$(BUILD_TOOL) $(XCODEFLAGS) -configuration Debug clean
	$(BUILD_TOOL) $(XCODEFLAGS) -configuration Release clean
	$(BUILD_TOOL) $(XCODEFLAGS) -configuration Test clean

install: package
	sudo installer -pkg SourceKitten.pkg -target /

uninstall:
	rm -rf "$(FRAMEWORKS_FOLDER)/SourceKittenFramework.framework"
	rm -f "$(BINARIES_FOLDER)/sourcekitten"

installables: clean bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) install

	mkdir -p "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)"
	mv -f "$(SOURCEKITTEN_FRAMEWORK_BUNDLE)" "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/SourceKittenFramework.framework"
	mv -f "$(SOURCEKITTEN_EXECUTABLE)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/sourcekitten"
	rm -rf "$(BUILT_BUNDLE)"

prefix_install: installables
	mkdir -p "$(FRAMEWORKS_FOLDER)" "$(BINARIES_FOLDER)"
	cp -Rf "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/SourceKittenFramework.framework" "$(FRAMEWORKS_FOLDER)/"
	cp -f "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/sourcekitten" "$(BINARIES_FOLDER)/"

package: installables
	pkgbuild \
		--component-plist "$(COMPONENTS_PLIST)" \
		--identifier "com.sourcekitten.SourceKitten" \
		--install-location "/" \
		--root "$(TEMPORARY_FOLDER)" \
		--version "$(VERSION_STRING)" \
		"$(OUTPUT_PACKAGE)"

archive:
	carthage build --no-skip-current --platform mac
	carthage archive SourceKittenFramework

release: package archive

swift_snapshot_install:
	curl https://swift.org/builds/development/xcode/$(SWIFT_SNAPSHOT)/$(SWIFT_SNAPSHOT)-osx.pkg -o swift.pkg
	sudo installer -pkg swift.pkg -target /

spm:
	$(SWIFT_BUILD_COMMAND) -v

spm_test: PATH:=/Library/Developer/Toolchains/$(SWIFT_SNAPSHOT).xctoolchain/usr/bin/:$(PATH)
spm_test: spm
	$(SWIFT_TEST_COMMAND)

spm_clean:
	$(SWIFT_BUILD_COMMAND) --clean

spm_clean_dist:
	$(SWIFT_BUILD_COMMAND) --clean=dist
