Pod::Spec.new do |s|
s.name         = 'IndexArray'
s.version      = '1.0.1'
s.summary      = 'The combination of dictionary and array.'
s.homepage     = 'https://github.com/lincf0912/IndexArray'
s.license      = 'MIT'
s.author       = { 'lincf0912' => 'dayflyking@163.com' }
s.platform     = :ios
s.ios.deployment_target = '7.0'
s.source       = { :git => 'https://github.com/lincf0912/IndexArray.git', :tag => s.version, :submodules => true }
s.requires_arc = true
s.source_files = 'IndexArrayDemo/class/*.{h,m}'
s.public_header_files = 'IndexArrayDemo/class/*.h'

end
