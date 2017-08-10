Pod::Spec.new do |s|

   s.name         = "XCTestCaseAsync"
   s.version      = "1.0.2"
   s.summary      = "async support for XCTestCase with timeout, retry feature"
   s.homepage     = "https://github.com/zhengbomo/XCTestCaseAsync"
   s.license      = { :type => "MIT", :file => "LICENSE" }
   s.author       = { "bomo" => "zhengbomo@hotmail.com" }
   s.platform     = :ios, "8.0"
   s.frameworks   = 'XCTest'
   s.source       = { :git => "https://github.com/zhengbomo/XCTestCaseAsync.git", :tag => s.version }
   s.source_files = 'XCTestCaseAsync/XCTestCaseAsyncTests/Source/*.{h,m}'
   s.requires_arc = true

end
