//
//  NotificationControl.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/05/04.
//
//

import Foundation
import ESThread

private let NotificationRawNamePrefix = "jp.ez-style.Notification."

extension Notification {
	
	/// Post the `notification`.
	public func post() {
		
		let notificationCenter = NSNotificationCenter.defaultCenter()
		let rawNotification = self.makeRawNotificationForNativePost()
		
		notificationCenter.postNotification(rawNotification)
	}
	
	/// Get name of the `notification`.
	public var notificationIdentifier:String {
		
		return self.dynamicType.notificationIdentifier
	}
	
	/// Get name of the `notification`.
	public static var notificationIdentifier:String {

		return "\(NotificationRawNamePrefix)\(self)"
	}
	
	/// Create an NSNotification from the `notification`.
	func makeRawNotificationForNativePost() -> NSNotification {
		
		if let notification = self as? RawNotificationType {
			
			return notification.rawNotification
		}
		else {
			
			let name = self.dynamicType.notificationIdentifier
			let object = self
			
			return NSNotification(name: name, object: object, userInfo:nil)
		}
	}
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	public static func observeBy<OWNER:AnyObject>(owner:OWNER, handler:(OWNER,Self)->Void) -> NotificationManager.HandlerID {
		
		return _notificationManager.observe(owner, handler: handler)
	}
}

extension NSNotification {
	
	/// Returns a boolean value whether the `rawNotification` is an Native notification.
	var isOceanNativeNotification:Bool {
		
		return self.name.hasPrefix(NotificationRawNamePrefix)
	}
	
	/// Get the native notification from the `rawNotification`. Returns nil if `rawNotification` is not an Native notification.
	func toOceanNativeNotification() -> Notification? {
		
		if self.isOceanNativeNotification {
			
			return self.object as? Notification
		}
		else {
			
			return nil
		}
	}
}

extension NamedNotification {
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	public static func observe<OWNER:AnyObject>(name:String, by owner:OWNER, handler:(OWNER,NamedNotification)->Void) -> NotificationManager.HandlerID {
		
		return _notificationManager.observe(owner) { (owner:OWNER, notification:NamedNotification) -> Void in
			
			if notification.name == name {

				handler(owner, notification)
			}
		}
	}
}

// MARK: - Thread

private let _processingQueueLabel = "jp.ez-style.thread.ocean.notification"
private let _processingQueue = dispatch_queue_create(_processingQueueLabel, nil)

/// Invoke `predicate` asynchronously on the thread for Notification processing.
public func invokeOnProcessingQueue(predicate:()->Void) -> Void {
	
	invokeAsync(_processingQueue, predicate: predicate)
}

/// Invoke `predicate` synchronously on the thread for Notification processing.
public func invokeOnProcessingQueueSynchronously<R>(predicate:()->R) -> R {
	
	return invoke(_processingQueue, predicate: predicate)
}

// MARK: - Manager

/// Post the `notification`.
@available(*, unavailable, message="access the 'post' method on the Notification")
public func post<T:Notification>(notification:T) {}

/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
/// The argument `notification` is used to help type inference.
@available(*, unavailable, message="access the 'observeBy' method on the Notification")
@noreturn public func observe<OWNER:AnyObject, T:Notification>(owner:OWNER, _ notification:T.Type, handler:(OWNER,T)->Void) -> NotificationManager.HandlerID {}

/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
@available(*, unavailable, message="access the 'observeBy' method on the Notification")
@noreturn public func observe<OWNER:AnyObject, T:Notification>(owner:OWNER, handler:(OWNER,T)->Void) -> NotificationManager.HandlerID {}

/// Release observing handler by HandlerID
@available(*, unavailable, message="access the 'release' method on the NotificationManager.HandlerID")
public func releaseHandler(handlerID:NotificationManager.HandlerID) {}

// MARK: - Raw Support

/// Get name of the `notification`.
@available(*, unavailable, message="access the 'notificationIdentifier' property on the Notification")
@noreturn public func identifierOf<T:Notification>(notification:T) -> String {}

/// Get name of the `notification`.
@available(*, unavailable, message="access the 'notificationIdentifier' property on the Notification")
@noreturn public func identifierOf<T:Notification>(type:T.Type) -> String {}

// MARK: - Internal Support

/// Create an NSNotification from the `notification`.
@available(*, unavailable, message="access the 'makeRawNotificationForNativePost' method on the Notification")
@noreturn func makeRawNotificationForNativePost<T:Notification>(notification:T) -> NSNotification {}

/// Returns a boolean value whether the `rawNotification` is an Native notification.
@available(*, unavailable, message="access the 'isOceanNativeNotification' property on the NSNotification")
@noreturn func isNativeNotification(rawNotification:NSNotification) -> Bool {}

/// Get the native notification from the `rawNotification`. Returns nil if `rawNotification` is not an Native notification.
@available(*, unavailable, message="access the 'toOceanNativeNotification' method on the NSNotification")
@noreturn func nativeNotificationFrom(rawNotification:NSNotification) -> Notification? {}
