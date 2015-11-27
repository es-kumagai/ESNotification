//
//  NotificationObjC.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/10/15.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation

extension NSNotificationCenter {
	
	public func addObserver(observer: AnyObject, selector aSelector: Selector, ESNotification notification: NotificationProtocol.Type, object: AnyObject?) {

		self.addObserver(observer, selector: aSelector, name: notification.notificationIdentifier, object: object)
	}
	
	public func postESNotification(notification:Postable) {
		
		notification.post()
	}
}
