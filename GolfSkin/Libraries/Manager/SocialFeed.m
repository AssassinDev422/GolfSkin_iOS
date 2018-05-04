//
//  SocialFeed.m
//  YepNoo
//
//  Created by ellisa on 3/10/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import "SocialFeed.h"

@implementation SocialFeed

@synthesize postid;
@synthesize photo_path;
@synthesize name;
@synthesize likes;
@synthesize liked;
@synthesize commentArray;
@synthesize comments;
@synthesize date;


- (id)initWithDict:(NSDictionary *)_dict
{
    if (self = [super init])
    {
        
        [self setPostid:[_dict objectForKey:@"post_id"]];
        [self setUserid:[_dict objectForKey:@"user_id"]];
        [self setUsername:[_dict objectForKey:@"username"]];
        [self setAvatar:[_dict objectForKey:@"user_photo"]];
        [self setPhoto_path:[_dict objectForKey:@"post_photo"]];
//        [self setName:[_dict objectForKey:@"post_id"]];
        [self setLikes:[[_dict objectForKey:@"like_count"] intValue]];
        [self setLiked:[[_dict objectForKey:@"mylike"]boolValue]];
        [self setComments:[[_dict objectForKey:@"comment_count"]intValue]];
//        [self setUserBio:[_dict objectForKey:@"post_id"]];
        [self setDate:[[_dict objectForKey:@"post_date"] intValue]];
        [self setCommentArray:[SocialComment comments:[_dict objectForKey:@"comment"]]];
        [self setYepOrnoo:[[_dict objectForKey:@"yep_noo"] boolValue]];
        [self setTitle:[_dict objectForKey:@"title"]];
        [self setDescriptions:[_dict objectForKey:@"description"]];
        [self setWidth:[[_dict objectForKey:@"width"] intValue]];
        [self setHeight:[[_dict objectForKey:@"height"] intValue]];
        [self setMy_yepnoo:[[_dict objectForKey:@"my_yep_noo"] intValue]];
    }
    
    return self;
}

- (void)dealloc
{
    [self setPostid:Nil];
    [self setUserid:nil];
    [self setUsername:nil];
    [self setAvatar:nil];
    [self setPhoto_path:nil];
    [self setName:nil];
}
@end
