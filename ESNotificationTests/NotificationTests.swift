//
//  NotificationTests.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/05/04.
//
//

import Foundation
import XCTest
import ESTestKit
import ESNotification

class CustomNotification : ESNotification.Notification {
	
}

class NotificationTests: XCTestCase {

    override func setUp() {

		super.setUp()
	}
    
    override func tearDown() {

		super.tearDown()
    }

	func testNotificationName() {
	
		let bundleName = NSBundle(forClass: self.dynamicType).infoDictionary!["CFBundleName"] as! String
		
		let customNotificationName = CustomNotification.self.notificationIdentifier
		let namedNotificationName = NamedNotification("TestNamedNotification").notificationIdentifier
		
		expected().equal(customNotificationName, "jp.ez-style.Notification." + bundleName + ".CustomNotification")
		expected("NamedNotification も nameOf 関数では名前ではなく固有の識別子を取得します。").equal(namedNotificationName, "jp.ez-style.Notification.ESNotification.NamedNotification")
	}
	
    func testRawNotification() {

		let object:AnyObject? = self
		let userInfo:[NSObject:AnyObject]? = ["k1":10, "k2":20]
		
		let notification = NamedNotification("ESTestNotification", object: object, userInfo: userInfo)
		let rawNotification = notification.rawNotification
		
		expected().equal(rawNotification.name, "ESTestNotification")
		expected().equal(notification.name, "ESTestNotification")
		
		if let objectOfRaw:AnyObject = rawNotification.object, let objectOfNative:AnyObject = notification.object {

			expected().success { objectOfRaw === objectOfNative }
		}
		else {
			
			expected().success { rawNotification.object == nil && notification.object == nil }
		}
		
		if let userInfoOfRaw = rawNotification.userInfo, let userInfoOfNative = notification.userInfo {
			
			expected().equal(userInfoOfRaw.count, 2)
			expected().equal(userInfoOfRaw.count, userInfoOfNative.count)
			
			for (key, valueOfRaw) in userInfoOfRaw {
				
				if let valueOfNative:AnyObject = userInfoOfNative[key] {

					expected().success { valueOfNative === valueOfRaw }
				}
				else {
					
					failed("Key mismatch '\(key)'.") as Void
				}
			}
		}
		else {
			
			expected().success { rawNotification.userInfo == nil && notification.userInfo == nil }
		}
	}
}
