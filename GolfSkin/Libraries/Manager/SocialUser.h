//
//  SocialUser.h
//  YepNoo
//
//  Created by ellisa on 3/10/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialManager.h"

@interface SocialUser : NSObject


// Properties ;

@property ( nonatomic,retain)   NSString*       authToken;
@property ( nonatomic, retain ) NSString*       userid ;
@property ( nonatomic, retain ) NSString*       username ;
@property ( nonatomic, retain ) NSString*       name ;
@property ( nonatomic, retain ) NSString*       avatar ;
@property ( nonatomic, retain) NSString *       coverPhoto;
@property ( nonatomic, retain ) NSString*       email ;
@property ( nonatomic, retain ) NSString*       phone ;
@property ( nonatomic, retain ) NSString*       website;
@property ( nonatomic, retain ) NSString*       bio;
@property ( nonatomic, retain)  NSString*       gender;
@property ( nonatomic, retain)  NSString*       birthday;
@property ( nonatomic, retain)  NSString*       advisor;


// Functions ;
+ ( id ) me ;
- ( id ) initWithDict : ( NSDictionary* ) _dict ;


@end
