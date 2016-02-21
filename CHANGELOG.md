## Master

##### Breaking

* Now `libclang.dylib` and `sourcekitd.framework` are dynamicaly loaded on
  runtime by `SourceKittenFramework`. Depending client might need some
  modification if referencing them from language other than Swift.  
  [Norio Nomura](https://github.com/norio-nomura)
  [#167](https://github.com/jpsim/SourceKitten/issues/167)

##### Enhancements

* None.

##### Bug Fixes

* None.

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
  [#164](https://github.com/realm/SwiftLint/issues/164)

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
