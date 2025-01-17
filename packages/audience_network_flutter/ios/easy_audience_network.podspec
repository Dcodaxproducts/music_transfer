Pod::Spec.new do |s|
  s.name             = 'easy_audience_network'
  s.version          = '0.0.7'
  s.summary          = 'Facebook Audience Network plugin for Flutter application'
  s.description      = <<-DESC
Facebook Audience Network plugin for Flutter application
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Cross Code' => 'admin@crosscode.dev' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'FBAudienceNetwork', '~> 6.16.0'

  s.static_framework = true
  s.swift_version = '5.2'
  s.ios.deployment_target = '13.0'

end
