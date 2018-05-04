//
//  SocialUserProfile.h
//  YepNoo
//
//  Created by ellisa on 3/11/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialUser.h"
@interface SocialUserProfile : SocialUser
{
    
}



@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic) NSInteger photos;
@property (nonatomic) NSInteger followers;
@property (nonatomic) NSInteger followings;
@property (nonatomic) BOOL      following;
@property (nonatomic) NSInteger yep_count;
@property (nonatomic) NSInteger noo_count;
//@property (nonatomic) BOOL      photoPrivate;

+ (id)me;
- (id)initWithDict:(NSDictionary *)_dict;


@end
