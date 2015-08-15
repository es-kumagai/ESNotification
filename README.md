# ESNotification

A type-safe notification management system for iOS/OSX written in Swift 2.

It is a swift module that powerfully notification management system using type-safe notification types. Notifications using this system are compatible with NSNotificationCenter.

This module written in Swift 2.0. Supports Objective-C.

## How to use

### Definition

You define Notifications by Object that confirms to `Notification` Protocol.

```swift
final class MyNativeNotification : Notification {
}
```

You can also implement properties and methods in the object. It work user information of the notification. It can be accessed type-safely.

```swift
final class MyNativeNotification : Notification {

	var serial:Int
	var validation:Bool
}
```

### Observe

#### Native Notification

You can observe a Notification using `observeBy:handler:` method privided by a type conforms to `Notification` protocol.

```swift
MyNativeNotification.observeBy(self) { (owner, notification) -> Void in

	...
}
```

To specifiy the `handler` closure type, you can omit specify a notification type for observing by argument. 

Usually, you set the first parameter `owner` to `self`. The `owner` is references by weak, and passed to `handler` closure.

#### Named Notification (includes NSNotification)

You can observe a Named Notification easily by using `observe:by:handler:` method. If same name of named notification posted, you can handle it.

```swift
NamedNotification.observe(name, by: self) { owner, notification in
			
	...
}
```

> NSNotification can be handle in the same way.

#### Note

When a notification of `notification` Type posted, the `handler` closure is called on main thread.

At this time, the first parameter is reference of owner object and the second parameter is a posted notification. The notification can use as Handled Notification type own.

> If owner released, the observing handler is released too.
> When you want to release implicitly, save `HandlerID` returns by `observe` function, and call `releaseHandler` function with the Handler ID.

### Post

You can post a Notification using `post` function.

```swift
MyNativeNotification().post()
```

## Use in Objective-C

### Observing

You can observe `Native Notification` in Objective-C.

If you want to observe Native Notifications, previously you must get the Notification name to use  `identifierOf(AnyNativeNotification.self)` in Swift.

Then you observe Notifications that have the Notification name by NSNotificationCenter, you can handle the notification.

### Post a Native Notification

If you want to post a Native Notification in Objective-C, You must implement a method for post in Swift.

```swift
@objc final class MyNativeNotification : NSObject, Notification {
	static func post() {
	
		MyNativeNotification().post()
	}
}
```

Then, you call the method when you want to post the Native Notification.

```Objective-C
[MyNativeNotification post];
```
