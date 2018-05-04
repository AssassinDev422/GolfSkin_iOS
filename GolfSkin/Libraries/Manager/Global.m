//
//  Global.m
//  YepNoo
//
//  Created by ellisa on 3/17/14.
//  Copyright (c) 2014 Hualong. All rights reserved.
//

#import "Global.h"

@implementation Global

+ (void)setCircleView:(UIView *)view
          borderColor:(UIColor *)color
{
    float borderWidth = 2.0f;
    
    if (color == nil)
    {
        borderWidth = 0;
    }
    
    view.layer.cornerRadius = roundf(view.frame.size.height/2.0f);
    view.layer.masksToBounds = YES;
    
    CALayer *borderLayer = [CALayer layer];
    
    CGRect borderFrame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:view.frame.size.width/2];
    [borderLayer setBorderColor:color.CGColor];
    [borderLayer setBorderWidth:borderWidth];
    [view.layer addSublayer:borderLayer];
}

+ (void)setRoundView:(UIView *)view
        cornorRadius:(float)radian
         borderColor:(UIColor *)color
         borderWidth:(float)border
{
    view.layer.cornerRadius = radian;
    view.layer.masksToBounds = YES;
    
    CALayer *borderLayer = [CALayer layer];
    
    CGRect borderFrame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:view.frame.size.width/2];
    [borderLayer setBorderColor:color.CGColor];
    [borderLayer setBorderWidth:border];
    [view.layer addSublayer:borderLayer];

}


+ (void)showAlertTips:(NSString *)_message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:_message
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

//+ (void)setImageURLWithAsync:(NSString *)_urlStr
//                positionView:(UIView *)_positionView
//              displayImgView:(UIImageView *)_displayImgView
//{
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlStr]];
//    UIActivityIndicatorView *activities = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [activities setBackgroundColor:[UIColor clearColor]];
//    activities.center = _displayImgView.center;
//    [_positionView addSubview:activities];
//    [activities setHidesWhenStopped:YES];
//    [activities startAnimating];
//    
//    __block UIImageView *_feedImgView = _displayImgView;
//    
//    [_displayImgView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"avatar.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        NSLog(@"Success!");
//        [activities stopAnimating];
//        
//        [_feedImgView setImage:image];
//        
//        [activities removeFromSuperview];
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        NSLog(@"%@",[error localizedDescription]);
//        [activities stopAnimating];
//        [activities removeFromSuperview];
//    }];
//    
//}
//

+ (CGSize)getBoundingOfString:(NSString *)text width:(float)_width
{
    
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    CGSize sizeToFit;
    CGFloat messageMaxWidth = _width;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    sizeToFit = [text boundingRectWithSize: CGSizeMake(messageMaxWidth, CGFLOAT_MAX)
               options: NSStringDrawingUsesLineFragmentOrigin
                   attributes: @{ NSFontAttributeName : [UIFont systemFontOfSize:13.0f] }
                  context: nil].size;
#else
    sizeToFit = [text sizeWithFont:[[UIFont systemFontOfSize:13.0f]
              constrainedToSize:CGSizeMake(messageMaxWidth, CGFLOAT_MAX)
               lineBreakMode:NSLineBreakByWordWrapping];
#endif
    return sizeToFit;
}
@end
