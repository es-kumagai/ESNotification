//
//  NotificationObjC.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/10/15.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation

public class NativeNotificationObject : NSObject, Notification {
	
	public static let name = NativeNotificationObject.notificationIdentifier
	
	public func postNotification() {
		
		self.post()
	}
}
