#
# Be sure to run `pod spec lint VCRURLConnection.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "VCRURLConnection"
  s.version      = "0.0.1"
  s.summary      = "A short description of VCRURLConnection."
  s.homepage     = "http://github.com/dstnbrkr/VCRURLConnection"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Dustin Barker" => "dustin.barker@gmail.com" }


  s.source       = { :git => "http://github.com/dstnbrkr/VCRURLConnection.git" }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source_files = 'VCRURLConnection/**.{h,m}'

  # If this Pod uses ARC, specify it like so.
  #
  # s.requires_arc = true

end
