Pod::Spec.new do |s|
  s.name         = 'SourceKitten'
  s.module_name  = 'SourceKittenFramework'
  s.version      = '0.15.0'
  s.summary      = 'An adorable little framework for interacting with SourceKit.'
  s.homepage     = 'https://github.com/jpsim/SourceKitten'
  s.source       = { :git => s.homepage + '.git', :tag => s.version }
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'JP Simard' => 'jp@jpsim.com' }
  s.platform     = :osx, '10.9'
  s.source_files = 'Source/SourceKittenFramework/{*.swift,sourcekitd.h,clang-c/*.h}'
  s.dependency     'SWXMLHash', '~> 3.0'
  s.dependency     'Yaml', '~> 3.0'
end
