//
//  AnyNotification.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/05/04.
//
//

import Foundation

/// This notification type is used to handle any of notifications.
@objc public class AnyNotification : NSObject, Notification {

	public private(set) var notification:Notification
	
	init(_ notification:Notification) {
		
		self.notification = notification
		
		super.init()
	}
}
