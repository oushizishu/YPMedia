#
# Be sure to run `pod lib lint YPMedia.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YPMedia'
  s.version          = '0.1.0'
  s.summary          = 'A short description of YPMedia.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/oushizishu/YPMedia'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'oushizishu' => 'xinyapeng@baijiahulian.com' }
  s.source           = { :git => 'https://github.com/oushizishu/YPMedia.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'YPMedia/Classes/**/*.{h,m,c,cpp,mm,plist,xib}'
  
  # s.resource_bundles = {
  #   'YPMedia' => ['YPMedia/Assets/*.png']
  # }

  s.public_header_files = 'YPMedia/Classes/**/*.h'
  s.xcconfig = { "ENABLE_BITCODE" => "NO" }

 # s.xcconfig = { "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES" }

  s.default_subspec = 'Lame'
   s.subspec 'Lame' do |lame|
     lame.vendored_libraries = 'YPMedia/Classes/ConvertToMP3/*.a'
   end

  s.dependency 'YPPermission'
  s.dependency 'YPFoundation'


end
