//
//  NotificationBox.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/10/10.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation

internal enum NotificationBox {
	
	case nativeNotification(NotificationProtocol)
	case rawNotification(Foundation.Notification)

	func value() -> NotificationProtocol {
		
		guard case let .nativeNotification(value) = self else {
			
			fatalError("Type mismatch (expected \(NotificationProtocol.self)).")
		}
		
		return value
	}
	
	func value() -> Foundation.Notification {
		
		guard case let .rawNotification(value) = self else {
			
			fatalError("Type mismatch (expected \(Foundation.Notification.self)).")
		}
		
		return value
	}
}

extension RangeReplaceableCollection where Iterator.Element == NotificationBox {
	
	mutating func append(_ notification: NotificationProtocol) {
		
		append(.nativeNotification(notification))
	}
	
	mutating func append(_ notification: Foundation.Notification) {
		
		append(.rawNotification(notification))
	}
}
