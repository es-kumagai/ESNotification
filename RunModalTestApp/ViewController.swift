//
//  ViewController.swift
//  RunModalTestApp
//
//  Created by Tomohiro Kumagai on H27/08/13.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Cocoa
import ESNotification

class ViewController: NSViewController, NotificationObservable {

	static let NamedTestANotification = "ESNotification.NamedNotificationForTestA"
	static let NamedTestBNotification = "ESNotification.NamedNotificationForTestB"
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	override func viewWillAppear() {
		
		super.viewWillAppear()
		
		self.observeNotification { (notification: SampleNotification) in

			print("\(notification) received.")
		}
		
		self.observeNotification(SampleNotification.self) { notification in
			
			print("\tIn other way: \(notification) received.")
		}
		
		self.observeNotificationNamed(ViewController.NamedTestANotification) { notification in
			
			print("\(notification) received by handler for Test A.")
		}
		
		self.observeNotificationNamed(ViewController.NamedTestBNotification) { notification in
			
			print("\(notification) received by handler for Test B.")
		}
	}
	
	@IBAction func sendNotification(sender:AnyObject?) {
		
		SampleNotification().post()
	}
	
	@IBAction func sendNamedNotificationA(sender:AnyObject?) {

		// Post using native features.
		NamedNotification(ViewController.NamedTestANotification).post()
	}
	
	@IBAction func sendNamedNotificationB(sender:AnyObject?) {

		// Post using NSNotificationCenter.
		let center = NSNotificationCenter.defaultCenter()
		
		center.postNotification(NSNotification(name: ViewController.NamedTestBNotification, object: nil))
	}
	
	@IBAction func dammingToggle(sender:AnyObject?) {
		
		NotificationManager.dammingNotifications = !NotificationManager.dammingNotifications
		
		NSLog("Damming = \(NotificationManager.dammingNotifications)")
	}
}

