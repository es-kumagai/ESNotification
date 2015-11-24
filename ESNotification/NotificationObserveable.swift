//
//  NotificationObserveable.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/11/22.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

public protocol NotificationObserveable : AnyObject {
	
}

extension NotificationObserveable {
	
	/// Observe an named notification. When the named notification was post, the `handler` called in main thread.
	public func observeNotificationNamed(name:String, handler:(NamedNotification)->Void) -> NotificationManager.HandlerID {

		return _notificationManager.observe(self, notificationName: name, handler: handler)
	}
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	public func observeNotification<T:NotificationProtocol>(handler:(T)->Void) -> NotificationManager.HandlerID {
		
		return _notificationManager.observe(self, handler: handler)
	}
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	/// The argument `notification` is used to help type inference.
	public func observeNotification<T:NotificationProtocol>(type:T.Type, handler:(T)->Void) -> NotificationManager.HandlerID {
		
		return _notificationManager.observe(self, handler: handler)
	}
	
	/// Release all observing handler for `self`.
	public func releaseObservingNotifications() {
		
		_notificationManager.release(owner: self)
	}
}