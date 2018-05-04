//
//  ProfileViewController.h
//  GolfSkin
//
//  Created by scs on 6/17/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnItemMenu;
@property (strong, nonatomic) IBOutlet UITextField *textfieldName;
@property (strong, nonatomic) IBOutlet UITextField *textfieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textfieldPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnHome;
@property (strong, nonatomic) IBOutlet UILabel *lblNamePlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *lblEmailPlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *lblPasswordPlaceholder;
@property (strong, nonatomic) IBOutlet UISwitch *switchShowPassword;
@property (strong, nonatomic) IBOutlet UISwitch *switchDisplayemail;
@property (strong, nonatomic) IBOutlet UISwitch *switchKeepSignin;

- (IBAction)OnSwitchShowPassword:(id)sender;
- (IBAction)OnSwitchShowDraft:(id)sender;
- (IBAction)OnSwitchKeepSignin:(id)sender;
- (IBAction)OnHome:(id)sender;
- (IBAction)OnBack:(id)sender;
@end
