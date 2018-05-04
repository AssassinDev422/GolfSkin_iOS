//
//  DraftsViewController.h
//  GolfSkin
//
//  Created by scs on 6/19/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraftsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnItemMenu;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnItemFilter;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btnHome;
@property (strong, nonatomic) IBOutlet UITableView *tblActive;
@property (strong, nonatomic) IBOutlet UITableView *tblInvite;
@property (strong, nonatomic) IBOutlet UITableView *tblWaiting;
@property (strong, nonatomic) IBOutlet UITableView *tblNotstarted;
@property (strong, nonatomic) IBOutlet UITableView *tblCompleted;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintActiveHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintInviteHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintWaitingHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintNotStartedHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintCompletedHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTotalHeight;
@property (strong, nonatomic) IBOutlet UIView *viewConfirmBack;
@property (strong, nonatomic) IBOutlet UIView *viewConfirm;
@property (strong, nonatomic) IBOutlet UIView *viewConfirmDark;
@property (strong, nonatomic) IBOutlet UIView *viewTotal;

- (IBAction)OnHome:(id)sender;
- (IBAction)OnAccept:(id)sender;
- (IBAction)OnViewDraft:(id)sender;
- (IBAction)OnBack:(id)sender;

@end
