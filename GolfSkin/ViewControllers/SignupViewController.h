//
//  SignupViewController.h
//  GolfSkin
//
//  Created by scs on 6/17/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textfieldName;
@property (strong, nonatomic) IBOutlet UITextField *textfieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textfieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *textfieldRePassword;
@property (strong, nonatomic) IBOutlet UIButton *btnSignup;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISwitch *switchShowPassword;
@property (strong, nonatomic) IBOutlet UISwitch *switchDisplayEmail;
@property (strong, nonatomic) IBOutlet UISwitch *switchKeepmesignin;

@property (strong, nonatomic) IBOutlet UIImageView *imgRePassword;
@property (strong, nonatomic) IBOutlet UILabel *lblRePassBar;
@property (strong, nonatomic) IBOutlet UILabel *lblNamePlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *lblEmailPlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *lblPasswordPlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *lblRepasswordPlaceholder;


- (IBAction)OnSwitchShowPassword:(id)sender;
- (IBAction)OnSwitchShowEmail:(id)sender;
- (IBAction)OnSwitchKeepSignin:(id)sender;
- (IBAction)OnSignUp:(id)sender;
- (IBAction)OnCancel:(id)sender;
@end
