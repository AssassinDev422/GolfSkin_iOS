//
//  SocialUserProfile.m
//  YepNoo
//
//  Created by ellisa on 3/11/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import "SocialUserProfile.h"

@implementation SocialUserProfile


@synthesize website;
@synthesize bio;
@synthesize phone;
@synthesize sex;
@synthesize photos;
@synthesize followers;
@synthesize followings;
@synthesize following;
@synthesize yep_count;
@synthesize noo_count;
+ (id)me
{
    __strong static SocialUserProfile *sharedObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
       
        sharedObject = [[SocialUserProfile alloc] init];
        
    });
    
    return sharedObject;
}

- (id)initWithDict:(NSDictionary *)_dict
{
    if (self = [super init])
    {
        [self setUserid:[_dict objectForKey:@"user_id"]];
        [self setUsername:[_dict objectForKey:@"username"]];
        [ self setName : [ _dict objectForKey : @"fullname" ] ] ;
        [ self setAvatar : [ _dict objectForKey : @"photo" ] ] ;
        [self setCoverPhoto:[_dict objectForKey:@"backphoto"]];
        [ self setWebsite : [ _dict objectForKey : @"website" ] ] ;
        [ self setBio : [ _dict objectForKey : @"bio" ] ] ;
        [ self setEmail : [ _dict objectForKey : @"email" ] ] ;
        [ self setPhone : [ _dict objectForKey : @"phone" ] ] ;
        [ self setSex : [ _dict objectForKey : @"gender" ] ] ;
        [ self setPhotos : [ [ _dict objectForKey :  @"post_count" ] intValue ] ] ;
        [ self setFollowers : [ [ _dict objectForKey : @"follower_count" ] intValue ] ] ;
        [ self setFollowings : [ [ _dict objectForKey : @"following_count" ] intValue ] ] ;
        [ self setFollowing : [ [ _dict objectForKey : @"is_following" ] boolValue ] ] ;
        [self setYep_count:[[_dict objectForKey:@"yep_count"]intValue]];
        [self setNoo_count:[[_dict objectForKey:@"noo_count"]intValue]];
//        [ self setPhotoPrivate : [ [ _dict objectForKey : @"user_photo_private" ] boolValue ] ] ;
    }
    
    return self ;
}

- ( void ) dealloc
{
    // Release ;
    [ self setName : nil ] ;
    [ self setWebsite : nil ] ;
    [ self setBio : nil ] ;
    [ self setEmail : nil ] ;
    [ self setPhone : nil ] ;
    [ self setSex : nil ] ;
    
}
@end
