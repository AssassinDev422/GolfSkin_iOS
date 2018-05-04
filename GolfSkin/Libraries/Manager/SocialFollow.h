//
//  SocialFollow.h
//  YepNoo
//
//  Created by ellisa on 3/11/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialUser.h"

@interface SocialFollow : SocialUser

@property (nonatomic) BOOL following;

- (id)initWithDict:(NSDictionary *)_dict;

@end
