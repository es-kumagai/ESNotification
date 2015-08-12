//
//  NotificationControl_iOS.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/08/13.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

public func invokeOnProcessingQueueSyncIfNeeded(predicate:()->Void) -> Void {
	
	// In iOS, always invoke asynchronously.
	invokeOnProcessingQueue(predicate)
}
