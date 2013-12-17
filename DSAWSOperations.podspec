Pod::Spec.new do |s|
  s.name         = "DSAWSOperations"
  s.version      = "0.5"
  s.summary      = "Small framework to make the AWS IOS SDK less verbose and asynchronous."
  s.description  = <<-DESC
                A small framework designed to take some of the pain out of using the AWS IOS SDK, which can get very verbose and is synchronous out of the box.
                    DESC
  s.homepage     = "http://github.com/DestoAU/DSAWSOperations"
  s.license      = 'MIT'
  s.author       = { "Rob Amos" => "robert.amos@desto.com.au" }
  s.source       = { :git => "https://github.com/DestoAU/DSAWSOperations.git", :tag => "0.5" }
  s.platform     = :ios, '6.0'
  s.source_files = 'DSAWSOperations', 'DSAWSOperations/**/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'
  s.frameworks = 'AWSAutoScaling', 'AWSCloudWatch', 'AWSDynamoDB', 'AWSEC2', 'AWSElasticLoadBalancing', 'AWSRuntime', 'AWSS3', 'AWSSecurityTokenService', 'AWSSES', 'AWSSimpleDB', 'AWSSNS', 'AWSSQS'
  s.requires_arc = true
end