//
//  SocialManager.h
//  YepNoo
//
//  Created by ellisa on 3/8/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class SocialUser;
@class SocialFeed;
@class SocialNotification;



@interface SocialManager : NSObject


@property (strong, nonatomic) SocialUser * me;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (strong, nonatomic) NSString *tokenid;

@property (strong, nonatomic) NSString *filename;
@property (strong, nonatomic) NSString *extension;


//Functions
+(SocialManager *)sharedManager;



//Get image type from NSData

+ (NSString *)contentTypeForImageData:(NSData *)data;
//Sign In

- (void)SignIn : (NSString *)_username
      password : (NSString *)_password
     successed : (void (^)(id _responseObject)) _success
       failure : (void (^)(NSError *_error))_failure;

- (void)SignInWithSocial : (NSString *)_email
                  fbtoken: (NSString*) _fbtoken
               successed : (void (^)(id))_success
                 failure : (void (^)(NSError *))_failure;

- (void)SignInWithTwitter : (NSString *)_username
                   fbtoken: (NSString*) _fbtoken
                successed : (void (^)(id))_success
                  failure : (void (^)(NSError *))_failure;

- (void)Register : (NSString*)_email
         username: (NSString*	)_username
         password: (NSString*)_password
       successed : (void (^)(id))_success
         failure : (void (^)(NSError *))_failure;

-(void)ForgotPassword:(NSString*)_email
            successed:(void (^)(id))_success
              failure:(void (^)(NSError *))_failure;


- (void)SignUp : (NSString *)_username
         email : (NSString *)_email
      password : (NSString *)_password
     successed : (void (^)(id))_success
       failure : (void (^)(NSError *))_failure;

- (void)SignUp:(NSData *)_avatar
      username:(NSString *)_username
      password:(NSString *)_password
         email:(NSString *)_email
     successed:(void (^)(id))_success
       failure:(void (^)(NSError *))_failure;

- (void)LogOut : (NSString *)_userId
     authtoken : (NSString *)_authtoken
     successed : (void (^)(id))_success
       failure : (void (^)(NSError *))_failure;

- (void)UpdateProfile:(NSData *)_avatar
               userid:(NSString *)_userid
             fullname:(NSString *)_fullname
             username:(NSString *)_username
                email:(NSString *)_email
                birth:(NSString *)_birth
            successed:(void (^)(id))_success
              failure:(void (^)(NSError *))_failure;



- (void)GetThemes : (NSString*) _id
        successed : (void (^)(id))_success
          failure : (void (^)(NSError *))_failure;

- (void)GetCategories : (NSString*) _id
            successed : (void (^)(id))_success
              failure : (void (^)(NSError *))_failure;


- (void)GetProductsByCategory : (NSString*) _id
                    successed : (void (^)(id))_success
                      failure : (void (^)(NSError *))_failure;

- (void)GetProductDetailInfo : (NSString*) _id
                      userid : (NSString*)_userid
                   successed : (void (^)(id))_success
                     failure : (void (^)(NSError *))_failure;

- (void)AddWishlist : (NSString*) _id
             userid : (NSString*)_userid
          successed : (void (^)(id))_success
            failure : (void (^)(NSError *))_failure;

- (void)DeleteWishlist : (NSString*) _id
             successed : (void (^)(id))_success
               failure : (void (^)(NSError *))_failure;

- (void)GetAllWishlist : (NSString*) _id
             successed : (void (^)(id))_success
               failure : (void (^)(NSError *))_failure;

- (void)AddToCart : (NSString*) _id
           userid : (NSString*)_userid
            color : (NSString*)_color
             size : (NSString*)_size
        successed : (void (^)(id))_success
          failure : (void (^)(NSError *))_failure;

- (void)GetAllCart : (NSString*) _id
         successed : (void (^)(id))_success
           failure : (void (^)(NSError *))_failure;

- (void)UpdateCart : (NSString*) _id
          cartinfo : (NSString*) _cartinfo
         successed : (void (^)(id))_success
           failure : (void (^)(NSError *))_failure;

- (void) AddComment:(NSString *)_userid
          productid:(NSString *)_productid
            content:(NSString *)_content
          successed:(void (^)(id))_success
            failure:(void (^)(NSError *))_failure;

- (void) GetAllComment:(NSString *)_productid
             successed:(void (^)(id))_success
               failure:(void (^)(NSError *))_failure;

- (void) chargeWithToken:(NSString *)_userid
                   token:(NSString *)_token
                  amount:(NSString *)_amount
                fullname:(NSString *)_fullname
                  street:(NSString *)_street
                 country:(NSString *)_country
                 zipcode:(NSString *)_zipcode
                   phone:(NSString *)_phone
               successed:(void (^)(id))_success
                 failure:(void (^)(NSError *))_failure;




- (void)SearchNearbyUser : (NSString*)_latitude
                longitude: (NSString*)_longitude
              search_text: (NSString*)_searchText
               successed : (void (^)(id))_success
                 failure : (void (^)(NSError *))_failure;

- (void)GetPlaceDetailInfo : (NSString*) _placeId
                 successed : (void (^)(id))_success
                   failure : (void (^)(NSError *))_failure;

- (void)GetProviderDetailInfo : (NSString*) _providerId
                    successed : (void (^)(id))_success
                      failure : (void (^)(NSError *))_failure;

-(void)GetMyPets:(NSString*) self_id
       successed:(void (^)(id))_success
         failure:(void (^)(NSError *))_failure;

- (void)GetServices : (NSString*) _group_id
          successed : (void (^)(id))_success
            failure : (void (^)(NSError *))_failure;

- (void)GetAllAppointments : (NSString*) _owner_id
          successed : (void (^)(id))_success
            failure : (void (^)(NSError *))_failure;

- (void)GetAllAppointmentFromProvider : (NSString*) _provider_id
                            successed : (void (^)(id))_success
                              failure : (void (^)(NSError *))_failure;

- (void) AddAppointment:(NSString*) _petId
            provider_id:_providerId
                   date:_date
                   time:_time
                address:_address
                ranking:_ranknum
             service_id:_serviceId
                   note:_note
              successed:_success
                failure:_failure;

- (void) AddSelfAppointment:(NSString*) _petId
                       date:_date
                       time:_time
                      title:_title
                       note:_note
                  successed:_success
                    failure:_failure;


//  Facebook account  SignIn/SignUp

- (void)FBSignIn : (NSString *)_fbID
       successed : (void (^)(id _responseObject)) _success
         failure : (void (^)(NSError *_error))_failure;
- (void)FBSignUp : (NSString *)_username
          avatar : (NSString *)_avatar
           email : (NSString *)_email
            fbID : (NSString *)_fbID
       successed : (void(^)(id _responseObject))_success
         failure : (void (^)(NSError *_error))_failure;
//Get  Photo Information page


- (void)GetPhotos : (NSString *)_otherid
        successed : (void(^)(id _responseObject))_success
          failure : (void(^)(NSError *_error))_failure;

- (void)GEtPopular : (void(^)(id _responseObject))_success
           failure : (void(^)(id _responseObject))_failure;


- (void)searchImage : (NSString *)tagText
          successed : (void (^)(id _responseObject))_success
            failure : (void (^)(NSError *_error))_failure;


//Profile page

-(void)GetProfile:(NSString *)_authToken
            my_id:(NSString *)_myid
         other_id:(NSString *)_otherid
        successed:(void (^)(id))_success
          failure:(void (^)(NSError *))_failure;
- (void) SetProfile : (NSData *)_avatar
           username : (NSString *)_username
               name : (NSString *)_name
            website : (NSString *)_website
                bio : (NSString *)_bio
              email : (NSString *)_email
              phone : (NSString *)_phone
             gender : (NSString *)_gender
          successed : (void(^)(id _responseObject))_success
            failure : (void (^)(NSError *_error))_failure;

-(void)UploadProfile:(NSData *)_avatar
            username:(NSString *)_username
               email:(NSString *)_email
           successed:(void (^)(id))_success
             failure:(void (^)(NSError *))_failure;

- (void)SetPassword : (NSString *)_oldPassword
        newPassword : (NSString *)_newPassword
          successed : (void(^)(id _responseObject))_success
            failure : (void (^)(NSError *_error))_failure;

- (void)SetAvatar : (NSData *)_avatar
//        coverPhoto: (NSData *)_coverPhoto
        successed : (void(^)(id _responseObject))_success
          failure : (void (^)(NSError *_error))_failure;

- (void)changeCoverPhoto:(NSData *)_coverPhoto
              successed : (void(^)(id _responseObject))_success
                failure : (void (^)(NSError *_error))_failure;

- (void) GetAllUsers:(void (^)(id))_success
             failure:(void (^)(NSError *))_failure;


//Feed page

-  (void)FeedAdd : (NSData *)_photo
             name: (NSString *)_name
             tag : (NSString *)_tag
            width: (NSInteger) _width
           height: (NSInteger) _height
         yepOrnoo: (NSInteger) _yepOrnoo
       successed : (void (^) (id _responseObject))_success
         failure : (void (^) (NSError *_error))_failure;

- (void)FeedRemove : (NSString *)_postid
         successed : (void (^)(id _responseObject))_success
           failure : (void (^)(NSError *_error))_failure;
- (void)Feeds : (SocialUser *)_user
    successed : (void (^) (id _responseObject))_success
      failure : (void (^) (NSError *_error))_failure;

- (void)FeedFollows : (void(^)(id _responseObject))_success
            failure : (void (^) (NSError *_error))_failure;

- (void)FeedNews : (void(^)(id _responseObject))_success
         failure : (void (^) (NSError *_error))_failure;

- (void)FeedTag : (NSString *)tag
      successed : (void (^)(id _responseObject))_success
        failure : (void (^)(NSError *_error))_failure;

//Like

- (void)LikeAdd : (SocialFeed *)_feed
      successed : (void (^) (id _responseObject)) _success
        failure : (void (^) (NSError *_error))_failure;

- (void)LikeRemove : (SocialFeed *)_feed
         successed : (void (^) (id _responseObject))_success
           failure : (void (^) (NSError *_error))_failure;

- (void)Likes : (SocialFeed *)_feed
    successed : (void (^) (id _responseObject))_success
      failure : (void (^) (NSError *_error))_failure;

- (void)myLikes:(void (^) (id _responseObject))_success
        failure:(void (^) (NSError *_error))_failure;
//Comment
- (void)CommentAdd : (SocialFeed *)_feed
           comment : (NSString *)_comment
         successed : (void (^) (id _responseObject))_success
           failure : (void (^) (NSError *_error))_failure;

- (void)CommentRemove : (NSString *)_commentid
            successed : (void (^)(id _responseObject))_success
              failure : (void (^) (NSError * _error)) _failure;

- (void)Comments : (SocialFeed *)_feed
       successed : (void (^) (id _responseObject))_success
         failure : (void (^) (NSError *_error))_failure;

//Follow
- (void)AddFollow : (NSString *)userid
        successed : (void (^)(id _responseObject))_success
          failure : (void (^)(NSError *_error)) _failure;
- (void)FollowingRemove:  (NSString *)userid
             successed : (void (^)(id _responseObject))_success
               failure : (void (^)(NSError *_error)) _failure;
- (void)Followers : (NSString *)userid
        successed : (void (^)(id _responseObject))_success
          failure : (void (^)(NSError *_error)) _failure;
- (void)Followings : (NSString *)userid
         successed : (void (^)(id _responseObject))_success
           failure : (void (^)(NSError *_error)) _failure;

//Notifications
- (void)Notifications : (NSString *)_is_new
            successed : (void (^)(id _responseObject))_success
              failure : (void (^)(NSError *_error)) _failure;



- (void)GetBadge:(void (^) (id _responseObject))_success
        failure : (void (^) (NSError *_error))_failure;

//Release
- (void)RequestRelease: (NSString *)_postid
            successed : (void (^)(id _responseObject))_success
              failure : (void (^)(NSError *_error))_failure;
- (void)answerForRequest:(SocialNotification *)_notification
             releaseType:(NSString *)yepOrnoo
               successed:(void (^)(id))_success
                 failure:(void (^)(NSError *))_failure;





@end
