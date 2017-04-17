Pod::Spec.new do |s|
  s.name             = 'KatanaMonitor'
  s.version          = File.read(".version")
  s.summary          = 'Katana middleware to leverage redux dev tools'

  s.homepage         = 'https://bendingspoons.com'
  s.license          = { :type => 'No License', :text => "Copyright 2017 BendingSpoons" }
  s.author           = { 'Mauro Bolis' => 'bolismauro@gmail.com' }
  s.source           = { :git => 'https://github.com/bolismauro/KatanaMonitor-lib-swift.git', :tag => s.version.to_s }

  s.dependency 'SocketRocket', '~> 0.5'
  s.dependency 'Katana', '>= 0.7', '< 0.9'

  s.ios.deployment_target = '9.0'

  s.ios.source_files = [
    'KatanaMonitor/**/*.swift',
    'KatanaMonitor/**/*.h',
    'KatanaMonitor/**/*.m',
    'KatanaMonitor/SupportingFiles/KatanaMonitor.h',
  ]
end