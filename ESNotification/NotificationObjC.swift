//
//  NotificationObjC.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/10/15.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation

extension NSNotificationCenter {
	
	public static func ESNotificationNameOf(notification: NotificationProtocol.Type) -> String {
		
		return notification.notificationIdentifier
	}
	
	public func addObserver(observer: AnyObject, selector aSelector: Selector, ESNotification notification: NotificationProtocol.Type, object: AnyObject?) {

		let name = NSNotificationCenter.ESNotificationNameOf(notification)
		
		self.addObserver(observer, selector: aSelector, name: name, object: object)
	}
	
	public func removeObserver(observer: AnyObject, ESNotification notification: NotificationProtocol.Type, object: AnyObject?) {
		
		let name = NSNotificationCenter.ESNotificationNameOf(notification)
		
		self.removeObserver(observer, name: name, object: object)
	}
	
	public func postESNotification(notification:Postable) {
		
		notification.post()
	}
}
