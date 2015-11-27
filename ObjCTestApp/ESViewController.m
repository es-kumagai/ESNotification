//
//  ViewController.m
//  ObjCTestApp
//
//  Created by Tomohiro Kumagai on H27/08/17.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

#import "ESViewController.h"
#import "ObjCTestApp-Swift.h"

@implementation ESViewController

- (void)viewWillAppear
{
	[super viewWillAppear];
	
	NSLog(@"Start observing %@", [MyNativeNotification class]);
	
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];

	[nc addObserver:self selector:@selector(myNativeNotificationReceived:) ESNotification:[MyNativeNotification class] object:nil];
}

- (void)viewDidDisappear
{
	[super viewDidDisappear];
	
	NSLog(@"Stop observing %@", [MyNativeNotification class]);
	
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	
	[nc removeObserver:self];
}

- (void)myNativeNotificationReceived:(NSNotification*)note
{
	NSLog(@"Notification Received : %@", note);
	
	MyNativeNotification* nativeNotification = note.object;
	
	NSLog(@"My Value of Native Notification = %@", @(nativeNotification.myValue));
}

- (IBAction)postNotification:(NSButton*)sender
{
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	MyNativeNotification* note = [[MyNativeNotification alloc] initWithMyValue:100];
	NSLog(@"Post : %@", note);

	[nc postESNotification:note];
}

@end
