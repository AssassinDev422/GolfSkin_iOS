//
//  SocialComment.m
//  YepNoo
//
//  Created by ellisa on 3/11/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import "SocialComment.h"

@implementation SocialComment

@synthesize commentid;
@synthesize comment_contents;
@synthesize date;
@synthesize sending;

+ (id)comments:(NSArray *)_array
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in _array)
    {
        SocialComment *socialComment = [[SocialComment alloc] initWithDict:dict];
        
        [array addObject:socialComment];
    }
    
    return array;
}

- (id)initWithDict:(NSDictionary *)_dict
{
    if (self = [super init])
    {
        
        [self setCommentid:[_dict objectForKey:@"comment_id"]];
        [self setUserid:[_dict objectForKey:@"user_id"]];
        [self setUsername:[_dict objectForKey:@"username"]];
        [self setAvatar:[_dict objectForKey:@"user_photo"]];
        [self setComment_contents:[_dict objectForKey:@"description"]];
        [self setDate:[_dict objectForKey:@"comment_date"]];
        [self setSending:NO];
    }
    
    return self;
}

- (void)dealloc
{
    [self setCommentid:nil];
    [self setUserid:nil];
    [self setUsername:nil];
    [self setAvatar:nil];
    [self setComment_contents:nil];
    [self setDate:nil];
//    [self setSending:NO];

}

@end
