//  CommonUtils.h
//  Created by BE

#import <Foundation/Foundation.h>
#import "DGActivityIndicatorView.h"

@interface CommonUtils : NSObject {
    UIActivityIndicatorView *activityIndicator;
    DGActivityIndicatorView *activityIndicatorView;
    UIView *viewCover;
}

@property (nonatomic, strong) NSMutableDictionary *dicAlertContent;

+ (instancetype)shared;


- (void)showAlert:(NSString *)title withMessage:(NSString *)message view:(UIViewController*) controller;

- (void)removeAllSubViews:(UIView *) view;
- (void)setScrollViewOffsetBottom:(UIScrollView *) view;


- (NSString *)getUserDefault:(NSString *)key;
- (void)setUserDefault:(NSString *)key withFormat:(NSString *)val;
- (void)removeUserDefault:(NSString *)key;

- (NSMutableDictionary *)getUserDefaultDicByKey:(NSString *)key;
- (void)setUserDefaultDic:(NSString *)key withDic:(NSMutableDictionary *)dic;
- (void)removeUserDefaultDic:(NSString *)key;
- (BOOL)isLoggedin;

- (void) cropCircleImage:(UIImageView *)imageView;
- (void) setCircleBorderImage:(UIImageView *)imageView withBorderWidth:(float)width withBorderColor:(UIColor *)color;
- (void) setRoundedRectBorderImage:(UIImageView *)imageView withBorderWidth:(float)width withBorderColor:(UIColor *)color withBorderRadius:(float)radius;

- (void) cropCircleButton:(UIButton *)button;
- (void) setCircleBorderButton:(UIButton *)button withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color;
- (void) setRoundedRectBorderButton:(UIButton *)button withBorderWidth:(float)width withBorderColor:(UIColor *)color withBorderRadius:(float)radius;

- (void) setRoundedRectView:(UIView *)view withCornerRadius:(float)radius;

- (void) setImageViewAFNetworking:(UIImageView *)imageView withImageUrl:(NSString *)imageUrl withPlaceholderImage:(UIImage *)placeholder;
- (void) setButtonImageAFNetworking:(UIButton *)button withImageUrl:(NSString *)imageUrl withPlaceholderImage:(UIImage *)placeholder;
- (void) setButtonMultiLineText:(UIButton *)button;

- (void) setTextFieldBorder:(UITextField *)textField withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius;
- (void) setTextFieldMargin:(UITextField *)textField valX:(float)x valY:(float)y valW:(float)w valH:(float)h;
- (void) setTextViewBorder:(UITextView *)textView withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius;
- (void) setTextViewMargin:(UITextView *)textView valX:(float)x valY:(float)y valW:(float)w valH:(float)h;


- (CGFloat)getHeightForTextContent:(NSString *)text withWidth:(CGFloat)width withFontSize:(CGFloat)fontSize;

- (NSString *) md5:(NSString *) input;
- (BOOL)validateEmail:(NSString *)emailStr;
- (NSArray *)getSortedArray:(NSArray *)array;




- (NSString *)getContentTypeForImageData:(NSData *)data;
- (NSString*)base64forData:(NSData*)theData;

- (NSString *)encodeToBase64String:(UIImage *)image byCompressionRatio:(float)compressionRatio;
- (NSString *)encodeMediaPathToBase64String:(NSString *)mediaPath;
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
- (NSString *)getJsonStringFromDic:(NSMutableDictionary *)array;

- (NSString*)getShortName:(NSString*)fullName;
- (NSString*)getFirstName:(NSString*)fullName;
- (NSMutableArray*)getColorArray;
- (NSMutableArray*)getBubbleArray;
    
- (void)showActivityIndicator:(UIView *)inView;
- (void)hideActivityIndicator;
- (void)showSmallIndicator:(UIView *)inView;
    
// Custom Functions
- (void)customizeNavigationBar:(UIViewController *)view hideBackButton:(BOOL) option;
- (NSString *)getmonthstring:(NSString *)month;
- (NSString *)gettimestring:(NSString *)time;

- (NSDate*)stringToDate: (NSString*)date dateFormat:(NSString*)format;
- (NSString*)dateToString:(NSDate*)date dateFormat:(NSString*)format;
- (NSDate*)changeTimezone:(NSDate*)date dateFormat:(NSString*)format;
- (BOOL)checkToday:(NSDate*)date;
- (BOOL)checkYesterday:(NSDate*)date;
- (BOOL)checkSameday:(NSDate*)date1 date2:(NSDate*)date2;
    
//+ (id) httpCommonRequest:(NSString *) urlStr;
-(UIImage*)imageWithImage:(UIImage*)image
             scaledToSize:(CGSize)newSize;
- (id) httpJsonRequest:(NSString *) urlStr withJSON:(NSMutableDictionary *)params;
- (id) httpJsonRequestWithFile:(NSString *) urlStr withJSON:(NSMutableDictionary *)params withFile: (NSData*)file filename: (NSString*)filename;

@end
