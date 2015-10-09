//
//  NamedNotification.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/05/03.
//
//

import Foundation

/// This Notification represent almost the same thing as NSNotification.
@objc public class NamedNotification : NSObject, _Notification, RawNotificationConvertible, RawNotificationType {
	
	public typealias UserInfo = [NSObject : AnyObject]
	
	public private(set) var name:String
	public private(set) var object:AnyObject?
	public private(set) var userInfo:UserInfo?
	
	public convenience init(_ name:String) {
		
		self.init(name, object: nil, userInfo: nil)
	}
	
	public convenience init(_ name:String, object:AnyObject?) {
		
		self.init(name, object: object, userInfo: nil)
	}
	
	public init(_ name:String, object:AnyObject?, userInfo:UserInfo?) {
		
		self.name = name
		self.object = object
		self.userInfo = userInfo
		
		super.init()
	}
	
	/// Initialize with a Raw Notification.
	public required convenience init(rawNotification:NSNotification) {
		
		self.init(rawNotification.name, object:rawNotification.object, userInfo:rawNotification.userInfo)
	}
	
	/// Get a Raw Notification.
	public var rawNotification:NSNotification {
		
		return NSNotification(name: self.name, object: self.object, userInfo: self.userInfo)
	}
}

extension NamedNotification {
	
	public override var description:String {
		
		return "\(NamedNotification.self)(\(self.name))"
	}
}
