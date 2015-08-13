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
	}
	
	@IBAction func sendNotification(sender:AnyObject?) {
		
		SampleNotification().post()
	}
	
	@IBAction func dummingToggle(sender:AnyObject?) {
		
		NotificationManager.dammingNotifications = !NotificationManager.dammingNotifications
		
		NSLog("Dumming = \(NotificationManager.dammingNotifications)")
	}
}

