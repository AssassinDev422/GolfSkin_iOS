//
//  SocialNotification.h
//  YepNoo
//
//  Created by ellisa on 3/11/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialUser.h"
@interface SocialNotification : SocialUser
{
    
}

@property  NSInteger date;
@property  BOOL      following;
@property  NSInteger postid;
@property  NSString *requestComment;


@property NSString *notice_type;
@property NSInteger my_yepnoo;
@property NSString *photo_path;

- (id)initWithDict:(NSDictionary *)_dict;

@end
