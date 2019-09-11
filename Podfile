# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'Demo' do
  use_frameworks!

  pod 'SwiftLint'
  pod 'PromiseKit'
  pod 'Realm', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
  pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
  pod 'RxCocoa'
  pod 'RxSwift'
  
  target 'DemoTests' do
    inherit! :search_paths
  end

  target 'DemoUITests' do
    inherit! :search_paths
  end

end
