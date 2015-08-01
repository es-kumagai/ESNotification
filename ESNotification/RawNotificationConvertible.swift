//
//  RawNotificationConvertible.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/05/04.
//
//

import Foundation

public protocol RawNotificationConvertible {
	
	/// Initialize with a Raw Notification.
	init(rawNotification:NSNotification)
}

public protocol RawNotificationType {
	
	/// Get a Raw Notification. When you try posting the notification, the rawNotification will post.
	var rawNotification:NSNotification { get }
}

