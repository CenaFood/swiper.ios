platform :ios, '11.0'
source 'https://github.com/cocoapods/specs.git'
use_frameworks!

target 'cena' do
  pod 'Koloda'#, :path => "./"
  pod 'TransitionButton'
  pod 'Kingfisher', '~> 4.0'
  pod 'Instructions'
  pod 'JWTDecode', '~> 2.1'
  pod 'ReachabilitySwift', '~> 4.1.0'
  pod 'ActiveLabel'
  pod "PromiseKit", "~> 6.0"
  pod 'UICircularProgressRing', '~> 3.3.2'
  pod 'SwiftEntryKit'
  pod 'LTMorphingLabel'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
 # `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end
