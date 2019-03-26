TEMPORARY_FOLDER?=/tmp/SourceKitten.dst
PREFIX?=/usr/local
BUILD_TOOL?=xcodebuild

XCODEFLAGS=-workspace 'SourceKitten.xcworkspace' \
	-scheme 'sourcekitten' \
	DSTROOT=$(TEMPORARY_FOLDER) \
	OTHER_LDFLAGS=-Wl,-headerpad_max_install_names

SWIFT_BUILD_FLAGS=--configuration release
UNAME=$(shell uname)
ifeq ($(UNAME), Darwin)
USE_SWIFT_STATIC_STDLIB:=$(shell test -d $$(dirname $$(xcrun --find swift))/../lib/swift_static/macosx && echo yes)
ifeq ($(USE_SWIFT_STATIC_STDLIB), yes)
SWIFT_BUILD_FLAGS+= -Xswiftc -static-stdlib
endif
endif

SOURCEKITTEN_EXECUTABLE=$(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)/sourcekitten

FRAMEWORKS_FOLDER=$(PREFIX)/Frameworks
BINARIES_FOLDER=$(PREFIX)/bin

OUTPUT_PACKAGE=SourceKitten.pkg

SOURCEKITTEN_PLIST=Source/sourcekitten/Info.plist
SOURCEKITTENFRAMEWORK_PLIST=Source/SourceKittenFramework/Info.plist

VERSION_STRING=$(shell /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$(SOURCEKITTEN_PLIST)")

.PHONY: all bootstrap clean install package test uninstall

all: build

bootstrap:
	script/bootstrap

test: clean_xcode bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) test

clean:
	rm -f "$(OUTPUT_PACKAGE)"
	rm -rf "$(TEMPORARY_FOLDER)"
	swift package clean

clean_xcode: clean
	$(BUILD_TOOL) $(XCODEFLAGS) -configuration Test clean

build:
	swift build $(SWIFT_BUILD_FLAGS)

build_with_disable_sandbox:
	swift build --disable-sandbox $(SWIFT_BUILD_FLAGS)

install: clean build
	install -d "$(BINARIES_FOLDER)"
	install "$(SOURCEKITTEN_EXECUTABLE)" "$(BINARIES_FOLDER)"

uninstall:
	rm -rf "$(FRAMEWORKS_FOLDER)/SourceKittenFramework.framework"
	rm -f "$(BINARIES_FOLDER)/sourcekitten"

installables: clean build
	install -d "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)"
	install "$(SOURCEKITTEN_EXECUTABLE)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)"

prefix_install: clean build_with_disable_sandbox
	install -d "$(PREFIX)/bin/"
	install "$(SOURCEKITTEN_EXECUTABLE)" "$(PREFIX)/bin/"

package: installables
	pkgbuild \
		--identifier "com.sourcekitten.SourceKitten" \
		--install-location "/" \
		--root "$(TEMPORARY_FOLDER)" \
		--version "$(VERSION_STRING)" \
		"$(OUTPUT_PACKAGE)"

archive:
	carthage build --no-skip-current --platform mac
	carthage archive SourceKittenFramework Yams SWXMLHash

release: package archive

docker_test:
	docker run -v `pwd`:`pwd` -w `pwd` --name sourcekitten --rm norionomura/swift:42 swift test --parallel

docker_htop:
	docker run -it --rm --pid=container:sourcekitten terencewestphal/htop || reset

# http://irace.me/swift-profiling/
display_compilation_time:
	$(BUILD_TOOL) $(XCODEFLAGS) OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies" clean build-for-testing | grep -E ^[1-9]{1}[0-9]*.[0-9]+ms | sort -n

publish:
	brew update && brew bump-formula-pr --tag=$(shell git describe --tags) --revision=$(shell git rev-parse HEAD) sourcekitten
	pod trunk push --verbose

update_clang_headers:
	rm -rf Source/Clang_C/include
	svn export http://llvm.org/svn/llvm-project/cfe/trunk/include/clang-c
	mv clang-c Source/Clang_C/include
	rm Source/Clang_C/include/module.modulemap
	echo '#include "BuildSystem.h"\n#include "CXCompilationDatabase.h"\n#include "CXErrorCode.h"\n#include "CXString.h"\n#include "Documentation.h"\n#include "Index.h"\n#include "Platform.h"' > Source/Clang_C/include/Clang_C.h
	sed -i '' "s/^#include \"clang-c\/\(.*\)\"/#include \"\1\"/g" Source/Clang_C/include/*

update_commandant_fixtures: update_commandant_fixtures_macos update_commandant_fixtures_docker

update_commandant_fixtures_macos:
	for identifier in org.swift.40320171205a org.swift.41220180531a ; do \
		swift package reset ; \
		OVERWRITE_FIXTURES=1 xcrun --toolchain $$identifier swift test --filter Commandant ; \
	done

update_commandant_fixtures_docker:
	for image in norionomura/swift:403 norionomura/swift:412 norionomura/swift:4220180706a ; do \
		swift package reset ; \
		docker run -t -v `pwd`:`pwd` -w `pwd` --rm $$image env OVERWRITE_FIXTURES=1 swift test --filter Commandant ; \
	done

get_version:
	@echo $(VERSION_STRING)

set_version:
	$(eval NEW_VERSION := $(filter-out $@,$(MAKECMDGOALS)))
	@sed -i '' 's/## Master/## $(NEW_VERSION)/g' CHANGELOG.md
	@sed 's/__VERSION__/$(NEW_VERSION)/g' script/Version.swift.template > Source/SourceKittenFramework/Version.swift
	@/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $(NEW_VERSION)" "$(SOURCEKITTENFRAMEWORK_PLIST)"
	@/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $(NEW_VERSION)" "$(SOURCEKITTEN_PLIST)"

%:
	@:
