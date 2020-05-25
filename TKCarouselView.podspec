

Pod::Spec.new do |spec|

  spec.name         = "TKCarouselView"
  spec.version      = "1.1.3"
  spec.summary      = "TKCarouselView is a roving graph tool that supports app styles such as jd and Tmall."
  spec.homepage     = "https://github.com/libtinker/TKCarouselView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "libtinker" => "libtinkerer@gmail.com" }
  spec.source       = { :git => "https://github.com/libtinker/TKCarouselView.git", :tag => spec.version }
  spec.platform     = :ios, '9.0'
  spec.source_files = "Classes", "TKCarouselView/TKCarouselView/Classes/**/*.{h,m}"
  spec.requires_arc = true
end
