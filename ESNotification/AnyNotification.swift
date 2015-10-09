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

	public private(set) var notification:_Notification
	
	init(_ notification:_Notification) {
		
		self.notification = notification
		
		super.init()
	}
}
