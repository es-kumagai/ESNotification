//
//  NotificationObservable.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/11/22.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

public protocol NotificationObservable : AnyObject {

	/// This is a property for store Notification Handlers.
	var notificationHandlers: NotificationHandlers { get }
}

extension NotificationObservable {
	
	/// Observe an named notification. When the named notification was post, the `handler` called in main thread.
	public func observeNotificationNamed(name:String, handler:(NamedNotification)->Void) -> HandlerID {

		return _notificationManager.observe(name, handler: handler, handlerManager: self.notificationHandlers)
	}
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	public func observeNotification<T:NotificationProtocol>(handler:(T)->Void) -> HandlerID {
		
		return _notificationManager.observe(handler, handlerManager: self.notificationHandlers)
	}
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	/// The argument `notification` is used to help type inference.
	public func observeNotification<T:NotificationProtocol>(_ :T.Type, handler:(T)->Void) -> HandlerID {
		
		return self.observeNotification(handler)
	}
	
	/// Release observing handler.
	public func releaseObservingNotification(handlerID: HandlerID) throws {
		
		try self.releaseObservingNotifications([handlerID])
	}
	
	public func releaseObservingNotifications(handlerIDs: [HandlerID]) throws {
		
		try self.notificationHandlers.releaseHandlers(Set(handlerIDs))
	}
	
	/// Release all observing handler for `self`.
	public func releaseAllObservingNotifications() {
		
		self.notificationHandlers.releaseAllHandlers()
	}
}