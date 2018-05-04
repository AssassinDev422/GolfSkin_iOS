//  AppController.h
//  Created by BE

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppController : NSObject

@property (nonatomic, strong) NSMutableArray *selected_users;
@property (nonatomic, strong) NSMutableArray *arrPhoneContacts;
@property (nonatomic, strong) NSMutableArray *arrAllUsers;
@property (nonatomic, strong) NSMutableArray *arrContacts;

@property (nonatomic, strong) NSMutableDictionary *dicUserInfo;
@property (nonatomic, strong) NSMutableDictionary *selectedCategory;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, assign) NSUInteger viewPagerIndex;

// Utility Variables
@property (nonatomic, strong) UIColor *appMainColor, *appTextColor, *appThirdColor;

@property(nonatomic,strong) UIImage* attachImage;

@property(nonatomic,strong) NSString* deviceToken;
@property(nonatomic,strong) NSString* strUserId;
@property(nonatomic,strong) NSString* strToken;

@property(nonatomic,strong) NSDictionary* dicSelectedEvent;
@property(nonatomic,strong) NSDictionary* dicSelectedEventType;
@property(nonatomic,strong) NSDictionary* dicSelectedDrafter;
@property(nonatomic,strong) NSDictionary* dicSelectedMoreInfo;

@property(nonatomic,assign) NSInteger attach_type;



+ (AppController *)sharedInstance;

- (void)initBaseData;

@end
