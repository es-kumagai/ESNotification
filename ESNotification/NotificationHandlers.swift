//
//  NotificationHandlers.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/11/30.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Swim

/// A class for manage notification handler **IDs** which are observed by `NotificationObserver`.
public final class NotificationHandlers {
	
	enum Error : ErrorType {
		
		case HandlerIsNotFound(handlerID: HandlerID)
		case HandleIDIsAlreadyExists(handlerID: HandlerID)
	}

	typealias _HandlerIDs = Set<HandlerID>
	
	private var _handlerIDs: _HandlerIDs

	public init() {
		
		self._handlerIDs = []
	}
	
	deinit {
		
		self.releaseAllHandlers()
	}
}

extension NotificationHandlers {
	
	internal func _guardHandlerContaining(handlerIDs: Set<HandlerID>) throws {
		
		for handlerID in handlerIDs {
			
			if !self._handlerIDs.contains(handlerID) {
				
				throw Error.HandlerIsNotFound(handlerID: handlerID)
			}
		}
	}
	
	internal func _addHandlerID(handlerID:HandlerID) throws {
	
		guard !self._handlerIDs.contains(handlerID) else {
			
			throw Error.HandleIDIsAlreadyExists(handlerID: handlerID)
		}
		
		self._handlerIDs.insert(handlerID)
	}
	
	internal func releaseHandler(handlerIDs: HandlerID...) throws {

		try self.releaseHandlers(Set(handlerIDs))
	}
	
	internal func releaseHandlers(handlerIDs: Set<HandlerID>) throws {

		try invokeOnProcessingQueueSynchronously {

			try self._guardHandlerContaining(handlerIDs)
			
			_notificationManager._releaseObservingHandlers(handlerIDs)
			self._handlerIDs.subtractInPlace(handlerIDs)
		}
	}
	
	internal func releaseAllHandlers() {
		
		invokeOnProcessingQueueSynchronously {
		
			_notificationManager._releaseObservingHandlers(self._handlerIDs)
			self._handlerIDs.removeAll()
		}
	}
}
