//
//  Notification.swift
//  ESOcean
//
//  Created by Tomohiro Kumagai on H27/04/23.
//
//

import Foundation

// MARK: - Protocol

/// All native notifications need to confirm to the protocol.
public protocol Notification : NotificationProtocol, Postable {

}

/// All notifications (without NSNotification) need to confirm to the protocol.
public protocol NotificationProtocol : AnyObject {
	
}
