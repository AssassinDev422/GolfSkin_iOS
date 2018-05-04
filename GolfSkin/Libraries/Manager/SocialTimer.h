//
//  SocialTimer.h
//  YepNoo
//
//  Created by ellisa on 3/11/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialTimer : NSObject

+ (NSString *)timeElapsed : (NSInteger) _seconds;
+ ( NSString* ) timeElapsedNotification : ( NSInteger ) _seconds ;

@end
