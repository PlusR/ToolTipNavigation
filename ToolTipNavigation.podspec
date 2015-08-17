Pod::Spec.new do |s|
  s.name             = "ToolTipNavigation"
  s.version          = "1.0.2"
  s.summary          = "tool tip navigation"
  s.description      = <<-DESC
                       This library is a library for managing the display of CMPopTipView. Such as tutorial, you used when you want to display a pop tip with a series of flows.
                       DESC
  s.homepage         = "https://github.com/PlusR/ToolTipNavigation"
  s.license          = 'MIT'
  s.author           = { "akuraru" => "akuraru@gmail.com" }
  s.source           = { :git => "https://github.com/PlusR/ToolTipNavigation.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/akuraru'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.frameworks = 'UIKit'
  s.dependency 'CMPopTipView'
end
