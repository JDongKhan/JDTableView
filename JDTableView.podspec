

Pod::Spec.new do |s|

  s.name         = "JDTableView"
  s.version      = '0.0.1' 
  s.summary      = "JDTableView"

  s.description  = <<-DESC
			JDRouter
                   DESC

  s.homepage     = "https://github.com/wangjindong/JDTableView.git"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "wangjindong" => "419591321@qq.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/wangjindong/JDTableView.git", :tag => s.version.to_s }


  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true

  s.source_files = 'JDTableView/**/*.{h,m}'
  s.public_header_files = 'JDTableView/**/*.h'

 
end
