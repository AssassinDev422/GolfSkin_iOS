//
//  FirstViewController.m
//  GolfSkin
//
//  Created by scs on 6/10/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "FirstViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "SWRevealViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _btnSignin.layer.borderWidth = 1;
    _btnSignin.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnSignin.layer.cornerRadius = 20;
    _btnSignup.layer.borderWidth = 1;
    _btnSignup.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnSignup.layer.cornerRadius = 20;
    
    if ([commonUtils isLoggedin]) {
        appController.dicUserInfo = [commonUtils getUserDefaultDicByKey:@"user_info"];
        HomeViewController* homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        homeVC.isFirst = true;
        UINavigationController *frontVCNavigate = [[UINavigationController alloc]initWithRootViewController:homeVC];
        SWRevealViewController* mainRevealController = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        mainRevealController.frontViewController = frontVCNavigate;
        [self.navigationController pushViewController:mainRevealController animated:YES];
    }
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

- (IBAction)OnSignIn:(id)sender {
    
    LoginViewController* loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)OnCreate:(id)sender {
    SignupViewController* loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}
@end
