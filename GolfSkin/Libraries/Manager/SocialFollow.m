//
//  SocialFollow.m
//  YepNoo
//
//  Created by ellisa on 3/11/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import "SocialFollow.h"

@implementation SocialFollow

@synthesize following;

- (id)initWithDict:(NSDictionary *)_dict
{
    if (self = [super init])
    {
        
        [self setUserid:[_dict objectForKey:@"user_id"]];
        [self setUsername:[_dict objectForKey:@"username"]];
        [self setAvatar:[_dict objectForKey:@"user_avatar"]];
        [self setFollowing:[[_dict objectForKey:@"following"]boolValue]];
        
    }
    
    return self;
}

- (void)dealloc
{
    [self setUserid:nil];
    [self setUsername:nil];
    [self setAvatar:nil];
}

@end
