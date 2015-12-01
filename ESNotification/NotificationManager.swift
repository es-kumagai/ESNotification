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

public func == (lhs:HandlerID, rhs:HandlerID) -> Bool {

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
	
	private var _notificationDam = [NotificationBox]()
		
	/// Native notifications that the manager managed.
	private var _notificationObservingHandlers = Array<_NotificationObservingHandler>()
	
	/// Notification observer for Raw notifications.
	private var _rawNotificationObserver:_NotificationObserver!
	
	/// Current Raw Notification Center.
	private var _notificationCenter:NSNotificationCenter {
		
		return NSNotificationCenter.defaultCenter()
	}
	
	init() {

		self._rawNotificationObserver = _NotificationObserver(self)
		self._notificationCenter.addObserver(self._rawNotificationObserver, selector: Selector("received:"), name: nil, object: nil)
	}
	
	deinit {
		
		self._notificationCenter.removeObserver(self._rawNotificationObserver)
	}
	
	/// Observe an named notification. When the named notification was post, the `handler` called in main thread.
	/// The argument `notification` is used to help type inference.
	@warn_unused_result
	public func observe(notificationName:String, handler:(NamedNotification)->Void) -> HandlerID {
		
		return self.observe(notificationName, handler: handler, handlerManager: nil)
	}
	
	@warn_unused_result
	internal func observe(notificationName:String, handler:(NamedNotification)->Void, handlerManager:NotificationHandlers?) -> HandlerID {
		
		let _handler = { (notification: NotificationProtocol) -> Void in
			
			let notification = notification as! NamedNotification
			
			if notification.name == notificationName {
				
				handler(notification)
			}
		}
		
		return invokeOnProcessingQueueSynchronously {
			
			let handler = _NotificationObservingHandler(NamedNotification.self, targetName: notificationName, handler: _handler, handlerManager: handlerManager)
			
			self._notificationObservingHandlers.append(handler)
			try! handlerManager?._addHandlerID(handler.handlerID)
			
			return handler.handlerID
		}
	}
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	/// The argument `notification` is used to help type inference.
	@warn_unused_result
	public func observe<T:NotificationProtocol>(notification:T.Type, handler:(T)->Void) -> HandlerID {
		
		return self.observe(handler, handlerManager: nil)
	}
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	@warn_unused_result
	public func observe<T:NotificationProtocol>(handler:(T)->Void) -> HandlerID {
	
		return self.observe(handler, handlerManager: nil)
	}
	
	@warn_unused_result
	public func observe<T:NotificationProtocol>(handler:(T)->Void, handlerManager: NotificationHandlers?) -> HandlerID {

		let _getNotification:(NotificationProtocol)->T = {
			
			if T.self is AnyNotification.Type {
				
				return AnyNotification($0) as! T
			}
			else {

				return $0 as! T
			}
		}
		
		let _handler:(NotificationProtocol) -> Void = {
			
			handler(_getNotification($0))
		}
		
		return invokeOnProcessingQueueSynchronously {

			let handler = _NotificationObservingHandler(T.self, targetName: nil, handler: _handler, handlerManager: handlerManager)
			
			self._notificationObservingHandlers.append(handler)
			try! handlerManager?._addHandlerID(handler.handlerID)

			return handler.handlerID
		}
	}

	/// Release all observing handler for the `target`.
	public static func releaseObservingHandler(handlerIDs:HandlerID...) {
	
		_notificationManager.releaseObservingHandlers(Set(handlerIDs))
	}
	
	/// Release all observing handler for the `target`.
	public static func releaseObservingHandlers(handlerIDs:Set<HandlerID>) {
		
		_notificationManager.releaseObservingHandlers(Set(handlerIDs))
	}
	
	/// Release all observing handler for the `target`.
	public func releaseObservingHandlers(handlerIDs:Set<HandlerID>) {

		// Invoke `release` synchronously.
		invokeOnProcessingQueueSynchronously {

			self._releaseObservingHandlers(handlerIDs)
		}
	}

	/// Release all observing handler for the `target`.
	func _releaseObservingHandlers(targetHandlerIDs: Set<HandlerID>) {

		let indexOfObservingHandlersByTargetHandlerID: (HandlerID) -> Int? = { targetHandlerID in
			
			self._notificationObservingHandlers.indexOf { observingHandler in targetHandlerID.containsInHandler(observingHandler) }
		}
		
		let targetHandlerIndexes: () -> [Int] = {

			targetHandlerIDs.flatMap(indexOfObservingHandlersByTargetHandlerID)
		}

		for index in targetHandlerIndexes().sort(>) {
			
			self._notificationObservingHandlers.removeAtIndex(index)
		}
	}
}

extension NotificationManager {

	/// The method is called when the observer received an notification.
	func received(notification:NotificationProtocol) {

		guard !NotificationManager.dammingNotifications else {
			
			self.dammNotification(notification)
			return
		}
		
		invokeOnProcessingQueueSyncIfNeeded {

			self._received(notification)
		}
	}

	/// The method is called when the observer received an notification.
	func received(rawNotification:NSNotification) {
		
		guard !NotificationManager.dammingNotifications else {
			
			self.dammNotification(rawNotification)
			return
		}
		
		invokeOnProcessingQueueSyncIfNeeded {
			
			self._received(rawNotification)
		}
	}
	
	private func _received(notification:NotificationProtocol) {
		
		self._notificationObservingHandlers.forEach {
			
			$0.invoke(notification)
		}
	}

	private func _received(rawNotification:NSNotification) {
		
		let targetNotificationNames = self._notificationObservingHandlers.flatMap { $0.targetName }
		
		guard targetNotificationNames.contains(rawNotification.name) else {
		
			// drop the notification which will not be handled.
			return
		}
		
		self._received(NamedNotification(rawNotification: rawNotification))
	}

	private func _received(dammedNotification:NotificationBox) {
		
		switch dammedNotification {
			
		case .NativeNotification(let notification):
			self._received(notification)
			
		case .RawNotification(let notification):
			self._received(notification)
		}
	}
	
	func dammNotification(notification:NotificationProtocol) {
		
		invokeOnProcessingQueue {
			
			self._dammNotification(notification)
		}
	}
	
	func dammNotification(rawNotification:NSNotification) {
		
		invokeOnProcessingQueue {
			
			self._dammNotification(rawNotification)
		}
	}
	
	func _dammNotification(notification:NotificationProtocol) {
	
		self._notificationDam.append(notification)
	}
	
	func _dammNotification(rawNotification:NSNotification) {
		
		self._notificationDam.append(rawNotification)
	}
	
	func invokeDammedNotifications() {
		
		invokeOnProcessingQueue {
			
			self._notificationDam.forEach(self._received)
			self._notificationDam.removeAll()
		}
	}
}

extension _NotificationObservingHandler : Equatable {
	
}

func == (lhs: _NotificationObservingHandler, rhs: _NotificationObservingHandler) -> Bool {
	
	return lhs.handlerID == rhs.handlerID
}

// MARK: - Internal Container

/// Check if the `value` Type means same notification as `patternType`.
func ~= (pattern:NotificationProtocol.Type, value:NotificationProtocol.Type) -> Bool {
	
	let id1 = ObjectIdentifier(pattern)
	let id2 = ObjectIdentifier(value)
	
	return id1 == id2
}

/// Notification Handler Wrapper.
final class _NotificationObservingHandler {

	typealias NotificationHandler = (NotificationProtocol) -> Void

	private static var _lastHandlerID = Int.min
	
	private(set) var handlerID:HandlerID
	private(set) var target:NotificationProtocol.Type
	private(set) var targetName:String?
	private(set) var handler:NotificationHandler
	
	init(_ target:NotificationProtocol.Type, targetName:String?, handler:NotificationHandler, handlerManager: NotificationHandlers?) {
		
		self.handlerID = _NotificationObservingHandler._getNextHandlerID(handlerManager)
		self.target = target
		self.targetName = targetName
		self.handler = handler
	}
	
	private static func _getNextHandlerID(handlerManager: NotificationHandlers?) -> HandlerID {
		
		return HandlerID(self._lastHandlerID++, handlerManager: handlerManager)
	}
	
	/// Invoke notification handler. If the `notification` type is not same type as self.target, do nothing.
	func invoke(notification:NotificationProtocol) {

		switch self.target {
			
		case notification.dynamicType, AnyNotification.self:
			self._invokeHandlerOnMainThread(notification)
			
		default:
			break
		}
	}

	/// Invoke notification handler on main thread asynchronously.
	func _invokeHandlerOnMainThread(notification:NotificationProtocol) {
		
		invokeAsyncOnMainQueue {
			
			self.handler(notification)
		}
	}
}

// MARK: - Internal Observer

/// Observe raw notifications.
final class _NotificationObserver : NSObject {

	private unowned var _manager:NotificationManager
	
	init(_ manager:NotificationManager) {
		
		self._manager = manager
		
		super.init()
	}
	
	/// The method is called when the observer received an notification.
	func received(rawNotification:NSNotification) {
	
		if let notification = rawNotification.toESNativeNotification() {

			self._manager.received(notification)
		}
		else {

			self._manager.received(rawNotification)
		}
	}
}
