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

extension NotificationProtocol {
	
	/// Get name of the `notification`.
	public var notificationIdentifier:String {
		
		return self.dynamicType.notificationIdentifier
	}
	
	/// Get name of the `notification`.
	public static var notificationIdentifier:String {

		return "\(NotificationRawNamePrefix)\(self)"
	}
}

extension NSNotification {
	
	/// Returns a boolean value whether the `rawNotification` is an Native notification.
	var isESNativeNotification:Bool {
		
		return self.name.hasPrefix(NotificationRawNamePrefix)
	}
	
	/// Get the native notification from the `rawNotification`. Returns nil if `rawNotification` is not an Native notification.
	func toESNativeNotification() -> NotificationProtocol? {
		
		if self.isESNativeNotification {
			
			return self.object as? NotificationProtocol
		}
		else {
			
			return nil
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

/// Invoke `predicate` synchronously on the thread for Notification processing.
public func invokeOnProcessingQueueSynchronously<R>(predicate:() throws -> R) throws -> R {
	
	return try invoke(_processingQueue, predicate: predicate)
}
