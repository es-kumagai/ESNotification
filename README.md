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
MyNativeNotification.observeBy(self) { notification -> Void in

	...
}
```

To specifiy the `handler` closure type, you can omit specify a notification type for observing by argument. 

Usually, you want to use `self` instance in `handler` closure, you need to pass the instance as a weak reference using capture list. 

e.g.

```swift
MyNativeNotification.observeBy(self) { [weak self] notification -> Void in

	...
}
```

#### Named Notification (includes NSNotification)

You can observe a Named Notification easily by using `observe:by:handler:` method. If same name of named notification posted, you can handle it.

```swift
NamedNotification.observe(name, by: self) { notification in
			
	...
}
```

> NSNotification can be handle in the same way.

#### Note

When a notification of `Notification` Type posted, the `handler` closure is called on main thread.

At this time, the posted notification passed to parameter of `handler`. The notification can use as Handled Notification type own.

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

If you want to observe Native Notifications, previously you must your notification class inherit NativeNotificationObject.

```swift
final class MyNativeNotification : NativeNotificationObject {
}
```

Then you observe Notifications that have the Notification name by NSNotificationCenter, you can handle the notification.

```objc
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];

	[nc addObserver:self selector:@selector(myNativeNotificationReceived:) name:MyNativeNotification.name object:nil];
```

When a Native notification received by NSNotificationCenter, the Native Notification instance set to `object` property of NSNotification passed by parameter.

```objc
- (void)myNativeNotificationReceived:(NSNotification*)note
{
	MyNativeNotification* nativeNotification = note.object;
	
}
```

### Post a Native Notification

If you want to post a Native Notification in Objective-C, You must inherit your notification class from `NativeNotificationObject` class in Swift.

```swift
final class MyNativeNotification : NativeNotificationObject {	
}
```

Then, you call the method when you want to post the Native Notification.

```Objective-C
[[[MyNativeNotification alloc] init] postNotification];
```
