//
//  HandlerID.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/12/01.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

public struct HandlerID : Hashable {
	
	internal var value:Int
	internal weak var handlerManager: NotificationHandlers?
	
	init(_ value:Int, handlerManager: NotificationHandlers?) {
		
		self.value = value
		self.handlerManager = handlerManager
	}
	
	mutating func increment() {
		
		++self.value
	}
	
	public var hashValue: Int {
		
		return Int(self.value)
	}
	
	/// Release observing handler by HandlerID
	public func release() {
		
		if let handlerManager = self.handlerManager {
			
			try! handlerManager.releaseHandler(self)
		}
		else {
			
			_notificationManager.releaseObservingHandlers([self])
		}
	}
	
	func containsInHandler(handler: _NotificationObservingHandler) -> Bool {
		
		return handler.handlerID == self
	}
}