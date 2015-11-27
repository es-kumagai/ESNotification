//
//  ESNotificationTest.m
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/11/27.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

#import "ESNotificationTest.h"
#import "RunModalTestApp-Swift.h"

@implementation ESNotificationTest

+ (void)postNotificationByObjectiveC
{
	NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];

	ESSampleSwiftNotification* notification1 = [[ESSampleSwiftNotification alloc] init];
	ESSampleObjCNotification* notification2 = [[ESSampleObjCNotification alloc] init];
	
	[notificationCenter postESNotification:notification1];
	[notificationCenter postESNotification:notification2];
}

@end
