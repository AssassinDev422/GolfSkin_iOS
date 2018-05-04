//
//  CommonUtils.m
//


#import "CommonUtils.h"
#import "NSString+Base64.h"
#import <CommonCrypto/CommonDigest.h>
//#import "KGModal.h"

@implementation CommonUtils

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark - Alert

- (void)showAlert:(NSString *)title withMessage:(NSString *)message view:(UIViewController*) controller {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [controller presentViewController:alertController animated:YES completion:nil];
}


- (void) removeAllSubViews:(UIView *) view {
    for (long i=view.subviews.count-1; i>=0; i--) {
        [[view.subviews objectAtIndex:i] removeFromSuperview];
    }
}
- (void)setScrollViewOffsetBottom:(UIScrollView *) view {
    CGPoint bottomOffset = CGPointMake(0, view.contentSize.height - view.bounds.size.height);
    [view setContentOffset:bottomOffset animated:YES];
}


#pragma mark - NSUserDefault

- (id)getUserDefault:(NSString *)key {
    id val = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    //    if([val isKindOfClass:[NSMutableArray class]] && val == nil) return @"";
    if([val isKindOfClass:[NSString class]] && (val == nil || val == NULL || [val isEqualToString:@"0"])) val = nil;
    return val;
}
- (void)setUserDefault:(NSString *)key withFormat:(id)val {
    if([val isKindOfClass:[NSString class]] && [val isEqualToString:@""]) val = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
}
- (void)removeUserDefault:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (NSMutableDictionary *)getUserDefaultDicByKey:(NSString *)key {
    NSMutableDictionary *dicAll = (NSMutableDictionary *)[[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for(NSString *dicKey in [dicAll allKeys]) {
        if([dicKey rangeOfString:[key stringByAppendingString:@"_"]].location != NSNotFound) {
            [dic setObject:[dicAll objectForKey:dicKey] forKey:[dicKey substringFromIndex:[[key stringByAppendingString:@"_"] length]]];
        }
    }
    return dic;
}
- (void)setUserDefaultDic:(NSString *)key withDic:(NSMutableDictionary *)dic {
    NSString *newKey = @"";
    for(NSString *dicKey in [dic allKeys]) {
        //if(![[dic objectForKey:dicKey] isKindOfClass:[NSMutableArray class]]) {
        newKey = [[key stringByAppendingString:@"_"] stringByAppendingString:dicKey];
        [self setUserDefault:newKey withFormat:[dic objectForKey:dicKey]];
        //}
    }
}
- (void)removeUserDefaultDic:(NSString *)key {
    NSMutableDictionary *dicAll = (NSMutableDictionary *)[[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for(NSString *dicKey in [dicAll allKeys]) {
        if([dicKey rangeOfString:[key stringByAppendingString:@"_"]].location != NSNotFound) {
            [self removeUserDefault:dicKey];
        }
    }
}

- (BOOL)isLoggedin {
    if ([self getUserDefault:@"isLoggedin"] == nil) {
        return NO;
    }
    if ([[self getUserDefault:@"isLoggedin"] isEqualToString:@"1"])
        return YES;
    else {
        return NO;
    }
}


#pragma mark - NSString
- (NSString*)getShortName:(NSString*)fullName {
    NSMutableString * shortName = [NSMutableString string];
    NSArray * words = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringToIndex:1];
            [shortName appendString:[firstLetter uppercaseString]];
        }
    }
    shortName = [[shortName uppercaseString] mutableCopy];
    return (NSString*)shortName;
}

- (NSString*)getFirstName:(NSString*)fullName {
    NSArray * words = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words) {
        return word;
    }
    
    return @"";
}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}



- (NSString *)getContentTypeForImageData:(NSData *)data {
    
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @".jpeg";
        case 0x89:
            return @".png";
        case 0x47:
            return @".gif";
        case 0x49:
            break;
        case 0x42:
            return @".bmp";
        case 0x4D:
            return @".tiff";
    }
    return nil;
}

- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (NSString *)encodeToBase64String:(UIImage *)image byCompressionRatio:(float)compressionRatio {
    NSString *photo = @"";
    NSData *data = UIImageJPEGRepresentation(image, compressionRatio);
    if(data == nil) {
        data = [NSData dataWithData:UIImagePNGRepresentation(image)];
    }
    photo = [NSString base64StringFromData:data length:[data length]];
    //    photo = [photo stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return photo;
    //return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)encodeMediaPathToBase64String:(NSString *)mediaPath {
    NSString *media = @"";
    NSData *data = [NSData dataWithContentsOfFile:mediaPath];
    //    media = [NSString base64StringFromData:data length:[data length]];
    media = [data base64EncodedStringWithOptions:0];
    //    photo = [photo stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return media;
    //return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (NSString *)getJsonStringFromDic:(NSMutableDictionary *)array {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSString *)getmonthstring:(NSString *)month{
    NSString* dateStr1;
    switch ([month intValue]){
        case 1:{
            dateStr1 = @"Jan";
            break;
        }
        case 2:{
            dateStr1 = @"Feb";
            break;
        }
        case 3:{
            dateStr1 = @"Mar";
            break;
        }
        case 4:{
            dateStr1 = @"Apr";
            break;
        }
        case 5:{
            dateStr1 = @"May";
            break;
        }
        case 6:{
            dateStr1 = @"Jun";
            break;
        }
        case 7:{
            dateStr1 = @"Jul";
            break;
        }
        case 8:{
            dateStr1 = @"Aug";
            break;
        }
        case 9:{
            dateStr1 = @"Sep";
            break;
        }
        case 10:{
            dateStr1 = @"Oct";
            break;
        }
        case 11:{
            dateStr1 = @"Nov";
            break;
        }
        case 12:{
            dateStr1 = @"Dec";
            break;
        }
        default:
            break;
    }
    return dateStr1;
}
- (NSString *)gettimestring:(NSString *)time{
    NSString* dateStr1;
    if ([time intValue] < 12 ) {
        dateStr1 = [NSString stringWithFormat:@"%@ AM",time];
    }else if ([time intValue] == 12){
        dateStr1 = [NSString stringWithFormat:@"%d PM",[time intValue]];
    }
    else if ([time intValue] > 12){
        dateStr1 = [NSString stringWithFormat:@"%d PM",[time intValue] - 12];
    }
    return dateStr1;
}

#pragma mark - NSString <-> NSDate
- (NSDate*)stringToDate: (NSString*)date dateFormat:(NSString*)format {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter dateFromString:date];
}

- (NSString*)dateToString:(NSDate*)date dateFormat:(NSString*)format {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

- (NSDate*)changeTimezone:(NSDate*)date dateFormat:(NSString*)format {
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval secondsInEightHours = [destinationTimeZone secondsFromGMT];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:format];
    
    date = [date dateByAddingTimeInterval:secondsInEightHours];
    return date;
}
- (BOOL)checkToday:(NSDate*)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *today = [dateFormatter stringFromDate: [NSDate date]];
    NSString *strDate = [dateFormatter stringFromDate: date];
    
    if ([today isEqualToString:strDate]) {
        return true;
    }
    return false;
}

- (int)getTimeDiff:(NSDate*)date {
    NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:date];
    return diff;
}

- (BOOL)checkYesterday:(NSDate*)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *yesterday = [dateFormatter stringFromDate: [[NSDate date] dateByAddingTimeInterval:(-60) * 60 * 24]];
    NSString *strDate = [dateFormatter stringFromDate: date];
    
    if ([yesterday isEqualToString:strDate]) {
        return true;
    }
    return false;
}

- (BOOL)checkSameday:(NSDate*)date1 date2:(NSDate*)date2 {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDate1 = [dateFormatter stringFromDate: date1];
    NSString *strDate2 = [dateFormatter stringFromDate: date2];
    
    if ([strDate1 isEqualToString:strDate2]) {
        return true;
    }
    return false;
}


#pragma mark - UIImage
- (void) cropCircleImage:(UIImageView *)imageView {
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.clipsToBounds = YES;
    return;
}

- (void) setCircleBorderImage:(UIImageView *)imageView withBorderWidth:(float) width withBorderColor:(UIColor *) color {
    [self cropCircleImage:imageView];
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (imageView.frame.size.width), (imageView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:imageView.frame.size.width/2];
    [borderLayer setBorderWidth:width];
    [borderLayer setBorderColor:[color CGColor]];
    [imageView.layer addSublayer:borderLayer];
}

- (void) setRoundedRectBorderImage:(UIImageView *)imageView withBorderWidth:(float) width withBorderColor:(UIColor *) color withBorderRadius:(float)radius {
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = radius;
    
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (imageView.frame.size.width), (imageView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:radius];
    [borderLayer setBorderWidth:width];
    [borderLayer setBorderColor:[color CGColor]];
    [imageView.layer addSublayer:borderLayer];
}

- (void) setImageViewAFNetworking:(UIImageView *)imageView withImageUrl:(NSString *)imageUrl withPlaceholderImage:(UIImage *)placeholder {
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [imageView setImageWithURLRequest:req placeholderImage:placeholder success:nil failure:nil];
    //    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
}


#pragma mark - UIButton
- (void) cropCircleButton:(UIButton *)button {
    button.clipsToBounds = YES;
    button.layer.cornerRadius = button.frame.size.width / 2.0f;
}
- (void) setCircleBorderButton:(UIButton *)button withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color {
    button.clipsToBounds = YES;
    button.layer.cornerRadius = button.frame.size.width / 2.0f;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = borderWidth;
}
- (void) setRoundedRectBorderButton:(UIButton *)button withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color withBorderRadius:(float)radius{
    button.clipsToBounds = YES;
    button.layer.cornerRadius = radius;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = borderWidth;
}

- (void) setRoundedRectView:(UIView *)view withCornerRadius:(float)radius {
    view.clipsToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}


- (void) setButtonImageAFNetworking:(UIButton *)button withImageUrl:(NSString *)imageUrl withPlaceholderImage:(UIImage *)placeholder {
    NSURL *url = [NSURL URLWithString:imageUrl];
    [button setImageForState:UIControlStateNormal withURL:url placeholderImage:placeholder];
    [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)setButtonMultiLineText:(UIButton *)button {
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
}
- (void) setTextFieldBorder:(UITextField *)textField withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius {
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = width;
    textField.layer.cornerRadius = radius;
    textField.layer.masksToBounds = true;
}

#pragma mark - UITextField, UITextView
- (void) setTextFieldMargin:(UITextField *)textField valX:(float)x valY:(float)y valW:(float)w valH:(float)h {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void) setTextViewBorder:(UITextView *)textView withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius {
    textView.layer.borderColor = color.CGColor;
    textView.layer.borderWidth = width;
    textView.layer.cornerRadius = radius;
    textView.layer.masksToBounds = true;
}

- (void) setTextViewMargin:(UITextView *)textView valX:(float)x valY:(float)y valW:(float)w valH:(float)h {
    textView.textContainerInset = UIEdgeInsetsMake(x, y, w, h);
}

- (CGFloat)getHeightForTextContent:(NSString *)text withWidth:(CGFloat)width withFontSize:(CGFloat)fontSize {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
    [textView setFont:[UIFont systemFontOfSize:fontSize]];
    textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [textView setText:text];
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return newSize.height;
}





#pragma mark - ActivityIndicator
- (void)showActivityIndicator:(UIView *)inView {
    
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotatePulse tintColor:[UIColor whiteColor]];
    CGFloat width = 150;
    CGFloat height = 150;
    
    if (viewCover == nil) {
        viewCover = [[UIView alloc] initWithFrame:inView.frame];
    }
    
//    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//        viewCover.backgroundColor = [UIColor clearColor];
//
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        blurEffectView.frame = viewCover.bounds;
//        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//
//        [viewCover addSubview:blurEffectView];
//    } else {
//        viewCover.backgroundColor = [UIColor blackColor];
//    }
    
    viewCover.backgroundColor = [UIColor darkGrayColor];
    viewCover.alpha = 0.6;

    activityIndicatorView.frame = CGRectMake((viewCover.frame.size.width - width) / 2, (viewCover.frame.size.height - height) / 2, width, height);
    [activityIndicatorView setSize:width];
    
    [inView addSubview:viewCover];
    [inView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
}



- (void)hideActivityIndicator {
    
    if (activityIndicatorView) {
        [activityIndicatorView stopAnimating];
    }
    
    [activityIndicatorView.superview setUserInteractionEnabled:YES];
    [activityIndicatorView setHidden:YES];
    [activityIndicatorView removeFromSuperview];
    [viewCover removeFromSuperview];
    [viewCover setHidden:YES];
    viewCover = nil;
}

- (void)showSmallIndicator:(UIView *)inView {
    
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeDoubleBounce tintColor:[UIColor whiteColor]];
    CGFloat width = 50;
    CGFloat height = 50;
    
    activityIndicatorView.frame = CGRectMake((inView.frame.size.width - width - 20), (inView.frame.size.height - height - 10), width, height);
    [activityIndicatorView setSize:width];
    
    [inView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
}

#pragma mark - Custom Functions

- (void)customizeNavigationBar:(UIViewController *)view hideBackButton:(BOOL) option {
    [view.navigationItem setHidesBackButton:option];
    UINavigationController *navController = view.navigationController;
    [navController.navigationItem setHidesBackButton:option];
    
    navController.navigationBar.translucent = YES;
    navController.navigationBar.barTintColor = [UIColor whiteColor];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    //[navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:@"Arial" size: 21.0f]}];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize: 18.0f]}];
    [navController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
-(UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



#pragma mark - NSARRAY
- (NSMutableArray*)getColorArray {
    return [@[COLOR_DARK_BROWN,
              COLOR_LIGHT_BLUE,
              COLOR_LIGHT_YELLOW,
              COLOR_DARK_BLUE,
              COLOR_RIGHT_PURPLE,
              COLOR_LIGHT_GREEN,
              COLOR_LIHGT_BROWN,
              COLOR_DARK_GREEN
              ] mutableCopy];
}

- (NSMutableArray*)getBubbleArray {
    return [@[@"bubble_dark_brown",
              @"bubble_light_blue",
              @"bubble_light_yellow",
              @"bubble_dark_blue",
              @"bubble_light_purple",
              @"bubble_light_green",
              @"bubble_light_brown",
              @"bubble_dark_green"
              ] mutableCopy];
}

- (NSArray *)getSortedArray:(NSArray *)array {
    NSArray *keys = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return keys;
}

#pragma mark - Common Httl Request Methods
//
//+ (id) httpCommonRequest:(NSString*) urlStr {
//    NSURL *url = [NSURL URLWithString:urlStr];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *jsonResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    //    NSLog(@"%@", jsonResult);
//    return [[SBJsonParser new] objectWithString:jsonResult];
//}

- (id) httpJsonRequest:(NSString *) urlStr withJSON:(NSMutableDictionary *)params {
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *body = [[SBJsonWriter new] stringWithObject:params];
    NSData *requestData = [body dataUsingEncoding:NSASCIIStringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return [[SBJsonParser new] objectWithString:jsonResult];
}

- (id) httpJsonRequestWithFile:(NSString *) urlStr withJSON:(NSMutableDictionary *)params withFile: (NSData*)file filename : (NSString*) filename {
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [[self buildRequest:file fileName:filename fileUrl:url] mutableCopy];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return [[SBJsonParser new] objectWithString:jsonResult];

}

- (NSURLRequest *)buildRequest: (NSData *)paramData fileName:(NSString *)name fileUrl:(NSURL*)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    [request setURL:url];
    [request setHTTPMethod:@"POST"];

    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *endBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];

    NSMutableData *tempPostData = [NSMutableData data]; 
    [tempPostData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    // Sample Key Value for data
    [tempPostData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Key_Param"] dataUsingEncoding:NSUTF8StringEncoding]];
    [tempPostData appendData:[@"Value_Param" dataUsingEncoding:NSUTF8StringEncoding]];
    [tempPostData appendData:[endBoundary dataUsingEncoding:NSUTF8StringEncoding]];

    // Sample file to send as data
    [tempPostData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    [tempPostData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [tempPostData appendData:paramData];
    [tempPostData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:tempPostData];
    return request;
}



@end
