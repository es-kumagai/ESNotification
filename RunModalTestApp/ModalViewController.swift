//
//  ModalViewController.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/08/13.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Cocoa

class ModalViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
	
	override func dismissController(sender: AnyObject?) {
		
		super.dismissController(sender)
		
		self.view.window?.close()
	}
	
	@IBAction func sendNotification(sender:AnyObject?) {
		
		SampleNotification().post()
	}
}
