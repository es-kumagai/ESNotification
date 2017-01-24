//
//  NotificationControl.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/05/04.
//
//

import Foundation

private let NotificationRawNamePrefix = "jp.ez-net.notification."

extension NotificationProtocol {
	
	/// Returns the name of the `notification`.
	public var notificationIdentifier: String {
		
		return type(of: self).notificationIdentifier
	}
	
	/// Returns the name of the `notification` in Foundation.Notification.
	public var rawNotificationName: Foundation.Notification.Name {
		
		return type(of: self).rawNotificationName
	}
	
	/// Returns the name of the `notification`.
	public static var notificationIdentifier: String {

		return "\(NotificationRawNamePrefix)\(self)"
	}
	
	/// Returns the name of the `notification` in Foundation.Notification.
	public static var rawNotificationName: Foundation.Notification.Name {
		
		return Foundation.Notification.Name(rawValue: notificationIdentifier)
	}
}

extension Foundation.Notification {
	
	/// Returns a boolean value whether the `rawNotification` is an Native notification.
	var isESNativeNotification: Bool {
		
		return name.rawValue.hasPrefix(NotificationRawNamePrefix)
	}
	
	/// Get the native notification from the `rawNotification`. Returns nil if `rawNotification` is not an Native notification.
	func toESNativeNotification() -> NotificationProtocol? {
		
		if isESNativeNotification {
			
			return object as? NotificationProtocol
		}
		else {
			
			return nil
		}
	}
}

// MARK: - Thread

private let _processingQueueLabel = "jp.ez-net.thread.notification"
private let _processingQueue = DispatchQueue(label: _processingQueueLabel, attributes: [])

/// Invoke `predicate` asynchronously on the thread for Notification processing.
public func invokeOnProcessingQueue(_ predicate: @escaping () -> Void) -> Void {
	
	_processingQueue.async(execute: predicate)
}

/// Invoke `predicate` synchronously on the thread for Notification processing.
public func invokeOnProcessingQueueSynchronously<R>(_ predicate: () -> R) -> R {
	
	var result: R!
	
	_processingQueue.sync {
		
		result = predicate()
	}
	
	return result
}

/// Invoke `predicate` synchronously on the thread for Notification processing.
public func invokeOnProcessingQueueSynchronously<R>(_ predicate:() throws -> R) throws -> R {

	var result: R!
	var resultError: Error?
	
	_processingQueue.sync {
		
		do {

			result = try predicate()
		}
		catch {
			
			resultError = error
		}
	}

	switch resultError {
		
	case .none:
		return result
		
	case .some(let error):
		throw error
	}
}
