Pod::Spec.new do |spec|
  spec.name         = "Okidoki"
  spec.version      = "0.0.4"
  spec.summary      = "Object-C UI Chaining Syntax."

  spec.description  = <<-DESC
  Object-C UI Chaining Syntax. 666
                   DESC

  spec.homepage     = "https://github.com/xjh093/Okidoki"
  spec.license      = "MIT"
  spec.author       = { "Haomissyou" => "xjh093@126.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/xjh093/Okidoki.git", :tag => spec.version.to_s }
  
  
  # 国内版本
  spec.subspec 'TargetCN' do |core|
    core.source_files = [
        "Okidoki/Classes/**/*",
        "Okidoki/TargetCN/**/*",
    ]
    
    # 定义本 Target 的宏：TargetCN
    feature_flags = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'TargetCN' }
    core.pod_target_xcconfig  = feature_flags
    core.user_target_xcconfig = feature_flags
  end

  
  # 国际版本
  spec.subspec 'TargetEN' do |core|
    core.source_files = [
        "Okidoki/Classes/**/*",
        "Okidoki/TargetEN/**/*",
    ]
    
    # 定义本 Target 的宏：TargetEN
    feature_flags = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'TargetEN' }
    core.pod_target_xcconfig  = feature_flags
    core.user_target_xcconfig = feature_flags
  end
  
  
  # 日本版本
  spec.subspec 'TargetJP' do |core|
    core.source_files = [
        "Okidoki/Classes/**/*",
        "Okidoki/TargetJP/**/*",
    ]
    
    # 定义本 Target 的宏：TargetJP
    feature_flags = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'TargetJP' }
    core.pod_target_xcconfig  = feature_flags
    core.user_target_xcconfig = feature_flags
  end
  
end
