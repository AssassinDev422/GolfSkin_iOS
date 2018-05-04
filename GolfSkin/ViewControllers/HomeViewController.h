//
//  HomeViewController.h
//  GolfSkin
//
//  Created by scs on 6/10/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnItemMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnActiveDraft;
@property (strong, nonatomic) IBOutlet UIButton *btnPendingInvite;
@property (strong, nonatomic) IBOutlet UIButton *btnDraft;


@property (nonatomic) bool isFirst;

- (IBAction)OnActiveDraft:(id)sender;
- (IBAction)OnInviteDraft:(id)sender;
@end
