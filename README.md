# Ocean.Notification

## How to use

### Definition

You define Notifications by Object that confirms to `Notification` Protocol.

```swift
final class MyNativeNotification : Notification {
}
```

> You can also implement properties and methods in the object.

### Observe

You can observe a Notification using `observe:owner:notification:handler:` function.

```swift
observe(self, MyNativeNotification.self) {

	let owner = $0
	let notification = $1
	
	...
}
```

Usually, you set the first parameter `owner` to `self`. The `owner` is references by weak, and passed to `handler` closure.

---

When a notification of `notification` Type posted, the `handler` closure is called on main thread.

At this time, the first parameter is reference of owner object and the second parameter is a posted notification. The notification can use as Handled Notification type own.

> If owner released, the observing handler is released too.
> When you want to release implicitly, save `HandlerID` returns by `observe` function, and call `releaseHandler` function with the Handler ID.

---

There is also another way of writing of `observe` function.

```swift
notification:MyNativeNotification.observeBy(self) { (owner:SelfClass, notification:MyNativeNotification) -> Void in

	...
}
```

To specifiy the `handler` closure type, you can omit specify a notification type for observing by argument. 

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
@objc final class MyNativeNotification : Notification {
	static func post() {
	
		Ocean.post(MyNativeNotification())
	}
}
```

Then, you call the method when you want to post the Native Notification.

```Objective-C
[MyNativeNotification post];
```
