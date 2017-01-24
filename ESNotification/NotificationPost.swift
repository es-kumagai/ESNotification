//
//  NotificationPost.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/10/15.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation

@objc(ESNotificationPostable)
public protocol Postable : NotificationProtocol {
	
}

extension Postable {
	
	/// Post the `notification`.
	public func post() {
		
		let notificationCenter = NotificationCenter.default
		let rawNotification = makeRawNotification()
		
		notificationCenter.post(rawNotification)
	}
	
	/// Create an NSNotification from the `notification`.
	public func makeRawNotification() -> Foundation.Notification {
		
		if let notification = self as? RawNotificationType {
			
			return notification.rawNotification
		}
		else {
			
			return Foundation.Notification(name: rawNotificationName, object: self, userInfo: nil)
		}
	}
}
