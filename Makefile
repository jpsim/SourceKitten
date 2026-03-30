TEMPORARY_FOLDER?=/tmp/SourceKitten.dst
PREFIX?=/usr/local
BUILD_TOOL?=xcodebuild

XCODEFLAGS=-workspace 'SourceKitten.xcworkspace' \
	-scheme 'sourcekitten' \
	DSTROOT=$(TEMPORARY_FOLDER) \
	OTHER_LDFLAGS=-Wl,-headerpad_max_install_names

SWIFT_BUILD_FLAGS=--configuration release

SOURCEKITTEN_EXECUTABLE=$(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)/sourcekitten

FRAMEWORKS_FOLDER=$(PREFIX)/Frameworks
BINARIES_FOLDER=$(PREFIX)/bin

OUTPUT_PACKAGE=SourceKitten.pkg

SOURCEKITTEN_PLIST=Source/sourcekitten/Info.plist
SOURCEKITTENFRAMEWORK_PLIST=Source/SourceKittenFramework/Info.plist

VERSION_STRING="$(shell ./script/get-version)"

.PHONY: all clean install package test uninstall release

all: build

test: clean_xcode
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

installables: build
	rm -f "$(OUTPUT_PACKAGE)"
	rm -rf "$(TEMPORARY_FOLDER)"
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

release:
	$(eval ARGS := $(filter-out $@,$(MAKECMDGOALS)))
	$(eval VERSION := $(word 1,$(ARGS)))
	$(eval RELEASE_NAME := $(wordlist 2,100,$(ARGS)))
	@if [ -z "$(VERSION)" ] || [ -z "$(RELEASE_NAME)" ]; then \
		echo "usage: make release <version> <release name>"; \
		exit 1; \
	fi
	@# Set version
	@sed -i '' 's/## Main/## $(VERSION)/g' CHANGELOG.md
	@sed 's/__VERSION__/$(VERSION)/g' script/Version.swift.template > Source/SourceKittenFramework/Version.swift
	@sed -e '3s/.*/    version = "$(VERSION)",/' -i '' MODULE.bazel
	@# Commit, tag, push
	git commit -am "Release $(VERSION)"
	git tag -a "$(VERSION)" -m "$(VERSION): $(RELEASE_NAME)"
	git push origin main
	git push origin "$(VERSION)"
	@# Build pkg
	$(MAKE) package
	@# Download source tarball for BCR stable URL
	curl -fsSL --retry 5 "https://github.com/jpsim/SourceKitten/archive/refs/tags/$(VERSION).tar.gz" \
		-o "SourceKitten-$(VERSION).tar.gz"
	@# Create GitHub release
	gh release create "$(VERSION)" \
		"$(OUTPUT_PACKAGE)" \
		"SourceKitten-$(VERSION).tar.gz" \
		--title "$(VERSION): $(RELEASE_NAME)" \
		--notes "$$(sed -n '/^## $(VERSION)/,/^## /{/^## $(VERSION)/d;/^## /d;p;}' CHANGELOG.md)"
	rm -f "SourceKitten-$(VERSION).tar.gz"
	@# Add empty changelog section
	@printf '## Main\n\n#### Breaking\n\n* None.\n\n#### Enhancements\n\n* None.\n\n#### Bug Fixes\n\n* None.\n\n' | cat - CHANGELOG.md > /tmp/CHANGELOG.md.tmp
	@mv /tmp/CHANGELOG.md.tmp CHANGELOG.md
	git commit -am "Add empty changelog section"
	git push origin main

docker_test:
	docker run -v `pwd`:`pwd` -w `pwd` --name sourcekitten --rm swift:5.10-focal swift test --parallel

docker_htop:
	docker run -it --rm --pid=container:sourcekitten terencewestphal/htop || reset

# http://irace.me/swift-profiling/
display_compilation_time:
	$(BUILD_TOOL) $(XCODEFLAGS) OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies" clean build-for-testing | grep -E ^[1-9]{1}[0-9]*.[0-9]+ms | sort -n

update_clang_headers:
	rm -rf Source/Clang_C/include
	svn export http://llvm.org/svn/llvm-project/cfe/trunk/include/clang-c
	mv clang-c Source/Clang_C/include
	rm Source/Clang_C/include/module.modulemap
	echo '#include "BuildSystem.h"\n#include "CXCompilationDatabase.h"\n#include "CXErrorCode.h"\n#include "CXString.h"\n#include "Documentation.h"\n#include "Index.h"\n#include "Platform.h"' > Source/Clang_C/include/Clang_C.h
	sed -i '' "s/^#include \"clang-c\/\(.*\)\"/#include \"\1\"/g" Source/Clang_C/include/*

update_fixtures: update_fixtures_macos update_fixtures_docker

update_fixtures_macos:
	for identifier in org.swift.50120190418a org.swift.5120190905a ; do \
		swift package reset ; \
		OVERWRITE_FIXTURES=1 xcrun --toolchain $$identifier swift test ; \
	done

update_fixtures_docker:
	for image in swift:5.2 swift:5.3; do \
		swift package reset ; \
		docker run -t -v `pwd`:`pwd` -w `pwd` --rm $$image env OVERWRITE_FIXTURES=1 swift test ; \
	done

get_version:
	@echo $(VERSION_STRING)


%:
	@:
