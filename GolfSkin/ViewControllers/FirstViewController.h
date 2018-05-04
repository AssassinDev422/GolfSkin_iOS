//
//  FirstViewController.h
//  GolfSkin
//
//  Created by scs on 6/10/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *btnSignin;
@property (strong, nonatomic) IBOutlet UIButton *btnSignup;

- (IBAction)OnSignIn:(id)sender;
- (IBAction)OnCreate:(id)sender;
@end
