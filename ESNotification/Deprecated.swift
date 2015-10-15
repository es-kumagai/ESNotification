//
//  Deprecated.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/10/15.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation

/// Post the `notification`.
@available(*, unavailable, message="access the 'post' method on the Notification")
public func post<T:Notification>(notification:T) {}

/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
/// The argument `notification` is used to help type inference.
@available(*, unavailable, message="access the 'observeBy' method on the Notification")
@noreturn public func observe<OWNER:AnyObject, T:Notification>(owner:OWNER, _ notification:T.Type, handler:(OWNER,T)->Void) -> NotificationManager.HandlerID {}

/// Observe an Native notification. When the native notification was post, the `handler` called in main thread.
@available(*, unavailable, message="access the 'observeBy' method on the Notification")
@noreturn public func observe<OWNER:AnyObject, T:Notification>(owner:OWNER, handler:(OWNER,T)->Void) -> NotificationManager.HandlerID {}

/// Release observing handler by HandlerID
@available(*, unavailable, message="access the 'release' method on the NotificationManager.HandlerID")
public func releaseHandler(handlerID:NotificationManager.HandlerID) {}

// MARK: - Raw Support

/// Get name of the `notification`.
@available(*, unavailable, message="access the 'notificationIdentifier' property on the Notification")
@noreturn public func identifierOf<T:Notification>(notification:T) -> String {}

/// Get name of the `notification`.
@available(*, unavailable, message="access the 'notificationIdentifier' property on the Notification")
@noreturn public func identifierOf<T:Notification>(type:T.Type) -> String {}

// MARK: - Internal Support

/// Create an NSNotification from the `notification`.
@available(*, unavailable, message="access the 'makeRawNotificationForNativePost' method on the Notification")
@noreturn func makeRawNotificationForNativePost<T:Notification>(notification:T) -> NSNotification {}

/// Returns a boolean value whether the `rawNotification` is an Native notification.
@available(*, unavailable, message="access the 'isOceanNativeNotification' property on the NSNotification")
@noreturn func isNativeNotification(rawNotification:NSNotification) -> Bool {}

/// Get the native notification from the `rawNotification`. Returns nil if `rawNotification` is not an Native notification.
@available(*, unavailable, message="access the 'toOceanNativeNotification' method on the NSNotification")
@noreturn func nativeNotificationFrom(rawNotification:NSNotification) -> Notification? {}
