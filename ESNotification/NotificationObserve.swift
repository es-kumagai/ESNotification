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
	@warn_unused_result
	public static func observe(handler:(Self)->Void) -> NotificationManager.HandlerID {
		
		return _notificationManager.observe(handler)
	}
}

extension NamedNotification {
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	@warn_unused_result
	public static func observe(name:String, handler:(NamedNotification)->Void) -> NotificationManager.HandlerID {
		
		return _notificationManager.observe(name, handler: handler)
	}
}
