//
//  SignupViewController.m
//  GolfSkin
//
//  Created by scs on 6/17/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "SignupViewController.h"
#import "HomeViewController.h"
#import "SWRevealViewController.h"

@interface SignupViewController ()<UITextFieldDelegate>
{
    bool isKeepSignin;
}
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isKeepSignin = YES;
    
//    [self.navigationController setNavigationBarHidden:false];
//    self.navigationItem.hidesBackButton = true;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]                                                       forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    _btnSignup.layer.cornerRadius = 20;
    _btnSignup.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnSignup.layer.borderWidth = 1;
    _btnCancel.layer.cornerRadius = 20;
    _btnCancel.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnCancel.layer.borderWidth = 1;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if (screenHeight < 738) {
        _scrollView.contentSize = CGSizeMake(screenWidth, 674);
    }

    screenHeight = screenRect.size.height;
    
    _textfieldName.delegate = self;
    _textfieldEmail.delegate = self;
    _textfieldPassword.delegate = self;
    _textfieldRePassword.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signup {
    NSString *strMessage = @"";
    bool bFill = true;
    if ([_textfieldName.text isEqualToString:@""] || [_textfieldName.text isEqualToString:@"NAME"]) {
        strMessage = [NSString stringWithFormat:@"%@ Name,", strMessage];
        bFill = false;
    }
    if ([_textfieldEmail.text isEqualToString:@""] || [_textfieldEmail.text isEqualToString:@"EMAIL"]) {
        strMessage = [NSString stringWithFormat:@"%@ Email,", strMessage];
        bFill = false;
    }
    if ([_textfieldPassword.text isEqualToString:@""]) {
        strMessage = [NSString stringWithFormat:@"%@ Password", strMessage];
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
    if (_switchShowPassword.isOn == NO && ![_textfieldPassword.text isEqualToString:_textfieldRePassword.text]) {
        [commonUtils showAlert:nil withMessage:@"Repeat password correctly." view:self];
        return;
    }
    
    NSString *isDisplay = _switchDisplayEmail.isOn == true ? @"1" : @"0";
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:_textfieldName.text forKey:@"name"];
    [userInfo setObject:_textfieldEmail.text forKey:@"email"];
    [userInfo setObject:_textfieldPassword.text forKey:@"password"];
    [userInfo setObject: isDisplay forKey:@"is_displayemail"];
    
    if (appController.deviceToken == nil) {
        appController.deviceToken = @"";
    }
    
    [userInfo setObject:appController.deviceToken forKey:@"device_token"];
    [userInfo setObject:@"ios" forKey:@"device"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestSingup:userInfo];
    });
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            [_lblNamePlaceholder setHidden:YES];
            break;
        case 2:
            [_lblEmailPlaceholder setHidden:YES];
            break;
        case 3:
            [_lblPasswordPlaceholder setHidden:YES];
            break;
        case 4:
            [_lblRepasswordPlaceholder setHidden:YES];
            break;
            
        default:
            break;
    }
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            if ([textField.text isEqualToString:@""]) {
                [_lblNamePlaceholder setHidden:NO];
            }
            break;
        case 2:
            if ([textField.text isEqualToString:@""]) {
                [_lblEmailPlaceholder setHidden:NO];
            }
            break;
        case 3:
            if ([textField.text isEqualToString:@""]) {
                [_lblPasswordPlaceholder setHidden:NO];
            }
            break;
        case 4:
            if ([textField.text isEqualToString:@""]) {
                [_lblRepasswordPlaceholder setHidden:NO];
            }
            
            break;
            
        default:
            break;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        [_textfieldEmail becomeFirstResponder];
    }
    else if (textField.tag == 2) {
        [_textfieldPassword becomeFirstResponder];
    }
    else if (textField.tag == 3) {
        [_textfieldRePassword becomeFirstResponder];
    }
    else if (textField.tag == 4) {
        [self.view endEditing:YES];
        [self signup];
        
    }
    return YES;
}

- (IBAction)textFieldChanged:(id)sender {
    [_lblRepasswordPlaceholder setHidden:YES];
}

#pragma mark - IBActions
- (IBAction)OnSwitchShowPassword:(id)sender {
    if (_switchShowPassword.isOn == true) {
//        _textfieldRePassword.enabled = NO;
        _textfieldPassword.secureTextEntry = NO;
        _textfieldRePassword.secureTextEntry = NO;
        [_textfieldRePassword setHidden:YES];
        [_imgRePassword setHidden:YES];
        [_lblRePassBar setHidden:YES];
        [_lblRepasswordPlaceholder setHidden:YES];
    }
    else {
//        _textfieldRePassword.enabled = YES;
        _textfieldPassword.secureTextEntry = YES;
        _textfieldRePassword.secureTextEntry = YES;
        [_textfieldRePassword setHidden:NO];
        [_imgRePassword setHidden:NO];
        [_lblRePassBar setHidden:NO];
        [_lblRepasswordPlaceholder setHidden:NO];
    }
}

- (IBAction)OnSwitchShowEmail:(id)sender {
}

- (IBAction)OnSwitchKeepSignin:(id)sender {
    if (_switchKeepmesignin.isOn == YES) {
        isKeepSignin = YES;
    }
    else {
        isKeepSignin = NO;
    }
}

- (IBAction)OnSignUp:(id)sender {
    [self signup];
}

- (IBAction)OnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request API
- (void) requestSingup:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_SIGNUP withJSON:(NSMutableDictionary *) params];
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
            
            if (isKeepSignin) {
                [commonUtils setUserDefault:@"isLoggedin" withFormat:@"1"];
            }
            else {
                [commonUtils setUserDefault:@"isLoggedin" withFormat:@"0"];
            }
            
            HomeViewController* homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            homeVC.isFirst = true;
            UINavigationController *frontVCNavigate = [[UINavigationController alloc]initWithRootViewController:homeVC];
            SWRevealViewController* mainRevealController = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            mainRevealController.frontViewController = frontVCNavigate;
            [self.navigationController pushViewController:mainRevealController animated:YES];

        } else {
            [commonUtils showAlert: nil withMessage:[result objectForKey:@"msg"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}
@end
