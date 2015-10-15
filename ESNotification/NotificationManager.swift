//
//  NotificationManager.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/04/23.
//
//

import Foundation
import Swim
import ESThread

// MARK: - Manager

/// Current notification manager.
let _notificationManager = NotificationManager()

public func == (lhs:NotificationManager.HandlerID, rhs:NotificationManager.HandlerID) -> Bool {

	return lhs.value == rhs.value
}

/// Manage native notifications.
public class NotificationManager {
	
	public static var dammingNotifications:Bool {

		get {
			
			return _notificationManager.dammingNotifications
		}

		set {

			_notificationManager.dammingNotifications = newValue
		}
	}
	
	public var dammingNotifications:Bool = false {
		
		didSet {
			
			if self.dammingNotifications {
				
				NSLog("Damming notifications.")
			}
			else {

				NSLog("Release notification dam.")
				self.invokeDammedNotifications()
			}
		}
	}
	
	private var notificationDam = [NotificationBox]()
	
	public struct HandlerID : Equatable {
		
		public var value:UInt16
		
		init(_ value:UInt16) {
			
			self.value = value
		}
		
		mutating func increment() {

			++self.value
		}
		
		/// Release observing handler by HandlerID
		public func release() {
			
			_notificationManager.release(self)
		}
	}
	
	/// Native notifications that the manager managed.
	private var _notificationHandlers = ContiguousArray<_NotificationHandler>()
	
	/// Notification observer for Raw notifications.
	private var _observer:_NotificationObserver!
	
	/// Current Raw Notification Center.
	private var _notificationCenter:NSNotificationCenter {
		
		return NSNotificationCenter.defaultCenter()
	}
	
	init() {

		self._observer = _NotificationObserver(self)
		self._notificationCenter.addObserver(self._observer, selector: Selector("received:"), name: nil, object: nil)
	}
	
	deinit {
		
		self._notificationCenter.removeObserver(self._observer)
	}

	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	/// The argument `notification` is used to help type inference.
	public func observe<OWNER:AnyObject>(owner:OWNER, notificationName:String, handler:(OWNER,NamedNotification)->Void) -> HandlerID {
		
		let _handler = { (owner:AnyObject, notification: NotificationProtocol) -> Void in
			
			let notification = notification as! NamedNotification
			
			if notification.name == notificationName {
				
				handler(owner as! OWNER, notification)
			}
		}
		
		return invokeOnProcessingQueueSynchronously {
			
			let handler = _NotificationHandler(owner, target:NamedNotification.self, targetName: notificationName, handler: _handler)
			
			self._notificationHandlers.append(handler)
			
			return handler.handlerID
		}
	}
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	/// The argument `notification` is used to help type inference.
	public func observe<OWNER:AnyObject, T:NotificationProtocol>(owner:OWNER, notification:T.Type, handler:(OWNER,T)->Void) -> HandlerID {
		
		return self.observe(owner, handler: handler)
	}
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	public func observe<OWNER:AnyObject, T:NotificationProtocol>(owner:OWNER, handler:(OWNER,T)->Void) -> HandlerID {

		let _getNotification:(NotificationProtocol)->T = {
			
			if T.self is AnyNotification.Type {
				
				return AnyNotification($0) as! T
			}
			else {

				return $0 as! T
			}
		}
		
		let _handler:(AnyObject, NotificationProtocol) -> Void = {
			
			handler($0 as! OWNER, _getNotification($1))
		}
		
		return invokeOnProcessingQueueSynchronously {

			let handler = _NotificationHandler(owner, target:T.self, targetName: nil, handler: _handler)
			
			self._notificationHandlers.append(handler)
			
			return handler.handlerID
		}
	}

	/// Release all observing handler for the `target`.
	public static func release(owner target:AnyObject) {
	
		_notificationManager.release(owner: target)
	}
	
	/// Release all observing handler for the `target`.
	public func release(owner target:AnyObject) {

		// Invoke `release` synchronously.
		invokeOnProcessingQueueSynchronously {

			self._release(owner: target)
		}
	}

	/// Release all observing handler for the `target`.
	func _release(owner target:AnyObject) {
		
		let targetIndexes = self._notificationHandlers.indexesOf {
			
			if let owner:AnyObject = $0.owner {
				
				return owner === target
			}
			else {
				
				return false
			}
		}
		
		self._notificationHandlers.remove(targetIndexes)
	}

	/// Release observing handler by HandlerID
	public static func release(handlerID:HandlerID) {
		
		_notificationManager.release(handlerID)
	}
	
	/// Release observing handler by HandlerID
	public func release(handlerID:HandlerID) {
		
		// Invoke `release` synchronously.
		invokeOnProcessingQueueSynchronously {
		
			self._release(handlerID)
		}
	}

	/// Release observing handler by HandlerID
	func _release(handlerID:HandlerID) {

		let index = self._notificationHandlers.indexOf {
			
			$0.handlerID == handlerID
		}
		
        if let index = index {

            self._notificationHandlers.removeAtIndex(index)
        }
	}
}

extension NotificationManager {

	/// The method is called when the observer received an notification.
	func received(notification:NotificationProtocol) {

		guard !NotificationManager.dammingNotifications else {
			
			self.dummNotification(notification)
			return
		}
		
		invokeOnProcessingQueueSyncIfNeeded {

			self._received(notification)
		}
	}

	/// The method is called when the observer received an notification.
	func received(rawNotification:NSNotification) {
		
		guard !NotificationManager.dammingNotifications else {
			
			self.dummNotification(rawNotification)
			return
		}
		
		invokeOnProcessingQueueSyncIfNeeded {
			
			self._received(rawNotification)
		}
	}
	
	private func _received(notification:NotificationProtocol) {
		
		self._removeUnownedNotificationHandlers()
		
		self._notificationHandlers.forEach {
			
			$0.invoke(notification)
		}
	}

	private func _received(rawNotification:NSNotification) {
		
		let targetNotificationNames = self._notificationHandlers.flatMap { $0.targetName }
		
		guard targetNotificationNames.contains(rawNotification.name) else {
		
			// drop the notification which will not be handled.
			return
		}
		
		self._received(NamedNotification(rawNotification: rawNotification))
	}

	private func _received(dummedNotification:NotificationBox) {
		
		switch dummedNotification {
			
		case .NativeNotification(let notification):
			self._received(notification)
			
		case .RawNotification(let notification):
			self._received(notification)
		}
	}
	
	func dummNotification(notification:NotificationProtocol) {
		
		invokeOnProcessingQueue {
			
			self._dummNotification(notification)
		}
	}
	
	func dummNotification(rawNotification:NSNotification) {
		
		invokeOnProcessingQueue {
			
			self._dummNotification(rawNotification)
		}
	}
	
	func _dummNotification(notification:NotificationProtocol) {
	
		self.notificationDam.append(notification)
	}
	
	func _dummNotification(rawNotification:NSNotification) {
		
		self.notificationDam.append(rawNotification)
	}
	
	func invokeDammedNotifications() {
		
		invokeOnProcessingQueue {
			
			self.notificationDam.forEach(self._received)
			self.notificationDam.removeAll()
		}
	}

	/// Remove notification handlers that the owner was released.
	func _removeUnownedNotificationHandlers() {
	
		let releasedIndexes = self._notificationHandlers.indexesOf {
			
			$0.isOwnerReleased
		}
		
		self._notificationHandlers.remove(releasedIndexes)
	}
}

// MARK: - Internal Container

/// Check if the `value` Type means same notification as `patternType`.
func ~= (pattern:NotificationProtocol.Type, value:NotificationProtocol.Type) -> Bool {
	
	let id1 = ObjectIdentifier(pattern)
	let id2 = ObjectIdentifier(value)
	
	return id1 == id2
}

/// Notification Handler Wrapper.
class _NotificationHandler {

	private static var _lastHandlerID = NotificationManager.HandlerID(0)
	
	private(set) var handlerID:NotificationManager.HandlerID
	private(set) var target:NotificationProtocol.Type
	private(set) var targetName:String?
	private(set) var handler:(AnyObject,NotificationProtocol)->Void
	private(set) weak var owner:AnyObject?
	
	init(_ owner:AnyObject, target:NotificationProtocol.Type, targetName:String?, handler:(AnyObject,NotificationProtocol)->Void) {
		
		self.handlerID = _NotificationHandler._getNextHandlerID()
		self.owner = owner
		self.target = target
		self.targetName = targetName
		self.handler = handler
	}
	
	private static func _getNextHandlerID() -> NotificationManager.HandlerID {
		
		self._lastHandlerID.increment()
		
		return self._lastHandlerID
	}
	
	/// Returns a boolean value whether the owner is already released.
	var isOwnerReleased:Bool {
		
		return self.owner == nil
	}
	
	/// Invoke notification handler. If the `notification` type is not same type as self.target, do nothing.
	func invoke(notification:NotificationProtocol) {
		
		if let owner:AnyObject = self.owner {
			
			switch self.target {
				
			case notification.dynamicType, AnyNotification.self:
				self._invokeHandlerOnMainThread(owner, notification)
				
			default:
				break
			}
		}
	}
	
	/// Invoke notification handler on main thread asynchronously.
	func _invokeHandlerOnMainThread(owner:AnyObject, _ notification:NotificationProtocol) {
		
		invokeAsyncOnMainQueue {
			
			self.handler(owner, notification)
		}
	}
}

// MARK: - Internal Observer

/// Observe raw notifications.
class _NotificationObserver : NSObject {

	private unowned var _manager:NotificationManager
	
	init(_ manager:NotificationManager) {
		
		self._manager = manager
		
		super.init()
	}
	
	/// The method is called when the observer received an notification.
	func received(rawNotification:NSNotification) {
	
		if let notification = rawNotification.toOceanNativeNotification() {

			self._manager.received(notification)
		}
		else {

			self._manager.received(rawNotification)
		}
	}
}
