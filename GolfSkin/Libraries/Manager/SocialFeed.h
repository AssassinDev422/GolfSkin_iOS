//
//  SocialFeed.h
//  YepNoo
//
//  Created by ellisa on 3/10/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialUser.h"
#import "SocialManager.h"
#import "SocialComment.h"

@interface SocialFeed : SocialUser

@property (nonatomic, retain) NSString *postid;
@property (nonatomic, retain) NSString *photo_path;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) NSInteger likes;
@property (nonatomic) BOOL liked;
@property (nonatomic) NSInteger comments;
@property (nonatomic) NSInteger date;
@property (nonatomic, retain)NSMutableArray *commentArray;
@property (nonatomic,retain)NSString *userBio;
@property (nonatomic, retain)NSString *title;
@property (nonatomic, retain)NSString *descriptions;
@property (nonatomic) BOOL yepOrnoo;
@property (nonatomic) NSInteger my_yepnoo;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;

- (id)initWithDict:(NSDictionary *) _dict;

@end
