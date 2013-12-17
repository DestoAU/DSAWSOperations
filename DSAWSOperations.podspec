Pod::Spec.new do |s|
  s.name         = "DSAWSOperations"
  s.version      = "0.6.1"
  s.summary      = "Small framework to make the AWS IOS SDK less verbose and asynchronous."
  s.description  = <<-DESC
                A small framework designed to take some of the pain out of using the AWS IOS SDK, which can get very verbose and is synchronous out of the box.
                    DESC
  s.homepage     = "http://github.com/DestoAU/DSAWSOperations"
  s.license      = 'MIT'
  s.author       = { "Rob Amos" => "robert.amos@desto.com.au" }
  s.source       = { :git => "https://github.com/DestoAU/DSAWSOperations.git", :tag => "0.6.1" }
  s.platform     = :ios, '6.0'
  s.source_files = 'DSAWSOperations', 'DSAWSOperations/**/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'
  s.requires_arc = true
  s.dependency 'AWSiOSSDK', '~> 1.7.0'
end
