//
//  Deprecated.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/10/15.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation

/// Post the `notification`.
@available(*, unavailable, message: "access the 'post' method on the Notification")
public func post<T:Notification>(_ notification: T) {}

/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
/// The argument `notification` is used to help type inference.
@available(*, unavailable, message: "access the 'observeBy' method on the Notification")
public func observe<OWNER:AnyObject, T:Notification>(_ owner: OWNER, _ notification: T.Type, handler: (OWNER, T) -> Void) -> Never { fatalError() }

/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
@available(*, unavailable, message: "access the 'observeBy' method on the Notification")
public func observe<OWNER:AnyObject, T:Notification>(_ owner: OWNER, handler: (OWNER, T) -> Void) -> Never { fatalError() }

/// Release observing handler by HandlerID
@available(*, unavailable, message: "access the 'release' method on the NotificationManager.HandlerID")
public func releaseHandler(_ handlerID: HandlerID) {}

// MARK: - Raw Support

/// Get name of the `notification`.
@available(*, unavailable, message: "access the 'notificationIdentifier' property on the Notification")
public func identifierOf<T:Notification>(_ notification: T) -> Never { fatalError() }

/// Get name of the `notification`.
@available(*, unavailable, message: "access the 'notificationIdentifier' property on the Notification")
public func identifierOf<T:Notification>(_ type: T.Type) -> Never { fatalError() }

// MARK: - Internal Support

/// Create an NSNotification from the `notification`.
@available(*, unavailable, message: "access the 'makeRawNotificationForNativePost' method on the Notification")
func makeRawNotificationForNativePost<T:Notification>(_ notification: T) -> Never { fatalError() }

/// Returns a boolean value whether the `rawNotification` is an Native notification.
@available(*, unavailable, message: "access the 'isESNativeNotification' property on the NSNotification")
func isNativeNotification(_ rawNotification: Foundation.Notification) -> Never { fatalError() }

/// Get the native notification from the `rawNotification`. Returns nil if `rawNotification` is not an Native notification.
@available(*, unavailable, message: "access the 'toESNativeNotification' method on the NSNotification")
func nativeNotificationFrom(_ rawNotification: Foundation.Notification) -> Never { fatalError() }
