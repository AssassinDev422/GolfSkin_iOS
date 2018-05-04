//
//  SocialManager.m
//  YepNoo
//
//  Created by ellisa on 3/8/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import "SocialManager.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

#import "SocialUser.h"
#import "SocialFeed.h"
#import "SocialNotification.h"



//Defines

//Web Services


//local
//#define API_BASE_URL                @"http://10.0.1.139:9800/api/"
//#define API_BASE_URL                  @"http://admin.fahietechnologies.com/api/"
#define API_BASE_URL                  @"http://admin.getdrool.co/api/"


//Sign In Action

#define API_SIGNIN                                  @"login"
#define API_SOCIALSIGNIN                            @"sclogin"
#define API_TWITTERSIGNIN                           @"twitterlogin"
#define API_REGISTER                                @"register"
#define API_NEARBYSEARCH                            @"nearbysearch"
#define API_SIGNUP                                  @"signup"
#define API_LOGOUT                                  @"logout"
#define API_UPDATE_PROFILE                          @"update-profile"
#define API_FORGOTPASSWORD                          @"forgotpassword"
#define API_GETPLACEDETAIL                          @"placedetailinfo"
#define API_GETPROVIDERDETAIL                       @"get-provider-info"
#define API_GETSERVICELIST                          @"getservice"
#define API_ADDAPPOINTMENT                          @"addappointment"
#define API_ADDSELFAPPOINTMENT                      @"add-self-appointment"
#define API_GET_PET                                 @"getpet"
#define API_GETALLAPPOINTMENTS                      @"get-all-appointments-owner"
#define API_GETALLAPPOINTMENTFROMPROVIDER           @"get-all-appointments-provider"

//Facebook  Sing In Action

#define API_FB_SIGNIN                               @"loginwithfacebook"
#define API_FB_SIGNUP                               @""


#define API_GET_THEMES                              @"get-all-themes"
#define API_GET_CATEGORIES                          @"get-all-categories"
#define API_GET_PRODUCTS_BYCATEGORIES               @"get-products-bycategory"
#define API_GET_PRODUCT_DETAIL_INFO                 @"get-product-detail-info"
#define API_ADD_WISHLIST                            @"add-wishlist"
#define API_DELETE_WISHLIST                         @"delete-wishlist"
#define API_GET_ALL_WISHLIST                        @"get-all-wishlist"

#define API_ADD_TO_CART                             @"add-cart"
#define API_GET_ALL_CART                            @"get-all-cart"
#define API_UPDATE_CART                             @"update-cart"
#define API_ADD_COMMENT                             @"add-comment"
#define API_GET_ALL_COMMENT                         @"get-all-comment"
#define API_CHARGE                                  @"charge"


#define API_GET_SECURITYQUESTION    @"get-securities-groups"

//Profile

#define API_GETPROFILE              @"getprofile"
#define API_SETPROFILE              @"putprofile"
#define API_UPLOADPROFILE           @"uploadprofile"
#define API_SETPASSWORD             @"changepassword"
#define API_SETPRIVATEPHOTOS        @""
#define API_CHANGECOVER             @"change_backphoto"


//Follow

#define API_FOLLOWADD               @"addfollowing"
#define API_FOLLOWREMOVE            @"removefollowing"
#define API_FOLLOWERS               @"getfollowers"
#define API_FOLLOWINGS              @"getfollowings"


//Post
#define API_IMAGEPOST               @"addpost"
#define API_REMOVEPOST              @"removepost"


//Feed

#define API_GETFEED                 @"getfeed"
#define API_ADDLIKE                 @"addlike"
#define API_UNLIKE                  @"removelike"

#define API_LIKES                   @"getlikers"
#define API_MYLIKES                 @"get_likedfeed"

#define API_COMMENTS                @"getcomment"

#define API_ADDCOMMENT              @"addcomment"

//Get Photo

#define API_GETPHOTO                @"getuserpost"
#define API_GETPOPULAR              @"getpopular"
#define API_SEARCHIMAGE             @"getsearchcand"



//Notifications

#define API_NOTIFICATION            @"getnotification"
#define API_GETBADGE                @"getbadge"

//Request   Release

#define API_RELEASE                 @"requestforimage"
#define API_ANSWERTOREQUEST         @"answerforrequest"


//Get All ACCOUNTS
#define API_GETALLACCOUNTS          @"getallusers"



@interface SocialManager()<CLLocationManagerDelegate>

- (void)sendToService : (NSDictionary *) _params
              success : (void (^) (id _responseObject)) _success
              failure : (void (^) (NSError *_error)) _failure
               suffix : (NSString *)_suffix;

- (void)sendToService : (NSDictionary *) _params
                photo : (NSData *) _photo
              success : (void (^) (id))_success
              failure : (void (^) (NSError *))_failure
               suffix : (NSString *)_suffix;

@end

@implementation SocialManager

@synthesize me;
@synthesize location;
@synthesize locationManager;
@synthesize tokenid;
@synthesize filename;
@synthesize extension;

#pragma mark - Shared Functions

+ (SocialManager *)sharedManager
{
    __strong static SocialManager *sharedObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedObject = [[SocialManager alloc] init];
        
    });
    
    return sharedObject;
    
}

+ (NSString *)contentTypeForImageData:(NSData *)data
{
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
            break;
        case 0x4D:
            return @"image/tiff";
            break;
            
        default:
            break;
    }
    return nil;
}

- (id)init
{
    if (self = [super init])
    {
        
        //        CLLocationManager *manager = [[CLLocationManager alloc] init];
        //
        //        [manager setDelegate:self];
        //        [manager setDesiredAccuracy:kCLLocationAccuracyBest];
        //        [manager startUpdatingLocation];
        //
        //        [self setLocation:nil];
        //        [self setLocationManager:manager];
        //
        tokenid = @"19d2dd0f933588dbedb7c9462ed945ac30bebb7c47017f314cb2c735c70a79f1";
    }
    
    return self;
}


#pragma mark - Location Delegate

- (void)locationManager: (CLLocationManager *)_manager didupdateLocation:(CLLocation *) _newLocation fromLocation:(CLLocation *)_oldLocation
{
    self.location = _newLocation;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Invalid  Position");
}

#pragma mark - Web Service

- (void)sendToService:(NSDictionary *)_params
              success:(void (^)(id))_success
              failure:(void (^)(NSError *))_failure
               suffix:(NSString *)_suffix
{
    NSURL     *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_BASE_URL,_suffix]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:nil parameters:_params];
    
    AFHTTPRequestOperation  *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *_operation, id _responseObject){
        
        NSString *string = [[NSString alloc] initWithData:_responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
        
        //Response Object
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:_responseObject
                                                            options:kNilOptions
                                                              error:nil];
        
        //Success
        
        if (_success)
        {
            _success(responseObject);
        }
        
    }failure:^(AFHTTPRequestOperation *_operation, NSError *_error) {
        NSLog(@"%@",_error.description);
        //Failure
        
        if (_failure)
        {
            _failure(_error);
        }
    }];
    
    [operation start];
    
}

- (void)sendToService:(NSDictionary *)_params
                photo:(NSData *)_photo
              success:(void (^)(id))_success
              failure:(void (^)(NSError *))_failure
               suffix:(NSString *)_suffix
{
    
    NSURL     *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_BASE_URL,_suffix]];
    AFHTTPClient  *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    //    NSLog(@"%@----%@",filename,extension);
    
    NSString *fileType  = [[NSString alloc] init];
    
    if ([extension isEqualToString:@"JPG"])
    {
        fileType = @"jpeg";
    }
    else
    {
        fileType = @"png";
    }
    
    NSMutableURLRequest   *request = [client multipartFormRequestWithMethod:@"POST"
                                                                       path:nil
                                                                 parameters:_params
                                                  constructingBodyWithBlock:^(id<AFMultipartFormData> _formData) {
                                                      if (_photo)
                                                      {
                                                          [_formData appendPartWithFileData:_photo
                                                                                       name:@"photo"
                                                                                   fileName:@"post.jpeg"
                                                                                   mimeType:@"image/jpeg"];
                                                      }
                                                  }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *_operation, id _responseObject) {
        
        NSString *str = [[NSString alloc] initWithData:_responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        
        //Response Object
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:_responseObject
                                                            options:kNilOptions
                                                              error:nil];
        //success
        
        if (_success)
        {
            _success(responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *_operation, NSError *_error) {
        NSLog(@"%@",_error.description);
        
        //Failure
        if (_failure)
        {
            _failure(_error);
        }
        
    }];
    
    [operation start];
}




#pragma sign in
- (void)SignIn : (NSString *)_username
      password : (NSString *)_password
     successed : (void (^)(id))_success
       failure : (void (^)(NSError *))_failure
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_username forKey:@"username"];
    [params setObject:_password forKey:@"password"];
    [params setObject:tokenid forKey:@"io_token"];
    [params setObject:@"" forKey:@"android_token"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_SIGNIN];
}

- (void)SignInWithSocial : (NSString *)_email
        fbtoken: (NSString*) _fbtoken
     successed : (void (^)(id))_success
       failure : (void (^)(NSError *))_failure
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_email forKey:@"email"];
    [params setObject:_fbtoken forKey:@"fb_token"];
    [params setObject:tokenid forKey:@"io_token"];
    [params setObject:@"" forKey:@"android_token"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_SOCIALSIGNIN];
}

- (void)SignInWithTwitter : (NSString *)_username
                  fbtoken: (NSString*) _fbtoken
               successed : (void (^)(id))_success
                 failure : (void (^)(NSError *))_failure
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_username forKey:@"username"];
    [params setObject:_fbtoken forKey:@"fb_token"];
    [params setObject:tokenid forKey:@"io_token"];
    [params setObject:@"" forKey:@"android_token"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_TWITTERSIGNIN];
}


- (void)Register : (NSString*)_email
         username: (NSString*)_username
         password: (NSString*)_password
       successed : (void (^)(id))_success
         failure : (void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_email forKey:@"email"];
    [params setObject:_username forKey:@"username"];
    [params setObject:_password forKey:@"password"];
    [params setObject:tokenid forKey:@"io_token"];
    [params setObject:@"" forKey:@"android_token"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_REGISTER];
}


- (void)SignUp : (NSString *)_username
         email : (NSString *)_email
      password : (NSString *)_password
     successed : (void (^)(id))_success
       failure : (void (^)(NSError *))_failure
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_email forKey:@"email"];
    [params setObject:_username forKey:@"username"];
    [params setObject:_password forKey:@"password"];
    [params setObject:tokenid forKey:@"devtoken"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_SIGNUP];
}


- (void)SignUp:(NSData *)_avatar
      username:(NSString *)_username
      password:(NSString *)_password
         email:(NSString *)_email
     successed:(void (^)(id))_success
       failure:(void (^)(NSError *))_failure
{
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
 
    [params setObject:_username forKey:@"username"];
    [params setObject:_email forKey:@"email"];
    [params setObject:_password forKey:@"password"];
    [params setObject:tokenid forKey:@"devtoken"];
    
    
    [self sendToService:params
                  photo:_avatar
                success:_success
                failure:_failure
                 suffix:API_SIGNUP];
}

- (void)LogOut : (NSString *)_userId
     authtoken : (NSString *)_authtoken
     successed : (void (^)(id))_success
       failure : (void (^)(NSError *))_failure
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_userId forKey:@"self_id"];
    [params setObject:_authtoken forKey:@"authtoken"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_LOGOUT];
}

-(void)ForgotPassword:(NSString*)_email
            successed:(void (^)(id))_success
              failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_email forKey:@"email"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_FORGOTPASSWORD];
}

- (void)FBSignIn:(NSString *)_fbID
       successed:(void (^)(id))_success
         failure:(void (^)(NSError *))_failure
{
    
}

- (void)FBSignUp:(NSString *)_username
          avatar:(NSString *)_avatar
           email:(NSString *)_email
            fbID:(NSString *)_fbID
       successed:(void (^)(id))_success
         failure:(void (^)(NSError *))_failure
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_username forKey:@"username"];
    [params setObject:_email forKey:@"email"];
    [params setObject:_fbID forKey:@"facebookid"];
    [params setObject:tokenid forKey:@"devtoken"];
    [params setObject:_avatar forKey:@"photo"];
    
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_FB_SIGNIN];
}

- (void)UpdateProfile:(NSData *)_avatar
               userid:(NSString *)_userid
             fullname:(NSString *)_fullname
             username:(NSString *)_username
                email:(NSString *)_email
                birth:(NSString *)_birth
            successed:(void (^)(id))_success
              failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_userid forKey:@"userid"];
    [params setObject:_fullname forKey:@"name"];
    [params setObject:_username forKey:@"username"];
    [params setObject:_email forKey:@"email"];
    [params setObject:_birth forKey:@"birth"];
    
    
    [self sendToService:params
                  photo:_avatar
                success:_success
                failure:_failure
                 suffix:API_UPDATE_PROFILE];
}

-(void)GetThemes:(NSString*) _id
                 successed:(void (^)(id))_success
                   failure:(void (^)(NSError *))_failure
{
    [self sendToService:nil
                success:_success
                failure:_failure
                 suffix:API_GET_THEMES];
    
}

-(void)GetCategories:(NSString*) _id
       successed:(void (^)(id))_success
         failure:(void (^)(NSError *))_failure
{
    [self sendToService:nil
                success:_success
                failure:_failure
                 suffix:API_GET_CATEGORIES];
    
}

-(void)GetProductsByCategory:(NSString *)_id
           successed:(void (^)(id))_success
             failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setObject:_id forKey:@"category_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GET_PRODUCTS_BYCATEGORIES];
    
}

-(void)GetProductDetailInfo:(NSString *)_id
                     userid:(NSString *)_userid
                  successed:(void (^)(id))_success
                    failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_userid forKey:@"userid"];
    [params setObject:_id forKey:@"product_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GET_PRODUCT_DETAIL_INFO];
    
}

- (void) AddWishlist:(NSString *)_id
              userid:(NSString *)_userid
           successed:(void (^)(id))_success
             failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_id forKey:@"product_id"];
    [params setObject:_userid forKey:@"userid"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_ADD_WISHLIST];
    
}

- (void) DeleteWishlist:(NSString *)_id
              successed:(void (^)(id))_success
                failure:(void (^)(NSError *))_failure

{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_id forKey:@"wishlist_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_DELETE_WISHLIST];
}

- (void) GetAllWishlist:(NSString *)_id
              successed:(void (^)(id))_success
                failure:(void (^)(NSError *))_failure

{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_id forKey:@"userid"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GET_ALL_WISHLIST];
}

- (void) AddToCart:(NSString *)_id
            userid:(NSString *)_userid
             color:(NSString *)_color
              size:(NSString *)_size
         successed:(void (^)(id))_success
           failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_id forKey:@"product_id"];
    [params setObject:_userid forKey:@"userid"];
    [params setObject:_color forKey:@"color"];
    [params setObject:_size forKey:@"size"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_ADD_TO_CART];
    
}

- (void) GetAllCart:(NSString *)_id
              successed:(void (^)(id))_success
                failure:(void (^)(NSError *))_failure

{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_id forKey:@"userid"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GET_ALL_CART];
}

- (void) UpdateCart:(NSString *)_id
           cartinfo:(NSString *)_cartinfo
          successed:(void (^)(id))_success
            failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_id forKey:@"userid"];
    [params setObject:_cartinfo forKey:@"cartinfo"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_UPDATE_CART];
    
}

- (void) AddComment:(NSString *)_userid
          productid:(NSString *)_productid
            content:(NSString *)_content
          successed:(void (^)(id))_success
            failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_userid forKey:@"userid"];
    [params setObject:_productid forKey:@"product_id"];
    [params setObject:_content forKey:@"content"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_ADD_COMMENT];
    
}

- (void) GetAllComment:(NSString *)_productid
             successed:(void (^)(id))_success
               failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_productid forKey:@"product_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GET_ALL_COMMENT];
    
}


- (void) chargeWithToken:(NSString *)_userid
                   token:(NSString *)_token
                  amount:(NSString *)_amount
                fullname:(NSString *)_fullname
                  street:(NSString *)_street
                 country:(NSString *)_country
                 zipcode:(NSString *)_zipcode
                   phone:(NSString *)_phone
               successed:(void (^)(id))_success
                 failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_userid forKey:@"userid"];
    [params setObject:_token forKey:@"token"];
    [params setObject:_amount forKey:@"amount"];
    [params setObject:_fullname forKey:@"fullname"];
    [params setObject:_street forKey:@"street"];
    [params setObject:_country forKey:@"country"];
    [params setObject:_zipcode forKey:@"zipcode"];
    [params setObject:_phone forKey:@"phone"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_CHARGE];
    
}




- (void)SearchNearbyUser : (NSString*)_latitude
                longitude: (NSString*)_longitude
              search_text: (NSString*)_searchText
                successed: (void (^)(id))_success
                 failure : (void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_latitude forKey:@"lat"];
    [params setObject:_longitude forKey:@"lng"];
    [params setObject:_searchText forKey:@"search_text"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_NEARBYSEARCH];
}

- (void)GetPlaceDetailInfo : (NSString*) _placeId
                successed : (void (^)(id))_success
                 failure : (void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_placeId forKey:@"place_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GETPLACEDETAIL];
}

- (void)GetProviderDetailInfo : (NSString*) _providerId
                 successed : (void (^)(id))_success
                   failure : (void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_providerId forKey:@"provider_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GETPROVIDERDETAIL];
}

-(void)GetMyPets:(NSString*) self_id
                 successed:(void (^)(id))_success
                   failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   [params setObject:self_id forKey:@"owner_id"];

    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GET_PET];
    
}

- (void)GetServices : (NSString*) _group_id
                 successed : (void (^)(id))_success
                   failure : (void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_group_id forKey:@"group_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GETSERVICELIST];
}

- (void)GetAllAppointmentFromProvider : (NSString*) _provider_id
                            successed : (void (^)(id))_success
                              failure : (void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_provider_id forKey:@"provider_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GETALLAPPOINTMENTFROMPROVIDER];
}


- (void)GetAllAppointments : (NSString*) _owner_id
                 successed : (void (^)(id))_success
                   failure : (void (^)(NSError *))_failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_owner_id forKey:@"owner_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GETALLAPPOINTMENTS];

}


- (void) AddAppointment:(NSString*) _petId
                                  provider_id:_providerId
                                         date:_date
                                         time:_time
                                      address:_address
                                      ranking:_ranknum
                                   service_id:_serviceId
                                         note:_note
                                    successed:_success
                                      failure:_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_petId forKey:@"pet_id"];
    [params setObject:_providerId forKey:@"provider_id"];
    [params setObject:_date forKey:@"date"];
    [params setObject:_time forKey:@"time"];
    [params setObject:_address forKey:@"address"];
    [params setObject:_ranknum forKey:@"ranking"];
    [params setObject:_serviceId forKey:@"service_id"];
    [params setObject:_note forKey:@"note"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_ADDAPPOINTMENT];
 
}

- (void) AddSelfAppointment:(NSString*) _petId
                   date:_date
                   time:_time
                  title:_title
                   note:_note
              successed:_success
                failure:_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_petId forKey:@"pet_id"];
    [params setObject:_date forKey:@"date"];
    [params setObject:_time forKey:@"time"];
    [params setObject:_title forKey:@"title"];
    [params setObject:_note forKey:@"note"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_ADDSELFAPPOINTMENT];
    
}

#pragma mark- GetPhoto

- (void)GetPhotos:(NSString *)_otherid
        successed:(void (^)(id))_success
          failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:_otherid forKey:@"user_id"];
    
    [self sendToService:params success:_success failure:_failure suffix:API_GETPHOTO];
}


- (void)GEtPopular:(void (^)(id))_success
           failure:(void (^)(id))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GETPOPULAR];
}

- (void)searchImage:(NSString *)tagText
          successed:(void (^)(id))_success
            failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:tagText forKey:@"search"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_SEARCHIMAGE];
    
}
#pragma mark- GetSecurityQuestion
-(void)GetSecurityQuestion:(NSString*) _id
                 successed:(void (^)(id))_success
                   failure:(void (^)(NSError *))_failure
{
    [self sendToService:nil
                success:_success
                failure:_failure
                 suffix:API_GET_SECURITYQUESTION];

}

#pragma mark- Profile

-(void)GetProfile:(NSString *)_authToken
            my_id:(NSString *)_myid
         other_id:(NSString *)_otherid
        successed:(void (^)(id))_success
          failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_authToken forKey:@"authtoken"];
    
    [params setObject:_myid forKey:@"self_id"];
    [params setObject:_otherid forKey:@"user_id"];
    
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GETPROFILE];
}

-(void)UploadProfile:(NSData *)_avatar
         username:(NSString *)_username
            email:(NSString *)_email
        successed:(void (^)(id))_success
          failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:_username forKey:@"username"];
    [params setObject:_email forKey:@"email"];
    
    [self sendToService:params photo:_avatar success:_success failure:_failure suffix:API_UPLOADPROFILE];
}


-(void)SetProfile:(NSData *)_avatar
         username:(NSString *)_username
             name:(NSString *)_name
          website:(NSString *)_website
              bio:(NSString *)_bio
            email:(NSString *)_email
            phone:(NSString *)_phone
           gender:(NSString *)_gender
        successed:(void (^)(id))_success
          failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:_username forKey:@"username"];
    [params setObject:_name forKey:@"fullname"];
    [params setObject:_gender forKey:@"gender"];
    [params setObject:_email forKey:@"email"];
    [params setObject:_website forKey:@"website"];
    [params setObject:_phone forKey:@"phone"];
    [params setObject:_bio forKey:@"bio"];
    
    [self sendToService:params photo:_avatar success:_success failure:_failure suffix:API_SETPROFILE];
}

- (void)SetPassword:(NSString *)_oldPassword
        newPassword:(NSString *)_newPassword
          successed:(void (^)(id))_success
            failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.authToken forKey:@"authtoken"];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:_oldPassword forKey:@"curpassword"];
    [params setObject:_newPassword forKey:@"newpassword"];
    
    [self sendToService:params success:_success failure:_failure suffix:API_SETPASSWORD];
    
}


- (void)SetAvatar:(NSData *)_avatar
//       coverPhoto:(NSData *)_coverPhoto
        successed:(void (^)(id))_success
          failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:me.username forKey:@"username"];
    [params setObject:me.name forKey:@"fullname"];
    [params setObject:me.gender forKey:@"gender"];
    [params setObject:me.email forKey:@"email"];
    [params setObject:me.website forKey:@"website"];
    [params setObject:me.phone forKey:@"phone"];
    [params setObject:me.bio forKey:@"bio"];
    
    [self sendToService:params photo:_avatar success:_success failure:_failure suffix:API_SETPROFILE];
    
}

- (void)changeCoverPhoto:(NSData *)_coverPhoto
               successed:(void (^)(id))_success
                 failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:me.userid forKey:@"self_id"];
    [self sendToService:params photo:_coverPhoto
                success:_success
                failure:_failure
                 suffix:API_CHANGECOVER];
}

//Feed page

-  (void)FeedAdd : (NSData *)_photo
             name: (NSString *)_name
             tag : (NSString *)_tag
            width:(NSInteger)_width
           height:(NSInteger)_height
         yepOrnoo:(NSInteger)_yepOrnoo
       successed : (void (^) (id _responseObject))_success
         failure : (void (^) (NSError *_error))_failure
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_name forKey:@"title"];
    [params setObject:_tag forKey:@"description"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:[NSNumber numberWithInteger:_width] forKey:@"width"];
    [params setObject:[NSNumber numberWithInteger:_height] forKey:@"height"];
    [params setObject:[NSNumber numberWithInteger:_yepOrnoo] forKey:@"yep_noo"];
    
    //    NSLog(@"%@",me.authToken);
    
    [self sendToService:params
                  photo:_photo
                success:_success
                failure:_failure
                 suffix:API_IMAGEPOST];
}

- (void)FeedRemove : (NSString *)_postid
         successed : (void (^)(id _responseObject))_success
           failure : (void (^)(NSError *_error))_failure;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:_postid forKey:@"post_id"];
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_REMOVEPOST];
}

- (void)Feeds : (SocialUser *)_user
    successed : (void (^) (id _responseObject))_success
      failure : (void (^) (NSError *_error))_failure
{
    
}

- (void)FeedFollows : (void(^)(id _responseObject))_success
            failure : (void(^) (NSError *_error))_failure
{
    
    
}

- (void)FeedNews : (void(^)(id _responseObject))_success
         failure : (void(^)(NSError *_error))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:me.userid forKey:@"self_id"];
    //    NSLog(@"%@",me.userid);
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GETFEED];
    
}

- (void)FeedTag : (NSString *)tag
      successed : (void (^)(id _responseObject))_success
        failure : (void (^)(NSError *_error))_failure
{
    
}

//Like

- (void)LikeAdd : (SocialFeed *)_feed
      successed : (void (^) (id _responseObject)) _success
        failure : (void (^) (NSError *_error))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:_feed.postid forKey:@"post_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_ADDLIKE];
}

- (void)LikeRemove : (SocialFeed *)_feed
         successed : (void (^) (id _responseObject))_success
           failure : (void (^) (NSError *_error))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:_feed.postid forKey:@"post_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_UNLIKE];
    
}

- (void)Likes : (SocialFeed *)_feed
    successed : (void (^) (id _responseObject))_success
      failure : (void (^) (NSError *_error))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:_feed.postid forKey:@"post_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_LIKES];
    
}

- (void)myLikes:(void (^)(id))_success
        failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_MYLIKES];
    
}

//Comment
- (void)CommentAdd : (SocialFeed *)_feed
           comment : (NSString *)_comment
         successed : (void (^) (id _responseObject))_success
           failure : (void (^) (NSError *_error))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:_feed.postid forKey:@"post_id"];
    [params setObject:_comment forKey:@"description"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_ADDCOMMENT];
    
}

- (void)CommentRemove : (NSString *)_commentid
            successed : (void (^)(id _responseObject))_success
              failure : (void (^) (NSError * _error)) _failure
{
    
}

- (void)Comments : (SocialFeed *)_feed
       successed : (void (^) (id _responseObject))_success
         failure : (void (^) (NSError *_error))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:_feed.postid forKey:@"post_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_COMMENTS];
}

//Follow
- (void)AddFollow:(NSString *)userid
        successed:(void (^)(id))_success
          failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:userid forKey:@"touser_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_FOLLOWADD];
}

- (void)FollowingRemove:(NSString *)userid
              successed:(void (^)(id))_success
                failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:userid forKey:@"touser_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_FOLLOWREMOVE];
}

- (void)Followers:(NSString *)userid
        successed:(void (^)(id))_success
          failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:userid forKey:@"user_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_FOLLOWERS];
    
}

- (void)Followings:(NSString *)userid
         successed:(void (^)(id))_success
           failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:userid forKey:@"user_id"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_FOLLOWINGS];
    
}
#pragma mark  Notifications
- (void)Notifications:(NSString *)_is_new
            successed:(void (^)(id))_success
              failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:_is_new forKey:@"is_new"];
    
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_NOTIFICATION];
    
}

- (void)RequestRelease:(NSString *)_postid
             successed:(void (^)(id))_success
               failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:_postid forKey:@"post_id"];
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_RELEASE];
}

- (void)GetBadge:(void (^)(id))_success
         failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:me.userid forKey:@"self_id"];
    //    NSLog(@"%@",me.userid);
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GETBADGE];
    
}

- (void)answerForRequest:(SocialNotification *)_notification
             releaseType:(NSString *)yepOrnoo
               successed:(void (^)(id))_success
                 failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:me.userid forKey:@"self_id"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)_notification.postid] forKey:@"post_id"];
    [params setObject:_notification.userid forKey:@"user_id"];
    [params setObject:yepOrnoo forKey:@"yep_noo"];
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_ANSWERTOREQUEST];
    
}

- (void) GetAllUsers:(void (^)(id))_success
             failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:me.authToken forKey:@"authtoken"];
    [params setObject:me.userid forKey:@"self_id"];
    //    NSLog(@"%@",me.userid);
    [self sendToService:params
                success:_success
                failure:_failure
                 suffix:API_GETALLACCOUNTS];
}

@end
