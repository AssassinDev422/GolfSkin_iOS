//
//  ProfileViewController.m
//  GolfSkin
//
//  Created by scs on 6/17/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "ProfileViewController.h"
#import "HomeViewController.h"
#import "SWRevealViewController.h"

@interface ProfileViewController ()<UITextFieldDelegate>
{
    NSString *strStatus;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self menuSetup];
    _btnHome.layer.cornerRadius = 20;
    _btnHome.layer.borderWidth = 1;
    _btnHome.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    strStatus = @"view";
    _textfieldName.text = [appController.dicUserInfo objectForKey:@"name"];
    _textfieldEmail.text = [appController.dicUserInfo objectForKey:@"email"];
    
    if (![_textfieldName.text isEqualToString:@""]) {
        [_lblNamePlaceholder setHidden:YES];
    }
    if (![_textfieldEmail.text isEqualToString:@""]) {
        [_lblEmailPlaceholder setHidden:YES];
    }
    
    NSString *strIsDisplay = [appController.dicUserInfo objectForKey:@"is_display"];
    [_switchDisplayemail setOn: [strIsDisplay isEqualToString:@"1"]];
    
    [_switchKeepSignin setOn:[commonUtils isLoggedin]];
    
    _textfieldName.delegate = self;
    _textfieldEmail.delegate = self;
    _textfieldPassword.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 100:
            [_lblNamePlaceholder setHidden:YES];
            break;
        case 101:
            [_lblEmailPlaceholder setHidden:YES];
            break;
        case 102:
            [_lblPasswordPlaceholder setHidden:YES];
            break;

        default:
            break;
    }
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 100:
            if ([textField.text isEqualToString:@""]) {
                [_lblNamePlaceholder setHidden:NO];
            }
            break;
        case 101:
            if ([textField.text isEqualToString:@""]) {
                [_lblEmailPlaceholder setHidden:NO];
            }
            break;
        case 102:
            if ([textField.text isEqualToString:@""]) {
                [_lblPasswordPlaceholder setHidden:NO];
            }
            break;
            
        default:
            break;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 3) {
        
        [self.view endEditing:YES];
    }
    return YES;
}

- (void)menuSetup {
    if (self.revealViewController != nil) {
        _btnItemMenu.target = self.revealViewController;
        [_btnItemMenu setAction:@selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        [self.navigationController setNavigationBarHidden:false];
        self.navigationItem.hidesBackButton = true;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]                                                       forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - IBACTIONS

- (IBAction)OnSwitchShowPassword:(id)sender {
    if (_switchShowPassword.isOn) {
        [_textfieldPassword setSecureTextEntry:NO];
    }
    else {
        [_textfieldPassword setSecureTextEntry:YES];
    }
    
}

- (IBAction)OnSwitchShowDraft:(id)sender {
}

- (IBAction)OnSwitchKeepSignin:(id)sender {
}

- (IBAction)OnHome:(id)sender {
    if ([strStatus isEqualToString:@"view"]) {
        strStatus = @"edit";
        [_textfieldName setEnabled:YES];
        [_textfieldEmail setEnabled:YES];
        [_textfieldPassword setEnabled:YES];
        [_textfieldName becomeFirstResponder];
        [_btnHome setTitle:@"SAVE" forState:UIControlStateNormal];
        [self.navigationItem setTitle:@"EDIT USER PROFILE"];
        self.navigationItem.title = @"EDIT USER PROFILE";
        return;
    }
    
    
    NSString *strMessage = @"";
    bool bFill = true;
    if ([_textfieldName.text isEqualToString:@""]) {
        strMessage = [NSString stringWithFormat:@"%@ Name,", strMessage];
        bFill = false;
    }
    if ([_textfieldEmail.text isEqualToString:@""]) {
        strMessage = [NSString stringWithFormat:@"%@ Email", strMessage];
        bFill = false;
    }

    strMessage = [NSString stringWithFormat:@"%@ Required.", strMessage];
    
    if (!bFill) {
        [commonUtils showAlert:nil withMessage:strMessage view:self];
        return;
    }
    
    if (![commonUtils validateEmail:_textfieldEmail.text]) {
        [commonUtils showAlert:nil withMessage:@"Please input valid Email Address" view:self];
        return;
    }

    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    
    NSString *isDisplay = _switchDisplayemail.isOn == true ? @"1" : @"0";
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:_textfieldName.text forKey:@"name"];
    [userInfo setObject:_textfieldEmail.text forKey:@"email"];
    [userInfo setObject:_textfieldPassword.text forKey:@"password"];
    [userInfo setObject: isDisplay forKey:@"is_displayemail"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestUpdateProfile:userInfo];
    });
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request API
- (void) requestUpdateProfile:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_UPDATE_USER withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 0) {
            
            appController.dicUserInfo = [result objectForKey:@"data"];
            appController.strUserId = [appController.dicUserInfo objectForKey:@"id"];
            appController.strToken = [appController.dicUserInfo objectForKey:@"token"];
            
            [commonUtils setUserDefault:@"user_id" withFormat:appController.strUserId];
            [commonUtils setUserDefault:@"token" withFormat:appController.strToken];
            [commonUtils setUserDefaultDic:@"user_info" withDic:appController.dicUserInfo];
            
            if (_switchKeepSignin.isOn) {
                [commonUtils setUserDefault:@"isLoggedin" withFormat:@"1"];
            }
            else {
                [commonUtils setUserDefault:@"isLoggedin" withFormat:@"0"];
            }
            
            strStatus = @"view";
            [_textfieldName setEnabled:NO];
            [_textfieldEmail setEnabled:NO];
            [_textfieldPassword setEnabled:NO];
            [_btnHome setTitle:@"EDIT" forState:UIControlStateNormal];
            self.navigationItem.title = @"VIEW USER PROFILE";
            [commonUtils showAlert: nil withMessage:@"Saved Successfully" view:self];
            
        } else {
            [commonUtils showAlert: nil withMessage:[result objectForKey:@"msg"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

@end
