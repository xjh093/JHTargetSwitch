Pod::Spec.new do |spec|
  spec.name         = "JHTargetSwitch"
  spec.version      = "0.1.0"
  spec.summary      = "Object-C Target Switch Manager."

  spec.description  = <<-DESC
  Object-C Target Switch Manager. 666
                   DESC

  spec.homepage     = "https://github.com/xjh093/JHTargetSwitch"
  spec.license      = "MIT"
  spec.author       = { "Haomissyou" => "xjh093@126.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/xjh093/JHTargetSwitch.git", :tag => spec.version.to_s }

  spec.source_files = "Classes/**/*.{h,m}"
  spec.public_header_files = "Classes/*.h"
  
end
