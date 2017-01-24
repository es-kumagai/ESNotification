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
	
	public static func observe(_ handler: @escaping (Self)->Void) -> HandlerID {
		
		return _notificationManager.observe(handler)
	}
}

extension NamedNotification {
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	
	public static func observe(_ name: String, handler: @escaping (NamedNotification) -> Void) -> HandlerID {
		
		return _notificationManager.observe(name, handler: handler)
	}
}
