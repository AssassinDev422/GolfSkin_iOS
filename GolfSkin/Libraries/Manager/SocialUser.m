//
//  SocialUser.m
//  YepNoo
//
//  Created by ellisa on 3/10/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import "SocialUser.h"

@implementation SocialUser

@synthesize authToken;
@synthesize userid;
@synthesize username;
@synthesize avatar;


+ (id)me
{
    __strong static SocialUser *sharedObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        
        sharedObject = [[SocialUser alloc] init];
    });
    return sharedObject;
}

- (id)init
{
    if (self = [super init])
    {
        
       
        
    }
    return  self;

}

- (id)initWithDict:(NSDictionary *)_dict
{
    if (self = [super init])
    {
        [self setUserid:[_dict objectForKey:@"user_id"]];
        if ([_dict objectForKey:@"authToken"])
        {
            [self setAuthToken:[_dict objectForKey:@"authToken"]];

        }
        [self setUsername:[_dict objectForKey:@"username"]];
        [self setName:[_dict objectForKey:@"fullname"]];
        [self setGender:[_dict objectForKey:@"gender"]];
        [self setEmail:[_dict objectForKey:@"email"]];
        [self setAvatar:[_dict objectForKey:@"photo"]];
        [self setCoverPhoto:[_dict objectForKey:@"backphoto"]];
        [self setPhone:[_dict objectForKey:@"phone"]];
        [self setWebsite:[_dict objectForKey:@"website"]];
        [self setBio:[_dict objectForKey:@"bio"]];
        [self setBirthday:[_dict objectForKey:@"birthday"]];
        [self setAdvisor:[_dict objectForKey:@"advisor"]];
        
    }
    return  self;
}

- (void)dealloc
{
    [self setUserid:nil];
    [self setUsername:nil];
    [self setAvatar:nil];
}

@end
