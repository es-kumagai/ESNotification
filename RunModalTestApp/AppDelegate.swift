//
//  AppDelegate.swift
//  RunModalTestApp
//
//  Created by Tomohiro Kumagai on H27/08/13.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}

	@IBAction func showModal(sender:AnyObject!) {
		
		let storyboard = NSStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateControllerWithIdentifier("ModalWindow") as! NSWindowController
		
		NSApp.runModalForWindow(controller.window!)
	}
}

