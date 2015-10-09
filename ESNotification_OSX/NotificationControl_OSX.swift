//
//  NotificationControl_OSX.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/08/13.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Cocoa

public func invokeOnProcessingQueueSyncIfNeeded(predicate:()->Void) -> Void {

	// In OSX, processing for notification no longer invoke synchronously.
	//
	// Formerly when modal window shown from menu in OSX, need to invoke synchronously.
	// Otherwise the app is clashed when _NSWindowTransformAnimation notification is received.
	//
	// It has been improved by optimizing for named notification.
	// Because the 'invokeOnProcessingQueueSyncIfNeeded' method can remove,
	// but I change invoke mode sync to async without remove the method,
	// and observe whether this modification does not cause some problem.
	invokeOnProcessingQueue(predicate)
}
