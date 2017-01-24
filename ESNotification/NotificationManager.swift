//
//  NotificationManager.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/04/23.
//
//

import Foundation

// MARK: - Manager

/// Current notification manager.
let _notificationManager = NotificationManager()

public func == (lhs: HandlerID, rhs: HandlerID) -> Bool {

	return lhs.value == rhs.value
}

/// Manage native notifications.
public class NotificationManager {
	
	public static var dammingNotifications: Bool {

		get {
			
			return _notificationManager.dammingNotifications
		}

		set {

			_notificationManager.dammingNotifications = newValue
		}
	}
	
	public var dammingNotifications: Bool = false {
		
		didSet {
			
			if dammingNotifications {
				
				NSLog("Damming notifications.")
			}
			else {

				NSLog("Release notification dam.")
				invokeDammedNotifications()
			}
		}
	}
	
	fileprivate var _notificationDam = [NotificationBox]()
		
	/// Native notifications that the manager managed.
	fileprivate var _notificationObservingHandlers = Array<_NotificationObservingHandler>()
	
	/// Notification observer for Raw notifications.
	fileprivate var _rawNotificationObserver: _NotificationObserver!
	
	/// Current Raw Notification Center.
	fileprivate var _notificationCenter: NotificationCenter {
		
		return NotificationCenter.default
	}
	
	init() {

		_rawNotificationObserver = _NotificationObserver(self)
		_notificationCenter.addObserver(self._rawNotificationObserver, selector: #selector(_NotificationObserver.received(_:)), name: nil, object: nil)
	}
	
	deinit {
		
		self._notificationCenter.removeObserver(self._rawNotificationObserver)
	}
	
	/// Observe an named notification. When the named notification was post, the `handler` called in main thread.
	/// The argument `notification` is used to help type inference.
	
	public func observe(_ notificationName:String, handler:@escaping (NamedNotification)->Void) -> HandlerID {
		
		return observe(notificationName, handler: handler, handlerManager: nil)
	}
	
	
	internal func observe(_ notificationName:String, handler:@escaping (NamedNotification)->Void, handlerManager:NotificationHandlers?) -> HandlerID {
		
		let _handler = { (notification: NotificationProtocol) -> Void in
			
			let notification = notification as! NamedNotification
			
			if notification.name == notificationName {
				
				handler(notification)
			}
		}
		
		return invokeOnProcessingQueueSynchronously {
			
			let handler = _NotificationObservingHandler(NamedNotification.self, targetName: notificationName, handler: _handler, handlerManager: handlerManager)
			
			_notificationObservingHandlers.append(handler)
			try! handlerManager?._addHandlerID(handler.handlerID)
			
			return handler.handlerID
		}
	}
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	/// The argument `notification` is used to help type inference.
	
	public func observe<T:NotificationProtocol>(_ notification: T.Type, handler: @escaping (T)->Void) -> HandlerID {
		
		return observe(handler, handlerManager: nil)
	}
	
	/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
	
	public func observe<T:NotificationProtocol>(_ handler: @escaping (T)->Void) -> HandlerID {
	
		return observe(handler, handlerManager: nil)
	}
	
	
	public func observe<T:NotificationProtocol>(_ handler: @escaping (T)->Void, handlerManager: NotificationHandlers?) -> HandlerID {

		let _getNotification:(NotificationProtocol)->T = {
			
			if T.self is AnyNotification.Type {
				
				return AnyNotification($0) as! T
			}
			else {

				return $0 as! T
			}
		}
		
		let _handler: (NotificationProtocol) -> Void = {
			
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
	public static func releaseObservingHandler(_ handlerIDs: HandlerID...) {
	
		_notificationManager.releaseObservingHandlers(Set(handlerIDs))
	}
	
	/// Release all observing handler for the `target`.
	public static func releaseObservingHandlers(_ handlerIDs: Set<HandlerID>) {
		
		_notificationManager.releaseObservingHandlers(Set(handlerIDs))
	}
	
	/// Release all observing handler for the `target`.
	public func releaseObservingHandlers(_ handlerIDs: Set<HandlerID>) {

		// Invoke `release` synchronously.
		invokeOnProcessingQueueSynchronously {

			_releaseObservingHandlers(handlerIDs)
		}
	}

	/// Release all observing handler for the `target`.
	func _releaseObservingHandlers(_ targetHandlerIDs: Set<HandlerID>) {

		func indexOfObservingHandlersByTargetHandlerID(targetHandlerID: HandlerID) -> Int? {
			
			return _notificationObservingHandlers.index { observingHandler in
				
				targetHandlerID.containsInHandler(observingHandler)
			}
		}
		
		var targetHandlerIndexes: [Int] {

			return targetHandlerIDs.flatMap(indexOfObservingHandlersByTargetHandlerID)
		}

		for index in targetHandlerIndexes.sorted(by: >) {
			
			_notificationObservingHandlers.remove(at: index)
		}
	}
}

extension NotificationManager {

	/// The method is called when the observer received an notification.
	func received(_ notification: NotificationProtocol) {

		guard !NotificationManager.dammingNotifications else {
			
			dammNotification(notification)
			return
		}
		
		invokeOnProcessingQueueSyncIfNeeded {

			self._received(notification)
		}
	}

	/// The method is called when the observer received an notification.
	func received(_ rawNotification: Foundation.Notification) {
		
		guard !NotificationManager.dammingNotifications else {
			
			dammNotification(rawNotification)
			return
		}
		
		invokeOnProcessingQueueSyncIfNeeded {
			
			self._received(rawNotification)
		}
	}
	
	fileprivate func _received(_ notification: NotificationProtocol) {
		
		_notificationObservingHandlers.forEach {
			
			$0.invoke(notification)
		}
	}

	fileprivate func _received(_ rawNotification: Foundation.Notification) {
		
		let targetNotificationNames = _notificationObservingHandlers.flatMap { $0.targetName }
		
		guard targetNotificationNames.contains(rawNotification.name.rawValue) else {
		
			// drop the notification which will not be handled.
			return
		}
		
		_received(NamedNotification(rawNotification: rawNotification))
	}

	fileprivate func _received(_ dammedNotification: NotificationBox) {
		
		switch dammedNotification {
			
		case .nativeNotification(let notification):
			_received(notification)
			
		case .rawNotification(let notification):
			_received(notification)
		}
	}
	
	func dammNotification(_ notification: NotificationProtocol) {
		
		invokeOnProcessingQueue {
			
			self._dammNotification(notification)
		}
	}
	
	func dammNotification(_ rawNotification: Foundation.Notification) {
		
		invokeOnProcessingQueue {
			
			self._dammNotification(rawNotification)
		}
	}
	
	func _dammNotification(_ notification: NotificationProtocol) {
	
		_notificationDam.append(notification as! NotificationBox)
	}
	
	func _dammNotification(_ rawNotification: Foundation.Notification) {
		
		_notificationDam.append(rawNotification)
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
func ~= (pattern: NotificationProtocol.Type, value: NotificationProtocol.Type) -> Bool {
	
	let id1 = ObjectIdentifier(pattern)
	let id2 = ObjectIdentifier(value)
	
	return id1 == id2
}

/// Notification Handler Wrapper.
final class _NotificationObservingHandler {

	typealias NotificationHandler = (NotificationProtocol) -> Void

	fileprivate static var _lastHandlerID = Int.min
	
	fileprivate(set) var handlerID: HandlerID
	fileprivate(set) var target: NotificationProtocol.Type
	fileprivate(set) var targetName: String?
	fileprivate(set) var handler: NotificationHandler
	
	init(_ target: NotificationProtocol.Type, targetName: String?, handler: @escaping NotificationHandler, handlerManager: NotificationHandlers?) {
		
		self.handlerID = _NotificationObservingHandler._getNextHandlerID(handlerManager)
		self.target = target
		self.targetName = targetName
		self.handler = handler
	}
	
	fileprivate static func _getNextHandlerID(_ handlerManager: NotificationHandlers?) -> HandlerID {
		
		defer {
		
			_lastHandlerID = (_lastHandlerID + 1)
		}
		
		return HandlerID(_lastHandlerID, handlerManager: handlerManager)
	}
	
	/// Invoke notification handler. If the `notification` type is not same type as self.target, do nothing.
	func invoke(_ notification: NotificationProtocol) {

		switch target {
			
		case type(of: notification), AnyNotification.self:
			_invokeHandlerOnMainThread(notification)
			
		default:
			break
		}
	}

	/// Invoke notification handler on main thread asynchronously.
	func _invokeHandlerOnMainThread(_ notification: NotificationProtocol) {
		
		switch Thread.isMainThread {
			
		case true:
			handler(notification)

		case false:
			DispatchQueue.main.sync { handler(notification) }
		}
	}
}

// MARK: - Internal Observer

/// Observe raw notifications.
final class _NotificationObserver : NSObject {

	fileprivate unowned var _manager:NotificationManager
	
	init(_ manager:NotificationManager) {
		
		self._manager = manager
		
		super.init()
	}
	
	/// The method is called when the observer received an notification.
	func received(_ rawNotification: Foundation.Notification) {
	
		if let notification = rawNotification.toESNativeNotification() {

			_manager.received(notification)
		}
		else {

			_manager.received(rawNotification)
		}
	}
}
