# Uncomment the next line to define a global platform for your project
use_frameworks!
inhibit_all_warnings!

workspace 'FirebaseLoggs.xcworkspace'

target 'XCGLogger+Firebase' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  platform :ios, '10.0'
  project 'XCGLogger+Firebase.xcodeproj'

  # Pods for XCGLogger+Firebase
  pod 'XCGLogger'
  pod 'XCGLogger/UserInfoHelpers'
  pod 'CryptoSwift'
  pod 'FirebaseCommunity/Database'
end

target 'LogViewer' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  platform :macos, '10.12'
  project 'LogViewer.xcodeproj'

  # Pods for XCGLogger+Firebase
  pod 'CryptoSwift'
  pod 'FirebaseCommunity/Database'
end
