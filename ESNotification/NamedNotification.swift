//
//  NamedNotification.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/05/03.
//
//

import Foundation

/// This Notification represent almost the same thing as NSNotification.
@objc public final class NamedNotification : NSObject, Postable, RawNotificationConvertible, RawNotificationType {
	
	public typealias UserInfo = [AnyHashable: Any]
	
	public fileprivate(set) var name: String
	public fileprivate(set) var object: Any?
	public fileprivate(set) var userInfo: UserInfo?
	
	public var notificationName: Foundation.Notification.Name {
	
		return Foundation.Notification.Name(rawValue: name)
	}
	
	public convenience init(_ name: String) {
		
		self.init(name, object: nil, userInfo: nil)
	}
	
	public convenience init(_ name: String, object: AnyObject?) {
		
		self.init(name, object: object, userInfo: nil)
	}
	
	public init(_ name: String, object: AnyObject?, userInfo: UserInfo?) {
		
		self.name = name
		self.object = object
		self.userInfo = userInfo
		
		super.init()
	}
	
	/// Initialize with a Raw Notification.
	public required convenience init(rawNotification: Foundation.Notification) {
		
		self.init(rawNotification.name.rawValue, object:rawNotification.object as AnyObject?, userInfo:rawNotification.userInfo)
	}
	
	/// Get a Raw Notification.
	public var rawNotification: Foundation.Notification {
		
		return Foundation.Notification(name: notificationName, object: object, userInfo: userInfo)
	}
}

extension NamedNotification {
	
	public override var description: String {
		
		return "\(NamedNotification.self)(\(name))"
	}
}
