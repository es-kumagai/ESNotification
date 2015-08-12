//
//  ModalWindowController.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/08/13.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Cocoa

class ModalWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

	func windowWillClose(notification: NSNotification) {
		
		NSApp.stopModal()
	}
}
