//
//  MyNativeNotification.swift
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/08/17.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation
import ESNotification

final class MyNativeNotification : NativeNotificationObject {

	var myValue:Int
	
	init(myValue:Int) {
		
		self.myValue = myValue
		
		super.init()
	}	
}
