//
//  ViewController.swift
//  RunModalTestApp
//
//  Created by Tomohiro Kumagai on H27/08/13.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Cocoa
import ESNotification

class ViewController: NSViewController {

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
		
		SampleNotification.observeBy(self) { owner, notification in
			
			print("\(notification) received.")
		}
		
		NamedNotification.observe(ViewController.NamedTestANotification, by: self) { owner, notification in
			
			print("\(notification) received by handler for Test A.")
		}
		
		NamedNotification.observe(ViewController.NamedTestBNotification, by: self) { owner, notification in
			
			print("\(notification) received by handler for Test B.")
		}
	}
	
	@IBAction func sendNotification(sender:AnyObject?) {
		
		SampleNotification().post()
	}
	
	@IBAction func sendNamedNotificationA(sender:AnyObject?) {
		
		let center = NSNotificationCenter.defaultCenter()
		
		center.postNotification(NSNotification(name: ViewController.NamedTestANotification, object: nil))
	}
	
	@IBAction func sendNamedNotificationB(sender:AnyObject?) {
		
		let center = NSNotificationCenter.defaultCenter()
		
		center.postNotification(NSNotification(name: ViewController.NamedTestBNotification, object: nil))
	}
	
	@IBAction func dummingToggle(sender:AnyObject?) {
		
		NotificationManager.dammingNotifications = !NotificationManager.dammingNotifications
		
		NSLog("Dumming = \(NotificationManager.dammingNotifications)")
	}
}

