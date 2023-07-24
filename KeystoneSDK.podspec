Pod::Spec.new do |spec|
  spec.name         = "KeystoneSDK"
  spec.version      = "0.6.0"
  spec.summary      = "A library to simplify the way how software wallets communicate with the Keystone hardware wallet via UR."
  spec.homepage     = "https://github.com/KeystoneHQ/keystone-sdk-ios"
  spec.license      = { :type => 'Copyright', :text => 'Copyright 2023 Keystone' }
  spec.author       = "Keystone"
  spec.social_media_url   = "https://twitter.com/KeystoneWallet"
  spec.swift_version = "5.6"
  spec.platform = :ios, '13.0'
  spec.source       = { :git => "https://github.com/KeystoneHQ/keystone-sdk-ios.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/KeystoneSDK/*.swift", "Sources/KeystoneSDK/**/*.swift"
  spec.requires_arc = true
  spec.static_framework = true
  spec.dependency "URRegistryFFI", "~> 0.2.0"
  spec.dependency "URKit", "~> 10.1.0"
end
