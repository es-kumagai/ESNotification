//
//  ModalViewController.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/08/13.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Cocoa

class ModalViewController: NSViewController, NotificationObservable {

	var notificationHandlers = NotificationHandlers()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		
		self.observeNotification(ESSampleSwiftNotification.self) { notification in
			
			print("Received by Modal View Controller : \(notification)")
		}
		
		self.observeNotification(ESSampleObjCNotification.self) { notification in
			
			print("Received by Modal View Controller : \(notification)")
		}
    }
	
	override func dismissController(sender: AnyObject?) {
		
		super.dismissController(sender)
		
		self.view.window?.close()
	}
	
	@IBAction func sendNotification(sender:AnyObject?) {
		
		SampleNotification().post()
	}
}
