//
//  LoginViewController.h
//  GolfSkin
//
//  Created by scs on 6/10/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textfieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textfieldPassword;
@property (strong, nonatomic) IBOutlet UISwitch *swiftchSignin;
@property (strong, nonatomic) IBOutlet UISwitch *switchShowPassword;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btnSignin;
@property (strong, nonatomic) IBOutlet UIView *viewAlert;
@property (strong, nonatomic) IBOutlet UIView *viewAlertBack;
@property (strong, nonatomic) IBOutlet UITextField *textfieldForgotEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblEmailPlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *lblPasswordPlaceholder;

- (IBAction)OnForgotPassword:(id)sender;
- (IBAction)OnSignin:(id)sender;
- (IBAction)OnKeepSignin:(id)sender;
- (IBAction)OnShowPassword:(id)sender;
- (IBAction)OnSendForgot:(id)sender;
- (IBAction)OnCancelForgot:(id)sender;
- (IBAction)OnBack:(id)sender;
@end
