//
//  HomeViewController.m
//  GolfSkin
//
//  Created by scs on 6/10/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "HomeViewController.h"
#import "DraftsViewController.h"
#import "SWRevealViewController.h"
#import "DraftDetailViewController.h"

@interface HomeViewController ()
{
    int nActive;
    int nInvite;
    
    NSMutableArray *arrActive;
    NSMutableArray *arrInvite;
    NSMutableArray *arrWaiting;
    NSMutableArray *arrNotStarted;
    NSMutableArray *arrCompleted;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self menuSetup];
    
    nActive = 0;
    nInvite = 0;
    
    _btnActiveDraft.layer.cornerRadius = 20;
    _btnActiveDraft.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnActiveDraft.layer.borderWidth = 1;
    
    _btnPendingInvite.layer.cornerRadius = 20;
    _btnPendingInvite.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnPendingInvite.layer.borderWidth = 1;
    
    _btnDraft.layer.cornerRadius = 20;
    _btnDraft.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnDraft.layer.borderWidth = 1;
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestGetMyDrafts: userInfo];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)menuSetup {
    if (self.revealViewController != nil) {
        _btnItemMenu.target = self.revealViewController;
        [_btnItemMenu setAction:@selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        
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


- (IBAction)OnActiveDraft:(id)sender {
    DraftDetailViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftDetailViewController"];
    detailVC.dicDraft = [arrActive objectAtIndex:0];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)OnInviteDraft:(id)sender {
    DraftsViewController* draftsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftsViewController"];
    [self.navigationController pushViewController: draftsVC animated:YES];
}

#pragma mark - Request API
- (void) requestGetMyDrafts:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_GET_MYDRAFTS withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 0) {
            
            NSMutableDictionary *dicDrafts = [result objectForKey:@"data"];
            
            arrActive = [dicDrafts objectForKey:@"Active"];
            arrInvite = [dicDrafts objectForKey:@"Invite"];
            arrWaiting = [dicDrafts objectForKey:@"Pending"];
            arrNotStarted = [dicDrafts objectForKey:@"Notstarted"];
            arrCompleted = [dicDrafts objectForKey:@"Completed"];

            nActive = (int)arrActive.count;
            nInvite = (int)arrInvite.count;

            if (nActive == 0) {
                [_btnActiveDraft setTitle:@"No Active Draft" forState:UIControlStateNormal];
            }
            else {
                [_btnActiveDraft setTitle:[NSString stringWithFormat:@"%d Active Draft(s)", nActive] forState:UIControlStateNormal];
                
                if (_isFirst) {
                    DraftDetailViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftDetailViewController"];
                    detailVC.dicDraft = [arrActive objectAtIndex:0];
                    [self.navigationController pushViewController:detailVC animated:YES];
                    return;
                }
                
            }

            if (nInvite == 0) {
                [_btnPendingInvite setTitle:@"No Pending Draft Invite" forState:UIControlStateNormal];
            }
            else {
                [_btnPendingInvite setTitle:[NSString stringWithFormat:@"%d Pending Draft Invite(s)", nInvite] forState:UIControlStateNormal];
                
                if (_isFirst) {
                    DraftsViewController* draftsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftsViewController"];
                    [self.navigationController pushViewController: draftsVC animated:YES];
                }
                
            }

        } else {
            [commonUtils showAlert: nil withMessage:[result objectForKey:@"msg"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}
@end
