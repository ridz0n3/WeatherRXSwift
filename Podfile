# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Weather Forecast' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Weather Forecast
  pod 'RxSwift', '~> 3.0.0.beta.1'
  pod 'RxCocoa', '~> 3.0.0.beta.1'
  pod 'Argo'
  pod 'Curry'
  pod 'Alamofire', '~> 4.0'
  pod 'Kingfisher', '~> 3.2'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
        end
    end
end
