//
//  NotificationTests.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/05/04.
//
//

import Foundation
import XCTest
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
	
		let customNotificationName = CustomNotification.self.notificationIdentifier
		let namedNotificationName = NamedNotification("TestNamedNotification").notificationIdentifier
		
		XCTAssertEqual(customNotificationName, "jp.ez-net.notification.CustomNotification")
		XCTAssertEqual(namedNotificationName, "jp.ez-net.notification.NamedNotification", "NamedNotification も nameOf 関数では名前ではなく固有の識別子を取得します。")
	}
	
    func testRawNotification() {

		let object: AnyObject? = self
		let userInfo: [AnyHashable: Any]? = ["k1":10, "k2":20]
		
		let notification = NamedNotification("ESTestNotification", object: object, userInfo: userInfo)
		let rawNotification = notification.rawNotification
		
		XCTAssertEqual(rawNotification.name.rawValue, "ESTestNotification")
		XCTAssertEqual(notification.name, "ESTestNotification")
		
		if let objectOfRaw = rawNotification.object, let objectOfNative = notification.object {

			XCTAssertTrue((objectOfRaw as AnyObject) === (objectOfNative as AnyObject))
		}
		else {

			XCTAssertTrue(rawNotification.object == nil && notification.object == nil)
		}
		
		if let userInfoOfRaw = rawNotification.userInfo, let userInfoOfNative = notification.userInfo {
			
			XCTAssertEqual(userInfoOfRaw.count, 2)
			XCTAssertEqual(userInfoOfRaw.count, userInfoOfNative.count)
			
			for (key, valueOfRaw) in userInfoOfRaw {
				
				if let valueOfNative = userInfoOfNative[key] {

					XCTAssertTrue(type(of: valueOfNative) == type(of: valueOfRaw))
					XCTAssertEqual(String(describing: valueOfNative), String(describing: valueOfRaw))
				}
				else {
					
					XCTFail("Key mismatch '\(key)'.")
				}
			}
		}
		else {
			
			XCTAssertTrue(rawNotification.userInfo == nil && notification.userInfo == nil)
		}
	}
}
