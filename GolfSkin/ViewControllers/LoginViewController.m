//
//  LoginViewController.m
//  GolfSkin
//
//  Created by scs on 6/10/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "SWRevealViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    bool isShowPassword;
    bool isKeepSignin;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isShowPassword = false;
    isKeepSignin = true;
    
    _textfieldEmail.delegate = self;
    _textfieldPassword.delegate = self;
    _textfieldForgotEmail.delegate = self;
    
    [self uiSetup];

}

- (void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Custom Functions

- (void)uiSetup {
    [self.navigationController setNavigationBarHidden:false];
    self.navigationItem.hidesBackButton = true;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]                                                       forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight < 603) {
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 603);
    }
    
    _btnSignin.layer.borderWidth = 1;
    _btnSignin.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnSignin.layer.cornerRadius = 20;
    
    _viewAlert.layer.cornerRadius = 25;
    _viewAlert.layer.masksToBounds = YES;
    _viewAlert.layer.borderColor = [[UIColor whiteColor] CGColor];
    _viewAlert.layer.borderWidth = 2;
}

- (void)signin {
    NSString *strMessage = @"";
    bool bFill = true;

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
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:_textfieldEmail.text forKey:@"email"];
    [userInfo setObject:_textfieldPassword.text forKey:@"password"];
    
    if (appController.deviceToken == nil) {
        appController.deviceToken = @"";
    }
    
    [userInfo setObject:appController.deviceToken forKey:@"device_token"];
    [userInfo setObject:@"ios" forKey:@"device"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestSignin:userInfo];
    });
}

#pragma mark - IBActions
- (IBAction)OnKeepSignin:(id)sender {
    if (_swiftchSignin.isOn == YES) {
        isKeepSignin = true;
    }
    else {
        isKeepSignin = false;
    }
}

- (IBAction)OnShowPassword:(id)sender {
    if (_switchShowPassword.isOn) {
        [_textfieldPassword setSecureTextEntry:NO];
    }
    else {
        [_textfieldPassword setSecureTextEntry:YES];
    }
}

- (IBAction)OnSendForgot:(id)sender {
    if ([_textfieldForgotEmail.text isEqualToString:@""]) {
        [commonUtils showAlert:@"Forgot Password" withMessage:@"Input Email address" view:self];
        return;
    }
    if (![commonUtils validateEmail:_textfieldForgotEmail.text]) {
        [commonUtils showAlert:@"Forgot Password" withMessage:@"Please input valid Email Address" view:self];
        return;
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:_textfieldEmail.text forKey:@"email"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestForgotPassword:userInfo];
    });
}

- (IBAction)OnCancelForgot:(id)sender {
    [self.view endEditing:YES];
    [_viewAlertBack setHidden: YES];
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnForgotPassword:(id)sender {
    _textfieldForgotEmail.text = @"";
    [_textfieldForgotEmail becomeFirstResponder];
    [_viewAlertBack setHidden: NO];

}

- (IBAction)OnSignin:(id)sender {
    [self signin];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            [_lblEmailPlaceholder setHidden:YES];
            break;
        case 2:
            [_lblPasswordPlaceholder setHidden:YES];
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
                [_lblEmailPlaceholder setHidden:NO];
            }
            break;
        case 2:
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
    else {
        [self signin];
    }
    return YES;
}

#pragma mark - Request API
- (void) requestSignin:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_LOGIN withJSON:(NSMutableDictionary *) params];
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

- (void) requestForgotPassword:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_FORGOT_PASSWORD withJSON:(NSMutableDictionary *) params];
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
            
            [commonUtils setUserDefault:@"isLoggedin" withFormat:@"1"];
            
            HomeViewController* homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
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
