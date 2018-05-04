//
//  SocialNotification.m
//  YepNoo
//
//  Created by ellisa on 3/11/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import "SocialNotification.h"

@implementation SocialNotification

@synthesize date;
@synthesize postid;
@synthesize following;
@synthesize requestComment;


- (id)initWithDict:(NSDictionary *)_dict
{
    if (self = [super init])
    {
        
        [self setUsername:[_dict objectForKey:@"username"]];
        [self setUserid:[_dict objectForKey:@"user_id"]];
        [self setAvatar:[_dict objectForKey:@"user_photo"]];
//        [self setFollowing:[[_dict objectForKey:@"notification_following"]boolValue]];
//        [self setDate:[[_dict objectForKey:@"notification_date"]intValue]];
        [self setPostid:[[_dict objectForKey:@"post_id"] intValue]];
//        [self setRequestComment:[_dict objectForKey:@"notification_requestComment"]];
        [self setPhoto_path:[_dict objectForKey:@"post_photo"]];
        [self setMy_yepnoo:[[_dict objectForKey:@"my_yep_noo"] intValue]];
        [self setNotice_type:[_dict objectForKey:@"notice_type"]];
    }
    
    return self;
    
}

- (void)dealloc
{
    [self setUserid:nil];
    [self setAvatar:nil];
    [self setUsername:nil];
}

@end
