//
//  Global.h
//  YepNoo
//
//  Created by ellisa on 3/17/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

+ (void)setCircleView : (UIView *)view borderColor:(UIColor *)color;
+ (void)setRoundView : (UIView *)view cornorRadius:(float)radian   borderColor:(UIColor *)color borderWidth:(float)border;

+ (void)showAlertTips:(NSString *)_message;
+ (CGSize)getBoundingOfString:(NSString *)text width:(float)_width;
@end
