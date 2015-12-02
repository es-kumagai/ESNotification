# ESNotification

A type-safe notification management system for iOS/OSX written in Swift 2.

It is a swift module that powerfully notification management system using type-safe notification types. Notifications using this system are compatible with NSNotificationCenter.

This module written in Swift 2.0 and the module supports Objective-C.

# Usage in Swift

## Definition

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

## Observe using NotificationObservable object features

### Preparation

First, an object which observe some notifications need to conforms to `NotificationObservable ` protocol.

```swift
extension ViewController : NotificationObservable {

	var notificationHandlers = NotificationHandlers()
	
}
```

### Native Notification

Then, to observe an Native Notification (e.g. `MyNativeNotification`), use `observeNotification:` method defined in `NotificationObservable` protocol.

```swift
self.observeNotification { [unowned self] (notification: MyNativeNotification) in
	
	...
}
```

In other way, you can specify an notification type using argument too.

```swift
self.observeNotification(MyNativeNotification.self) { [unowned self] notification in
	
	...
}
```

### Named Notification (includes NSNotification)

You can observer a Named Notification (includes Legacy NSNotification) using `observeNotificationNamed:handler` method defined in `NotificationObservable` protocol.

```swift
self.observeNotificationNamed(NSApplicationWillTerminateNotification) { [unowned self] notification in
	
	...
}
```

> Type of `notification` argument is `NamedNotification` type.

## Observe using Notification type features

### Native Notification

You can observe a Notification using `observeBy:handler:` method privided by a type conforms to `Notification` protocol.

```swift
let handlerID = MyNativeNotification.observe { [unowned self] notification -> Void in

	...
}
```

> Usually, you want to use `self` instance in `handler` closure, you need to pass the instance as an **unowned** reference or a **weak** reference using capture list. 

### Named Notification (includes NSNotification)

You can observe a Named Notification easily by using `observe:by:handler:` method. If same name of named notification posted, you can handle it.

```swift
let handlerID = NamedNotification.observe(name) { [unowned self] notification in
			
	...
}
```

> NSNotification can be handle in the same way.

## Note for Observing

When a notification of `Notification` Type posted, the `handler` closure is called on main thread.

At this time, the posted notification passed to parameter of `handler`. The notification can use as Handled Notification type own.

> If observer released, the observing handler is released too.
> When you want to release implicitly, save `HandlerID` returns by `observe` function, and call `release` method of the Handler ID.

## Post a Notification

You can post a Notification using `post` function.

```swift
MyNativeNotification().post()
```

You can post a Named Notification too.

```swift
NamedNotification(NSApplicationWillTerminateNotification).post()
```

You can post a Named Notification using Legacy `NSNotificationCenter` too. The following code is same to below code.

```swift
let notification = NSNotification(name: NSApplicationWillTerminateNotification, object: nil)

NSNotificationCenter.defaultCenter().postNotification(notification)
```

# Usage in Objective-C

### Define Native Notifications

In Swift, if you want to post a Native Notification in Objective-C, You must your notification class conforms to `Notification` protocol and export to Objective-C by inheriting `NSObject` class.

```swift
class MyNativeNotification : NSObject, Notification {
}
```

In Objective-C, you must your notification class conforms to `ESNotification` protocol.

```Objective-C
@interface MyNativeNotification : NSObject <ESNotification>

@end
```

## Observing

You can observe **Native Notification** in Objective-C. To observing a Native Notification, you use `- addObserver:selector:ESNotification:object;` method implemented in `NSNotificationCenter`.

```objc
NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];

[nc addObserver:self selector:@selector(myNativeNotificationReceived:) ESNotification:[MyNativeNotification class] object:nil];
```

When a Native notification received by NSNotificationCenter, the Native Notification instance set to `object` property of NSNotification passed by parameter.

```objc
- (void)myNativeNotificationReceived:(NSNotification*)note
{
	MyNativeNotification* nativeNotification = note.object;
	
}
```

## Post a Native Notification

You call the method when you want to post a **Native Notification**.

```Objective-C
NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
MyNativeNotification* notification = [[MyNativeNotification alloc] init];

[notificationCenter postESNotification:notification];
```

# Installation

ESNotification can install using CocoaPods.

```podfile
use_frameworks!

pod 'ESNotification'
```
