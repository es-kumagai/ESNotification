//
//  NotificationObjC.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/10/15.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation

extension NotificationCenter {
	
	public static func ESNotificationNameOf(_ notification: NotificationProtocol.Type) -> String {
		
		return notification.notificationIdentifier
	}
	
	public func addObserver(_ observer: AnyObject, selector aSelector: Selector, ESNotification notification: NotificationProtocol.Type, object: AnyObject?) {

		let name = NotificationCenter.ESNotificationNameOf(notification)
		
		self.addObserver(observer, selector: aSelector, name: NSNotification.Name(rawValue: name), object: object)
	}
	
	public func removeObserver(_ observer: AnyObject, ESNotification notification: NotificationProtocol.Type, object: AnyObject?) {
		
		let name = NotificationCenter.ESNotificationNameOf(notification)
		
		self.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: object)
	}
	
	public func postESNotification(_ notification: Postable) {
		
		notification.post()
	}
}
