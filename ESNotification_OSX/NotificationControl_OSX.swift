//
//  NotificationControl_OSX.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/08/13.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Cocoa

public func invokeOnProcessingQueueSyncIfNeeded(predicate:()->Void) -> Void {

	// In OSX, always invoke synchronously.
	// Because when modal window shown from menu in OSX, need to invoke synchronously.
	// Otherwise the app clash when _NSWindowTransformAnimation notification is received.
	invokeOnProcessingQueueSynchronously(predicate)
}
