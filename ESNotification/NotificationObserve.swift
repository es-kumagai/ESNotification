//
//  NotificationObserve.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/10/15.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation

extension Notification {
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	public static func observeBy<OBSERVER:AnyObject>(observer:OBSERVER, handler:(Self)->Void) -> NotificationManager.HandlerID {
		
		return _notificationManager.observe(observer, handler: handler)
	}
}

extension NamedNotification {
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	public static func observe<OBSERVER:AnyObject>(name:String, by observer:OBSERVER, handler:(NamedNotification)->Void) -> NotificationManager.HandlerID {
		
		return _notificationManager.observe(observer, notificationName: name, handler: handler)
	}
}
