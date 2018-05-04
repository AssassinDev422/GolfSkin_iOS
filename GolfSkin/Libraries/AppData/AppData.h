//
//  AppData.h
//  Dopple
//
//  Created by Mitchell Williams on 21/08/2015.
//  Copyright (c) 2015 Mitchell Williams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject

+ (AppData*) sharedData;


//User Info
@property (nonatomic, retain) NSString* strLongitude;
@property (nonatomic, retain) NSString* strLatitude;

@property (nonatomic) BOOL bPushNotification;


@property (nonatomic) int  nSelectedCategoryIdx;
@property (nonatomic) int  nSortType;
@property (nonatomic) int  nTypeGender;
@property (nonatomic) int  nSizeType;

@property (nonatomic, retain) NSMutableArray* arrServiceName;

@property (nonatomic, retain) NSString* strUserid;

@property (nonatomic) BOOL bLoggedIn;

@property (nonatomic) int  nSelectedProductId;
@property (nonatomic, retain) NSMutableArray* arrRecentImage;
@property (nonatomic, retain) NSMutableArray* arrEvent;


@property (nonatomic, retain) NSMutableDictionary* dicUserInfo;

@end
