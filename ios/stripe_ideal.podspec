#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint stripe_ideal.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'stripe_ideal'
  s.version          = '0.0.2'
  s.summary          = 'A plugin to use stripe\'s ideal with Flutter'
  s.description      = <<-DESC
A plugin to use stripe's ideal with Flutter
                       DESC
  s.homepage         = 'https://underkoen.nl'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Under_Koen' => 'koen@underkoen.nl' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Stripe','19.0.1'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
