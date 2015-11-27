//
//  ESSampleObjCNotification.h
//  ESNotification
//
//  Created by Tomohiro Kumagai on H27/11/27.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ESNotification/ESNotification-Swift.h>

@interface ESSampleObjCNotification : NSObject <ESNotification>

@property (readwrite) NSInteger objc;

@end
