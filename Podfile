platform :ios, '11.0'
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target 'cena' do
  pod "Koloda", :path => "./"
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'TransitionButton'
  pod 'Kingfisher', '~> 4.0'
  pod 'Instructions', '~> 1.0.0'
  pod 'JWTDecode', '~> 2.1'
  pod 'ReachabilitySwift'
end

post_install do |installer|
  `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end
