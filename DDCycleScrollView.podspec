Pod::Spec.new do |s|

s.name         = "DDCycleScrollView"
s.version      = "2.00"
s.summary      = "简单易用的图片无限轮播器."

s.homepage     = "https://github.com/Faithlight/DDCycleScrollView.git"

s.license      = "MIT"

s.author       = { 'Faithlight' => '454277536@qq.com' }

s.platform     = :ios
s.platform     = :ios, "9.0"


s.source       = { :git => "https://github.com/Faithlight/DDCycleScrollView.git", :tag => "#{s.version}"}


s.source_files  = "DDCycleScrollView/DDCycleScrollView/**/*.{h,m}"


s.requires_arc = true


end
