Pod::Spec.new do |s|

  s.name         = "ESNotification"
  s.version      = "0.2.9"
  s.summary      = "A type-safe notification management system for iOS/OSX written in Swift 2."

  s.description  = <<-DESC
				      It is a swift module that powerfully notification management system using type-safe notification types. Notifications using this system are compatible with NSNotificationCenter. This module written in Swift 2.0. Supports Objective-C.
                      DESC

  s.homepage     = "https://github.com/EZ-NET/ESNotification"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Tomohiro Kumagai" => "http://ez-net.jp/profile/" }
  s.social_media_url   = "http://twitter.com/es_kumagai"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"

  s.source       = { :git => "https://github.com/EZ-NET/ESNotification.git" }
  s.source_files  = "ESNotification/**/*.swift"
  s.ios.source_files  = "ESNotification_iOS/**/*.swift"
  s.osx.source_files  = "ESNotification_OSX/**/*.swift"

  s.dependency	'Swim', '~> 1.4.0'
  s.dependency	'ESThread', '~> 0.1.1'

end
