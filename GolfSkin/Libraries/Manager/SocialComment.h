//
//  SocialComment.h
//  YepNoo
//
//  Created by ellisa on 3/11/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialUser.h"

@interface SocialComment : SocialUser

@property (nonatomic, retain) NSString *commentid;
@property (nonatomic, retain) NSString *comment_contents;
@property (nonatomic, retain) NSString *date;
@property (nonatomic) BOOL sending;

+ (id)comments:(NSArray *)_array;
- (id)initWithDict:(NSDictionary *)_dict;

@end
