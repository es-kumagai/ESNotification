//
//  AnyNotification.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/05/04.
//
//

import Foundation

/// This notification type is used to handle any of notifications.
public final class AnyNotification : NSObject, Notification {

	public fileprivate(set) var notification: NotificationProtocol
	
	init(_ notification: NotificationProtocol) {
		
		self.notification = notification
		
		super.init()
	}
}
