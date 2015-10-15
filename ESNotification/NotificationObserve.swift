//
//  NotificationObserve.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/10/15.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation

@objc public protocol Observeable : _Notification {

}

extension Observeable {
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	public static func observeBy<OWNER:AnyObject>(owner:OWNER, handler:(OWNER,Self)->Void) -> NotificationManager.HandlerID {
		
		return _notificationManager.observe(owner, handler: handler)
	}
}

extension NamedNotification {
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	public static func observe<OWNER:AnyObject>(name:String, by owner:OWNER, handler:(OWNER,NamedNotification)->Void) -> NotificationManager.HandlerID {
		
		return _notificationManager.observe(owner, notificationName: name, handler: handler)
	}
}
