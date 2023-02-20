Pod::Spec.new do |s|
  s.name                = 'SourceKittenFramework'
  s.version             = `make get_version`
  s.summary             = 'An adorable little framework for interacting with SourceKit.'
  s.homepage            = 'https://github.com/jpsim/SourceKitten'
  s.source              = { git: s.homepage + '.git', tag: s.version }
  s.license             = { type: 'MIT', file: 'LICENSE' }
  s.author              = { 'JP Simard' => 'jp@jpsim.com' }
  s.platform            = :osx, '12'
  s.source_files        = 'Source/Clang_C/include/*.h', 'Source/SourceKit/include/*.h', 'Source/SourceKittenFramework/*.swift'
  s.swift_versions      = ['5.3', '5.4', '5.5', '5.6', '5.7']
  s.pod_target_xcconfig = { 'APPLICATION_EXTENSION_API_ONLY' => 'YES' }
  s.dependency            'SWXMLHash', '~> 7.0.0'
  s.dependency            'Yams', '~> 5.0.0'
end
