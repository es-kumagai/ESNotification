source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def pods
	
	pod 'Swim', '~> 1.4.1-beta2'
	pod 'ESThread','~> 0.1.1'
	
end

def pods_test
	
	pods
	pod 'ESTestKit', '~> 0.3.3-beta1'
	
end

target :ESNotification_OSX do

	platform :osx, '10.9'
	pods
	
end

target :ESNotification_iOS do

	platform :ios, '8.0'
	pods

end

target :RunModalTestApp do
	
	platform :osx, '10.10'
	pods
	
end

target :ObjCTestApp do
	
	platform :osx, '10.10.4'
	pods
	
end

target :ESNotification_OSXTests do
	
	platform :osx, '10.10'
	pods_test
	
end

target :ESNotification_iOSTests do
	
	platform :ios, '9.0'
	pods_test
	
end
