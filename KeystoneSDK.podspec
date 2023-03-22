#
# Be sure to run `pod lib lint KeystoneSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KeystoneSDK'
  s.version          = '0.1.0'
  s.summary          = 'The Keystone SDK for Keystone hardware wallet integration'
  s.description      = <<-DESC
The Keystone SDK is built for Keystone hardware wallet integration with watch-only wallets,
which focuses on syncing accounts, generating sign requests, and parsing signatures via UR.
                       DESC

  s.homepage         = 'https://github.com/LiYanLance/KeystoneSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiYanLance' => 'liyan1924@gmail.com' }
  s.source           = { :git => 'https://github.com/KeystoneHQ/keystone-sdk-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.0'
  s.swift_version = '5.0'

#  s.source_files = 'KeystoneSDK/Classes/**/*'
  s.source_files = 'Sources/KeystoneSDK/**/*'
  s.ios.vendored_frameworks = 'Library/*.xcframework'

  # s.resource_bundles = {
  #   'KeystoneSDK' => ['KeystoneSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
