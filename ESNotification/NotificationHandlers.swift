//
//  NotificationHandlers.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/11/30.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

/// A class for manage notification handler **IDs** which are observed by `NotificationObserver`.
public final class NotificationHandlers {
	
	enum Error : Swift.Error {
		
		case handlerIsNotFound(handlerID: HandlerID)
		case handleIDIsAlreadyExists(handlerID: HandlerID)
	}

	typealias _HandlerIDs = Set<HandlerID>
	
	fileprivate var _handlerIDs: _HandlerIDs

	public init() {
		
		self._handlerIDs = []
	}
	
	deinit {
		
		self.releaseAllHandlers()
	}
}

extension NotificationHandlers {
	
	internal func _guardHandlerContaining(_ handlerIDs: Set<HandlerID>) throws {
		
		for handlerID in handlerIDs {
			
			if !self._handlerIDs.contains(handlerID) {
				
				throw Error.handlerIsNotFound(handlerID: handlerID)
			}
		}
	}
	
	internal func _addHandlerID(_ handlerID:HandlerID) throws {
	
		guard !self._handlerIDs.contains(handlerID) else {
			
			throw Error.handleIDIsAlreadyExists(handlerID: handlerID)
		}
		
		self._handlerIDs.insert(handlerID)
	}
	
	internal func releaseHandler(_ handlerIDs: HandlerID...) throws {

		try self.releaseHandlers(Set(handlerIDs))
	}
	
	internal func releaseHandlers(_ handlerIDs: Set<HandlerID>) throws {

		try invokeOnProcessingQueueSynchronously {

			try self._guardHandlerContaining(handlerIDs)
			
			_notificationManager._releaseObservingHandlers(handlerIDs)
			self._handlerIDs.subtract(handlerIDs)
		}
	}
	
	internal func releaseAllHandlers() {
		
		invokeOnProcessingQueueSynchronously {
		
			_notificationManager._releaseObservingHandlers(self._handlerIDs)
			self._handlerIDs.removeAll()
		}
	}
}
