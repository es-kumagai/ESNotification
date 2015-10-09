//
//  NotificationBox.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/10/10.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation

internal enum NotificationBox {
	
	case NativeNotification(_Notification)
	case RawNotification(NSNotification)

	func value() -> _Notification {
		
		guard case let .NativeNotification(value) = self else {
			
			fatalError("Type mismatch (expected \(_Notification.self)).")
		}
		
		return value
	}
	
	func value() -> NSNotification {
		
		guard case let .RawNotification(value) = self else {
			
			fatalError("Type mismatch (expected \(NSNotification.self)).")
		}
		
		return value
	}
}

extension RangeReplaceableCollectionType where Generator.Element == NotificationBox {
	
	mutating func append(notification:_Notification) {
		
		self.append(.NativeNotification(notification))
	}
	
	mutating func append(notification:NSNotification) {
		
		self.append(.RawNotification(notification))
	}
}
