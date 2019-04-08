## 0.23.0

##### Breaking

* None.

##### Enhancements

* Introduce `XcodeBuildSetting` for interacting with project build settings.  
  [Chris Zielinski](https://github.com/chriszielinski)

* Improve module name inference for `Module`.  
  [Chris Zielinski](https://github.com/chriszielinski)

* Add Swift 5 support. Add new `SwiftDeclarationAttributeKind` and
  `SwiftDeclarationKind` members and make those enums conform to
  `CaseIterable`.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Bug Fixes

* “.swift”-suffixed directory in xcodebuild arguments no longer detected as
  Swift file.  
  [Minh Nguyễn](https://github.com/1ec5)
  [#574](https://github.com/jpsim/SourceKitten/issues/574)

* Fix `xcodebuild clean` path for new build system and Xcode 10.2.  
  [John Fairhurst](https://github.com/johnfairh)
  [realm/jazzy#1057](https://github.com/realm/jazzy/issues/1057)

* Pathnames containing shell-escaped characters in xcodebuild arguments no
  longer prevent documentation generation.  
  [John Fairhurst](https://github.com/johnfairh)

* `swiftc` no longer passed as a compiler argument when using `doc` and
  the new build system.  
  [John Fairhurst](https://github.com/johnfairh)

## 0.22.0

##### Breaking

* SourceKitten now requires Swift 4.2 or higher to build.  
  [JP Simard](https://github.com/jpsim)

##### Enhancements

* Add `Request.syntaxTree` to get a serialized representation of the file's
  SwiftSyntax tree.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* Fix crash in `NSString.location(fromByteOffset:)` when using unicode
  characters.  
  [JP Simard](https://github.com/jpsim)
  [realm/SwiftLint#2276](https://github.com/realm/SwiftLint/issues/2276)

## 0.21.3

This is the last release to support building with Swift 4.0 and Swift 4.1.

##### Breaking

* None.

##### Enhancements

* If New Build System is enabled on Xcode, the `doc` command does not need to
  use the `clean` action on `xcodebuild`.  
  [Norio Nomura](https://github.com/norio-nomura)

* Use 'as' bridging on Linux when using Swift 4.2.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* None.

## 0.21.2

##### Breaking

* None.

##### Enhancements

* Add support for C-language annotations
  (e.g. `__attribute__((annotate("This is an annotation")))`).  
  [Jeff Verkoeyen](https://github.com/jverkoey)

* Improve support for building & running with Swift 4.2.  
  [Norio Nomura](https://github.com/norio-nomura)

* Add new values for `SwiftDeclarationAttributeKind` and `SyntaxKind` with
  Swift 4.2.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* None.

## 0.21.1

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* Support building with Swift 4.2. There are still runtime issues to resolve.  
  [Norio Nomura](https://github.com/norio-nomura)

* Fix a crash when running with Swift 4.2.  
  [Norio Nomura](https://github.com/norio-nomura)
  [SR-7954](https://bugs.swift.org/browse/SR-7954)

## 0.21.0

##### Breaking

* SourceKitten now requires Swift 4.0 or higher to build.  
  [JP Simard](https://github.com/jpsim)

##### Enhancements

* Make all `SwiftDeclarationAttributeKind` cases available no matter
  which version of Swift was used to compile SourceKitten.  
  [Marcelo Fabri](https://github.com/marcelofabri)

##### Bug Fixes

* Fix issue locating `libsourcekitdInProc.so` on some Linux distributions.  
  [Mike Hovan](https://github.com/mhovan)
  [#513](https://github.com/jpsim/SourceKitten/issues/513)

## 0.20.0

This is the last release to support Swift 3.2 and Swift 3.3.
The next release will require Swift 4.0 or higher.

##### Breaking

* Change type of parameter from `sourcekitd_object_t` to `SourceKitObject?`.  
  - `File.process(dictionary:cursorInfoRequest:syntaxMap:)`
  - `Request.customRequest(request:)`
  - `SwiftDocs.init(file:dictionary:cursorInfoRequest:)`
  [Norio Nomura](https://github.com/norio-nomura)

* Remove `File.lines:setter`.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Enhancements

* Add `SwiftDeclarationAttributeKind` that represents declaration attributes in
  Swift.  
  [Daniel Metzing](https://github.com/dirtydanee)
  [#504](https://github.com/jpsim/SourceKitten/issues/504)

* Add `SourceKitObject` that represents `sourcekitd_object_t` in Swift.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#489](https://github.com/jpsim/SourceKitten/issues/489)

* Replaced linear index search with binary search in NSString extension.  
  [Tamas Lustyik](https://github.com/lvsti)

* SourceKit search strategy improved on Linux. Supports swiftenv.  
  [Alexander Lash](https://github.com/abl)

* Add `elements` case to `SwiftDocKey`.  
  [Sho Ikeda](https://github.com/ikesyo)

* Added `module_info` command to `sourcekitten` CLI.  
  [Erik Abair](https://github.com/abaire)

##### Bug Fixes

* Fix `index` command fails using filename with spaces in compiler arguments.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#480](https://github.com/jpsim/SourceKitten/issues/480)

* Only allow U+000A and U+000D as line break tokens.  
  [Marcelo Fabri](https://github.com/marcelofabri)
  [#475](https://github.com/jpsim/SourceKitten/issues/475)

* Fix ThreadSanitizer reports data race warning in SwiftLint.  
  [Norio Nomura](https://github.com/norio-nomura)
  [realm/SwiftLint#2089](https://github.com/realm/SwiftLint/issues/2089)

## 0.19.1

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* Fix Swift Package Manager warnings when using SourceKitten targets as
  dependencies.  
  [JP Simard](https://github.com/jpsim)
  [#478](https://github.com/jpsim/SourceKitten/issues/478)

## 0.19.0

##### Breaking

* SourceKitten now requires Xcode 9 and Swift 3.2+ to build.  
  [Norio Nomura](https://github.com/norio-nomura)

* Deprecated `Request.failableSend()`. Please use `Request.send()` instead.  
  [Norio Nomura](https://github.com/norio-nomura)

* Some APIs changed to `throws`.  
  * `File.format(trimmingTrailingWhitespace:useTabs:indentWidth:) throws`
  * `Structure.init(file:) throws`
  * `SyntaxMap.init(file:) throws`
  [Norio Nomura](https://github.com/norio-nomura)

##### Enhancements

* Return `SWIFT_NAME` when generating Objective-C docs.  
  [Ibrahim Ulukaya](https://github.com/ulukaya)

##### Bug Fixes

* Fix Swift declarations when generating Objective-C docs for generic types.  
  [John Fairhurst](https://github.com/johnfairh)

## 0.18.4

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* Fix Swift 4.0.2 deprecation warnings in dependencies, specifically
  SWXMLHash.  
  [Norio Nomura](https://github.com/norio-nomura)

## 0.18.3

##### Breaking

* None.

##### Enhancements

* Support Swift 4.0.2.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#435](https://github.com/jpsim/SourceKitten/issues/435)

##### Bug Fixes

* Preserve horizontal alignment in multi-line Swift declarations.  
  [John Fairhurst](https://github.com/johnfairh)

## 0.18.2

##### Breaking

* None.

##### Enhancements

* Add `tabWidth` parameter (default: `1`) for `lineAndCharacter`.  
  [Marcel Jackwerth](https://github.com/sirlantis)

* Add `File(pathDeferringReading:)` initializer.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* Fix Swift declarations when generating Objective-C docs being truncated where
  ampersands were included.  
  [JP Simard](https://github.com/jpsim)

## 0.18.1

##### Breaking

* None.

##### Enhancements

* Updates to support Xcode 9 beta 5 & accompanying versions of Swift 3.2/4.0.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* Fix compilation failures due to long debug times by removing compiler flag:
  `-warn-long-function-bodies=200`.  
  [Marcelo Fabri](https://github.com/marcelofabri)

## 0.18.0

##### Breaking

* Xcode 8.3 or later and Swift 3.1 or later are required to build.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Enhancements

* Cache `NSString.CacheContainer` on Linux, matching behavior on Darwin,
  speeding up many repeated operations on `NSString` on Linux.  
  [JP Simard](https://github.com/jpsim)
  [realm/SwiftLint#1577](https://github.com/realm/SwiftLint/issues/1577)

* Process Swift 3.2/4 doc comments.  
  [John Fairhurst](https://github.com/johnfairh)

* Support building with Xcode 9 beta 3 and the latest Swift 4 snapshots.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* None.

## 0.17.6

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* Fix handling of Swift extensions of nested types.  
  [John Fairhurst](https://github.com/johnfairh)

## 0.17.5

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* Improve quality & accuracy of Swift interfaces for Objective-C declarations
  when generating Objective-C docs.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#385](https://github.com/jpsim/SourceKitten/issues/385)

## 0.17.4

##### Breaking

* None.

##### Enhancements

* Generate Swift declaration for more Objective-C methods.  
  [Zheng Li](https://github.com/ainopara)
  [#376](https://github.com/jpsim/SourceKitten/issues/376)

##### Bug Fixes

* Fix running `sourcekitten version` when building with Swift Package Manager.  
  [JP Simard](https://github.com/jpsim)

* Fix crash in `lineAndCharacter(forByteOffset:)` with strings including
  multi-byte unicode characters.  
  [Marcelo Fabri](https://github.com/marcelofabri)
  [realm/SwiftLint#1006](https://github.com/realm/SwiftLint/issues/1006)

* Fix compilation with latest Swift 4 snapshots.  
  [Norio Nomura](https://github.com/norio-nomura)

## 0.17.3

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* More accurate doc comment association in Swift.  
  [John Fairhurst](https://github.com/johnfairh)
  [#368](https://github.com/jpsim/SourceKitten/issues/368)

* Fix crashes when parsing XML with Swift 3.1.1 on Linux.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#379](https://github.com/jpsim/SourceKitten/issues/379)

* Fix compilation with latest Swift 4 snapshots.  
  [Norio Nomura](https://github.com/norio-nomura)

## 0.17.2

##### Breaking

* None.

##### Enhancements

* Update `Cartfile.resolved` & corresponding git submodule to point to Yams
  0.3.1. Also loosen the Yams version dependency in `Package.swift` to only
  specify `~> 0.3` and not `= 0.3.0`.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Bug Fixes

* None.

## 0.17.1

##### Breaking

* None.

##### Enhancements

* Added a new field `numBytesToErase` in `CodeCompletionItem` to indicate how
  many bytes should be deleted prior to the cursor in order to finish the
  completion.  
  [@KelvinJin](https://github.com/KelvinJin)

* Support Swift 3.1 on macOS. `sourcekitInProc` appears to be broken on Linux
  as of Swift 3.1.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#348](https://github.com/jpsim/SourceKitten/issues/348)

##### Bug Fixes

* Fix a crash that occurred when a documentation comment ended with an extended
  grapheme cluster.  
  [Lukas Stührk](https://github.com/Lukas-Stuehrk)
  [#350](https://github.com/jpsim/SourceKitten/issues/350)

## 0.17.0

##### Breaking

* Change `Text` enum case names to match Swift 3 API guidelines.  
  [@istx25](https://github.com/istx25)

##### Enhancements

* None.

##### Bug Fixes

* Make sending `Request`s safer in concurrent environments.  
  [@krzysztofzablocki](https://github.com/krzysztofzablocki)

## 0.16.0

##### Breaking

* The `SourceKitten` CocoaPods podspec used to actually refer to
  SourceKittenFramework, so it has been renamed. Existing pushes to CocoaPods
  trunk will be preserved, but from now on if you use SourceKittenFramework via
  CocoaPods, please specify to use the `SourceKittenFramework` pod.  
  [JP Simard](https://github.com/jpsim)

##### Enhancements

* Add `Request.yaml` API to create a sourcekit request from yaml
  and expose as a `request --yaml [file|text]` CLI command.  
  [Keith Smiley](https://github.com/keith)
  [#312](https://github.com/jpsim/SourceKitten/issues/312)

##### Bug Fixes

* None.

## 0.15.3

##### Breaking

* None.

##### Enhancements

* Reduce compilation time.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Bug Fixes

* None.

## 0.15.2

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* Fix Objective-C enum cases not being documented.  
  [JP Simard](https://github.com/jpsim)
  [#304](https://github.com/jpsim/SourceKitten/issues/304)

## 0.15.1

##### Breaking

* None.

##### Enhancements

* Improve performance of Yaml parsing.  
  [JP Simard](https://github.com/jpsim)
  [#289](https://github.com/jpsim/SourceKitten/issues/289)

##### Bug Fixes

* `CXComment.commandName()` was returning nil on custom code comments
  since Xcode 8.1. This caused a force unwrap when generating
  documentation. Inline command comment is now used as a
  fallback to catch this edge case.  
  [Jérémie Girault](https://github.com/jeremiegirault)

## 0.15.0

##### Breaking

* SourceKitten now requires Xcode 8.0 and Swift 3.0 to build.
  APIs have been adapted to conform to the Swift 3 API Design Guidelines.  
  [JP Simard](https://github.com/jpsim)
  [Norio Nomura](https://github.com/norio-nomura)

##### Enhancements

* Add `--spm-module [ModuleName]` flag to `complete` to automatically detect
  compiler flags for Swift Package Manager modules. `swift build` must be run
  prior to support detection.  
  [vdka](https://github.com/vdka)
  [#270](https://github.com/jpsim/SourceKitten/issues/270)

* Now builds and passes most tests on Linux using the Swift Package Manager with
  Swift 3.0. This requires `libsourcekitdInProc.so` to be built and located in
  `/usr/lib`, or in another location specified by the `LINUX_SOURCEKIT_LIB_PATH`
  environment variable. A preconfigured Docker image is available on Docker Hub
  by the ID of `norionomura/sourcekit:30`.  
  [JP Simard](https://github.com/jpsim)
  [Norio Nomura](https://github.com/norio-nomura)
  [#179](https://github.com/jpsim/SourceKitten/issues/179)

* Now supports Swift Package Manager on macOS and Linux.  
  [JP Simard](https://github.com/jpsim)

* Now supports docinfo requests for sourcetext and module keys.  
  [Erik Abair](https://github.com/abaire)

* Now supports Objective-C class properties.  
  [Jérémie Girault](https://github.com/jeremiegirault)
  [JP Simard](https://github.com/jpsim)
  [#243](https://github.com/jpsim/SourceKitten/issues/243)

* Add podspec to support using SourceKittenFramework with CocoaPods.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* `NSString.lines()` generated surplus line when string ended with newline
  character.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#259](https://github.com/jpsim/SourceKitten/issues/259)

## 0.14.1

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* Fixed Homebrew distribution.  
  [Norio Nomura](https://github.com/norio-nomura)

## 0.14.0

This is the last release to support Swift 2.2 and Swift 2.3.
The next release will require Swift 3.0.

##### Breaking

* Embedding frameworks needed by `sourcekitten` was moved from
  SourceKittenFramework Xcode target to the sourcekitten target.
  The `SourceKittenFramework.framework` product built by the
  SourceKittenFramework target no longer contains unnecessary frameworks or
  multiple copies of the Swift libraries.  
  [Norio Nomura](https://github.com/norio-nomura)

* Require passing compiler arguments to `index` command.  
  [Brian Gesiak](https://github.com/modocache)

* Remove `--compilerargs` CLI flag. Arguments are now passed after `--`.  
  [Keith Smiley](https://github.com/keith)

##### Enhancements

* Refactor to unite swift lang syntax types with SwiftLangSyntax protocol.

* Make SwiftDocKey public.  
  [Evgeny Suvorov](https://github.com/esuvorov)

* Swift 2.3 support.  
  [Syo Ikeda](https://github.com/ikesyo)

* The following availability and deprecation values are now exposed for Objective-C APIs.

  * key.always_deprecated
  * key.always_unavailable
  * key.deprecation_message
  * key.unavailable_message  
  [Jeff Verkoeyen](https://github.com/jverkoey)

* Add `SwiftDeclarationKind.PrecedenceGroup`.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* Fix issue where single-line declaration+bodies would include the body in the
  parsed declaration when generating docs.  
  [JP Simard](https://github.com/jpsim)
  [#45](https://github.com/jpsim/SourceKitten/issues/45)
  [realm/jazzy#226](https://github.com/realm/jazzy/issues/226)

* Fix issue where directories ending with `.swift` would be considered Swift
  source files.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#586](https://github.com/realm/jazzy/issues/586)

## 0.13.0

##### Breaking

* None.

##### Enhancements

* Add `format` command that re-indents a Swift file much like pasting into
  Xcode would. This command optionally takes the following parameters:

  * `--file (string)`: relative or absolute path of Swift file to format
  * `--no-trim-whitespace`: trim trailing whitespace
  * `--use-tabs`: use tabs to indent
  * `--indent-width (integer)`: number of spaces to indent  
  [JP Simard](https://github.com/jpsim)

* Add `--spm-module [ModuleName]` flag to `doc` to document Swift Package
  Manager modules. Need to run `swift build` prior to running
  `sourcekitten doc`. The right Swift toolchain version must also be selected
  (by setting `TOOLCHAIN_DIR` or similar).  
  [JP Simard](https://github.com/jpsim)

* Add support `TOOLCHAINS` environment variable to selecting alternative
  toolchains for loading SourceKitService.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Bug Fixes

* Add support for handling `CXCursor_UnexposedDecl` declarations when
  documenting Objective-C.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#543](https://github.com/realm/jazzy/issues/543)

## 0.12.2

##### Breaking

* None.

##### Enhancements

* Add `index` command.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* None.

## 0.12.1

##### Breaking

* None.

##### Enhancements

* Swift declarations are included when generating Objective-C documentation.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#136](https://github.com/realm/jazzy/issues/136)

##### Bug Fixes

* Fixed situations where the wrong documentation comment was found for a
  declaration, or when documentation comments were further than a single line
  away from their declaration and the declaration would be incorrectly
  considered undocumented.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#454](https://github.com/realm/jazzy/issues/454)
  [realm/jazzy#502](https://github.com/realm/jazzy/issues/502)

## 0.12.0

##### Breaking

* Updated for Xcode 7.3.  
  [JP Simard](https://github.com/jpsim)

##### Enhancements

* None.

##### Bug Fixes

* None.

## 0.11.0

##### Breaking

* Now `libclang.dylib` and `sourcekitd.framework` are dynamically loaded at
  runtime by SourceKittenFramework to use the versions included in the Xcode
  version specified by `xcode-select -p` or custom toolchains. If
  SourceKittenFramework clients previously accessed either of these libraries
  directly using their APIs, those are no longer available.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#167](https://github.com/jpsim/SourceKitten/issues/167)

##### Enhancements

* Simplify the process of generating library wrappers and validate library
  wrappers in unit tests.  
  [JP Simard](https://github.com/jpsim)

* Support `swift test` on OS X.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Bug Fixes

* Fix crash on DOS newlines.  
  [Norio Nomura](https://github.com/norio-nomura)
  [realm/SwiftLint#315](https://github.com/realm/SwiftLint/issues/315)

* Fix doc.comment blank for many declarations, causing missing Jazzy docs.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#142](https://github.com/jpsim/SourceKitten/issues/142)

* Fix "Unrecognized arguments:" error on `doc` command.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#174](https://github.com/jpsim/SourceKitten/issues/174)

* Fix "illegal hardware instruction" error when SourceKitService returns
  string in other than `NSUTF8StringEncoding`.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#184](https://github.com/jpsim/SourceKitten/issues/184)

## 0.10.0

##### Breaking

* Change `SwiftDocs.init(file:arguments:)` to
  `SwiftDocs.init?(file:arguments:)`.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Enhancements

* Add `Request.failableSend()` that can handle SourceKitService crashes.
  `sourcekitten doc` does not stop when SourceKitService crashes.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Bug Fixes

* Fix crash when offset points end of string.  
  [Norio Nomura](https://github.com/norio-nomura)
  [realm/SwiftLint#164](https://github.com/realm/SwiftLint/issues/164)

## 0.9.0

##### Breaking

* Change `Line` from tuple to struct with extra properties `range` and
  `byteRange`.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Enhancements

* None.

##### Bug Fixes

* None.

## 0.8.0

##### Breaking

* Replaced all uses of `XPCDictionary`, `XPCArray`, `XPCRepresentable` &
  `xpc_object_t` with SourceKit equivalents.  
  [JP Simard](https://github.com/jpsim)

##### Enhancements

* Supports building with Swift 2.2 snapshot & Swift Package Manager on OS X.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* Fix crash when file contains NULL character.  
  [Norio Nomura](https://github.com/norio-nomura)
  [realm/SwiftLint#379](https://github.com/realm/SwiftLint/issues/379)

## 0.7.4

##### Breaking

* None.

##### Enhancements

* Add `Structure.init(sourceKitResponse:)`.  
  [Norio Nomura](https://github.com/norio-nomura)

* Improve performance of `Request.send()`.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Bug Fixes

* Add support for parsing module imports in Objective-C.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#452](https://github.com/realm/jazzy/issues/452)

## 0.7.3

##### Breaking

* None.

##### Enhancements

* Add `NSString.lineAndCharacterForByteOffset`.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* Fixed multi-byte character handling in `File.getDocumentationCommentBody`.  
  [JP Simard](https://github.com/jpsim)

## 0.7.2

##### Breaking

* None.

##### Enhancements

* Optimize `NSString.lineAndCharacterForCharacterOffset(...)`,
  `NSString.NSRangeToByteRange(...)` and
  `SyntaxMap.commentRangeBeforeOffset(_:)`.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#119](https://github.com/jpsim/SourceKitten/issues/119)

* Fix unicode handling of `String.commentBody(range:)`.  
  [Norio Nomura](https://github.com/norio-nomura)

##### Bug Fixes

* None.

## 0.7.1

##### Enhancements

* Optimize `NSRange` operation.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#119](https://github.com/jpsim/SourceKitten/issues/119)

## 0.7.0

##### Breaking

* `File` is now a `final class` instead of a `struct` and `contents` & `lines`
  are now marked as `var`. This was done so that mutations to the underlying
  file on disk can be mirrored in a `File` instance.  
  [JP Simard](https://github.com/jpsim)

##### Enhancements

None.

##### Bug Fixes

* Fix issue where Swift extensions would pick up documentation from previous
  tokens.  
  [JP Simard](https://github.com/jpsim)
  [#65](https://github.com/jpsim/SourceKitten/issues/65)

* Fix `String.stringByTrimmingTrailingCharactersInSet(_:)` returning full string
  when all characters matched character set.  
  [JP Simard](https://github.com/jpsim)

* Fix `indexOfByteOffset(offset:)` failing when string include some emoji.  
  [Norio Nomura](https://github.com/norio-nomura)

* Fix pragma mark extraction with multibyte characters.  
  [1ec5](https://github.com/1ec5)
  [#114](https://github.com/jpsim/SourceKitten/issues/114)

## 0.6.2

##### Breaking

None.

##### Enhancements

* Increase robustness of file path handling.  
  [Boris Bügling](https://github.com/neonichu)
  [#86](https://github.com/jpsim/SourceKitten/issues/86)

##### Bug Fixes

* Add support for C/C++ struct, field & ivar types.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#374](https://github.com/realm/jazzy/issues/374)
  [realm/jazzy#387](https://github.com/realm/jazzy/issues/387)


## 0.6.1

##### Breaking

None.

##### Enhancements

* Support "wall of asterisk" documentation comments.  
  [Jeff Verkoeyen](https://github.com/jverkoey)

##### Bug Fixes

* Fix a string interpolation issue when generating completion options.  
  [Benedikt Terhechte](https://github.com/terhechte)
  [#97](https://github.com/jpsim/SourceKitten/issues/97)

* Fix an out-of-bounds exception when generating pragma marks.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#370](https://github.com/realm/jazzy/issues/370)


## 0.6.0

##### Breaking

None.

##### Enhancements

* Ability to generate Objective-C documentation.  
  [Thomas Goyne](https://github.com/tgoyne)
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* Don't process SourceKit's response when building Structure.  
  [JP Simard](https://github.com/jpsim)
  [#82](https://github.com/jpsim/SourceKitten/issues/82)


## 0.5.2

##### Breaking

None.

##### Enhancements

* Add `compilerargs` option to complete command.  
  [Masayuki Yamaya](https://github.com/yamaya)

* Add support for Xcode 7.1.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* Fix a bug where documentation inside a function would crash SourceKitten.  
  [JP Simard](https://github.com/jpsim)
  [#75](https://github.com/jpsim/SourceKitten/issues/75)


## 0.5.1

##### Breaking

None.

##### Enhancements

* Improve error reporting when compiler arguments can't be parsed and log
  `xcodebuild` output to file instead of stderr.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

None.


## 0.5.0

##### Breaking

* Updated to Swift 2.0.  
  [JP Simard](https://github.com/jpsim)

##### Enhancements

* Update `File` `lines` convenience property to be immutable.  
  [Keith Smiley](https://github.com/keith)

* Added the ability to generate code completion options (`complete` command).  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

None.


## 0.4.5

##### Breaking

None.

##### Enhancements

* Add `lines` convenience property to `File`  
  [Keith Smiley](https://github.com/keith)

##### Bug Fixes

None.


## 0.4.4

##### Breaking

* Simplified rpath's.  
  [JP Simard](https://github.com/jpsim)

##### Enhancements

None.

##### Bug Fixes

* Fixed a crash when parsing an empty documentation comment.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#236](https://github.com/realm/jazzy/issues/236)


## 0.4.3

##### Breaking

None.

##### Enhancements

None.

##### Bug Fixes

* Fixed issue when installing 0.4.2 via Homebrew.  
  [JP Simard](https://github.com/jpsim)


## 0.4.2

##### Breaking

None.

##### Enhancements

None.

##### Bug Fixes

* SourceKitten can now be installed alongside Carthage because
  SourceKittenFramework now nests its Commandant and LlamaKit frameworks.  
  [JP Simard](https://github.com/jpsim)


## 0.4.1

##### Breaking

* SwiftDocs now prints its file path in its `description`.  
  [JP Simard](https://github.com/jpsim)

##### Enhancements

None.

##### Bug Fixes

None.


## 0.4.0

##### Breaking

* Requires Swift 1.2 to build.  
  [JP Simard](https://github.com/jpsim)

##### Enhancements

None.

##### Bug Fixes

None.


## 0.3.2

##### Breaking

None.

##### Enhancements

* Added definition line ranges to declarations.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#198](https://github.com/realm/jazzy/issues/198)

* Parse `doc.full_as_xml`.  
  [JP Simard](https://github.com/jpsim)
  [#37](https://github.com/jpsim/SourceKitten/issues/37)

* Parse documentation comments.  
  [JP Simard](https://github.com/jpsim)

##### Bug Fixes

* Fixed out-of-bounds exception when parsing the declaration in files starting
  with a declaration.  
  [JP Simard](https://github.com/jpsim)
  [#30](https://github.com/jpsim/SourceKitten/issues/30)

* Fixed out-of-bounds exception and inaccurate parsed declarations when using
  multibyte characters.  
  [JP Simard](https://github.com/jpsim)
  [#35](https://github.com/jpsim/SourceKitten/issues/35)

* Fixed parsing issues with keyword functions such as `subscript`, `init` and
  `deinit`.  
  [JP Simard](https://github.com/jpsim)
  [#27](https://github.com/jpsim/SourceKitten/issues/27)

* Fixed issues where USR wasn't accurate because dependencies couldn't be
  resolved.  
  [JP Simard](https://github.com/jpsim)


## 0.3.0

##### Breaking

* Everything. No, seriously lots has changed in this release and you should
  consider SourceKitten entirely rewritten. SourceKitten now uses dynamic
  frameworks for the bulk of its functionality, which means that everything is
  now much more modular and testable.  
  [JP Simard](https://github.com/jpsim)
  [#17](https://github.com/jpsim/SourceKitten/issues/17)

##### Enhancements

* Consolidated error generation.  
  [JP Simard](https://github.com/jpsim)
  [#24](https://github.com/jpsim/SourceKitten/issues/24)

##### Bug Fixes

None.

## 0.2.8

##### Breaking

None.

##### Enhancements

None.

##### Bug Fixes

* Fixed issue where certain Swift files wouldn't be parsed.  
  [JP Simard](https://github.com/jpsim)
  [#18](https://github.com/jpsim/SourceKitten/issues/18)

## 0.2.7

##### Breaking

None.

##### Enhancements

None.

##### Bug Fixes

* Fixed improper UTF8 parsing of MARK comments.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#131](https://github.com/realm/jazzy/issues/131)

## 0.2.6

##### Breaking

None.

##### Enhancements

* Added CHANGELOG.md.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#125](https://github.com/realm/jazzy/issues/125)

* Include parse errors in the JSON output.  
  [JP Simard](https://github.com/jpsim)
  [#16](https://github.com/jpsim/SourceKitten/issues/16)

##### Bug Fixes

* Fixed crash when files contained a declaration on the first line.  
  [JP Simard](https://github.com/jpsim)
  [#14](https://github.com/jpsim/SourceKitten/issues/14)

* Fixed invalid JSON issue when last file in an Xcode project failed to parse.  
  [JP Simard](https://github.com/jpsim)

* Fixed crash when attempting to parse the declaration of `extension Array`.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#126](https://github.com/realm/jazzy/issues/126)
