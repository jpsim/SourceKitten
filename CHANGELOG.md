## Master

##### Breaking

* None.

##### Enhancements

* None.

##### Bug Fixes

* None.

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
  [jazzy#226](https://github.com/realm/jazzy/issues/226)

* Fix issue where directories ending with `.swift` would be considered Swift
  source files.  
  [JP Simard](https://github.com/jpsim)
  [jazzy#586](https://github.com/realm/jazzy/issues/586)

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
  [#315](https://github.com/realm/SwiftLint/issues/315)

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
  [SwiftLint#164](https://github.com/realm/SwiftLint/issues/164)

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
  [SwiftLint#379](https://github.com/realm/SwiftLint/issues/379)

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
  [jazzy#452](https://github.com/realm/jazzy/issues/452)

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
  [#111](https://github.com/jpsim/SourceKitten/pull/111)

* Fix pragma mark extraction with multibyte characters.  
  [1ec5](https://github.com/1ec5)
  [#114](https://github.com/jpsim/SourceKitten/pull/114)

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
  [jazzy#374](https://github.com/realm/jazzy/issues/374)
  [jazzy#387](https://github.com/realm/jazzy/issues/387)


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
  [jazzy#370](https://github.com/realm/jazzy/issues/370)


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
  [#236](https://github.com/realm/jazzy/issues/236)


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
  [#198](https://github.com/realm/jazzy/issues/198)

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
  [#18](https://github.com/jpsim/sourcekitten/issues/18)

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
  [#16](https://github.com/jpsim/sourcekitten/issues/16)

##### Bug Fixes

* Fixed crash when files contained a declaration on the first line.  
  [JP Simard](https://github.com/jpsim)
  [#14](https://github.com/jpsim/sourcekitten/issues/14)

* Fixed invalid JSON issue when last file in an Xcode project failed to parse.  
  [JP Simard](https://github.com/jpsim)

* Fixed crash when attempting to parse the declaration of `extension Array`.  
  [JP Simard](https://github.com/jpsim)
  [realm/jazzy#126](https://github.com/realm/jazzy/issues/126)
