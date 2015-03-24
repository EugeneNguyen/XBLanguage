#
# Be sure to run `pod lib lint XBLanguage.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "XBLanguage"
  s.version          = "0.5"
  s.summary          = "Powerful localization library"
  s.description      = <<-DESC
                       A powerful library allow you localization with multiple language and editable on website. XBLanguage also provide ability to localization inside xib file, which native localization cannot do.
                       DESC
  s.homepage         = "https://github.com/EugeneNguyen/XBLanguage"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "eugenenguyen" => "xuanbinh91@gmail.com" }
  s.source           = { :git => "https://github.com/EugeneNguyen/XBLanguage.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/LIBRETeamStudio'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'XBLanguage' => ['Pod/Assets/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'XBCacheRequest'
  s.dependency 'JSONKit-NoWarning'
end
