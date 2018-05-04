//
//  DraftsViewController.m
//  GolfSkin
//
//  Created by scs on 6/19/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "DraftsViewController.h"
#import "DraftsTableViewCell.h"
#import "SWRevealViewController.h"
#import "DraftDetailViewController.h"
#import "ViewDraftViewController.h"
#import "CreateDraftViewController.h"
#import "EditDraftViewController.h"

@interface DraftsViewController ()<DraftsTableViewDelegate>
{
    NSMutableArray *arrActive;
    NSMutableArray *arrInvite;
    NSMutableArray *arrWaiting;
    NSMutableArray *arrNotStarted;
    NSMutableArray *arrCompleted;
    
    int nSelectedTable;
    int nSelectedRow;
}
@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;

@end

@implementation DraftsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _btnHome.layer.cornerRadius = 5;
    
    
//
//    arrActive = [NSMutableArray arrayWithObjects:
//               @"Home",
//               @"Drafts",
//               @"Create Draft",
//            nil];
//    arrInvite = [NSMutableArray arrayWithObjects:
//               @"Home",
//               @"Drafts",
//               nil];
//    arrWaiting = [NSMutableArray arrayWithObjects:
//               @"Home",
//               nil];
//    arrNotStarted = [NSMutableArray arrayWithObjects:
//               @"Home",
//               nil];
//    arrCompleted = [NSMutableArray arrayWithObjects:
//               @"Home",
//               @"Drafts",
//               nil];
//    
    
    [self uiSetup];
    [self menuSetup];
    
}

- (void)viewDidAppear:(BOOL)animated {
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _constraintTotalHeight.constant);
    
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

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [_viewConfirmBack setHidden:YES];
}

- (void)uiSetup {
    _viewConfirm.layer.cornerRadius = 20;
    _viewConfirm.layer.masksToBounds = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.viewConfirmDark addGestureRecognizer:singleFingerTap];
    
    _tblActive.layer.borderWidth = 1;
    _tblActive.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:231.0/255.0] CGColor];
    _tblActive.layer.cornerRadius = 10;
    
    _tblInvite.layer.borderWidth = 1;
    _tblInvite.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:231.0/255.0] CGColor];
    _tblInvite.layer.cornerRadius = 10;
    
    _tblWaiting.layer.borderWidth = 1;
    _tblWaiting.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:231.0/255.0] CGColor];
    _tblWaiting.layer.cornerRadius = 10;
    
    _tblNotstarted.layer.borderWidth = 1;
    _tblNotstarted.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:231.0/255.0] CGColor];
    _tblNotstarted.layer.cornerRadius = 10;
    
    _tblCompleted.layer.borderWidth = 1;
    _tblCompleted.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:231.0/255.0] CGColor];
    _tblCompleted.layer.cornerRadius = 10;
    
    
    _constraintActiveHeight.constant = 75 * arrActive.count + 35;
    _constraintInviteHeight.constant = 75 * arrInvite.count + 35;
    _constraintWaitingHeight.constant = 75 * arrWaiting.count + 35;
    _constraintNotStartedHeight.constant = 75 * arrNotStarted.count + 35;
    _constraintCompletedHeight.constant = 75 * arrCompleted.count + 35;
    _constraintTotalHeight.constant = _constraintActiveHeight.constant + _constraintInviteHeight.constant + _constraintWaitingHeight.constant + _constraintNotStartedHeight.constant + _constraintCompletedHeight.constant + 300;
    
    _viewConfirm.layer.cornerRadius = 25;
    _viewConfirm.layer.masksToBounds = YES;
    _viewConfirm.layer.borderWidth = 2;
    _viewConfirm.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _tblActive.delegate = self;
    _tblActive.dataSource = self;
    _tblInvite.delegate = self;
    _tblInvite.dataSource = self;
    _tblWaiting.delegate = self;
    _tblWaiting.dataSource = self;
    _tblNotstarted.delegate = self;
    _tblNotstarted.dataSource = self;
    _tblCompleted.delegate = self;
    _tblCompleted.dataSource = self;
    
    
}

- (void)menuSetup {
    if (self.revealViewController != nil) {
        _btnItemMenu.target = self.revealViewController;
        [_btnItemMenu setAction:@selector( revealToggle: )];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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
        
        self.navigationController.view.backgroundColor = [UIColor clearColor];
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-120, -60)
                                                             forBarMetrics:UIBarMetricsDefault];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 10) {
        return [arrActive count];
    }
    else if (tableView.tag == 11) {
        return [arrInvite count];
    }
    else if (tableView.tag == 12) {
        return [arrWaiting count];
    }
    else if (tableView.tag == 13) {
        return [arrNotStarted count];
    }
    else if (tableView.tag == 14) {
        return [arrCompleted count];
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DraftsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DraftsTableViewCell"];
    cell.delegate = self;
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
    
    if (tableView.tag == 10) {
        cell.lblDraftName.text = [[arrActive objectAtIndex:indexPath.row] objectForKey:@"draft_name"];
        cell.lblEvent.text = [[arrActive objectAtIndex:indexPath.row] objectForKey:@"event_name"];
        cell.lblMoreInfo.text = [[arrActive objectAtIndex:indexPath.row] objectForKey:@"more_info"];
        cell.lblStartDate.text = [[arrActive objectAtIndex:indexPath.row] objectForKey:@"start_date"];
    }
    else if (tableView.tag == 11) {
        cell.lblDraftName.text = [[arrInvite objectAtIndex:indexPath.row] objectForKey:@"draft_name"];
        cell.lblEvent.text = [[arrInvite objectAtIndex:indexPath.row] objectForKey:@"event_name"];
        cell.lblMoreInfo.text = [[arrInvite objectAtIndex:indexPath.row] objectForKey:@"more_info"];
        cell.lblStartDate.text = [[arrInvite objectAtIndex:indexPath.row] objectForKey:@"start_date"];
    }
    else if (tableView.tag == 12) {
        cell.lblDraftName.text = [[arrWaiting objectAtIndex:indexPath.row] objectForKey:@"draft_name"];
        cell.lblEvent.text = [[arrWaiting objectAtIndex:indexPath.row] objectForKey:@"event_name"];
        cell.lblMoreInfo.text = [[arrWaiting objectAtIndex:indexPath.row] objectForKey:@"more_info"];
        cell.lblStartDate.text = [[arrWaiting objectAtIndex:indexPath.row] objectForKey:@"start_date"];
    }
    else if (tableView.tag == 13) {
        cell.lblDraftName.text = [[arrNotStarted objectAtIndex:indexPath.row] objectForKey:@"draft_name"];
        cell.lblEvent.text = [[arrNotStarted objectAtIndex:indexPath.row] objectForKey:@"event_name"];
        cell.lblMoreInfo.text = [[arrNotStarted objectAtIndex:indexPath.row] objectForKey:@"more_info"];
        cell.lblStartDate.text = [[arrNotStarted objectAtIndex:indexPath.row] objectForKey:@"start_date"];
    }
    else if (tableView.tag == 14) {
        cell.lblDraftName.text = [[arrCompleted objectAtIndex:indexPath.row] objectForKey:@"draft_name"];
        cell.lblEvent.text = [[arrCompleted objectAtIndex:indexPath.row] objectForKey:@"event_name"];
        cell.lblMoreInfo.text = [[arrCompleted objectAtIndex:indexPath.row] objectForKey:@"more_info"];
        cell.lblStartDate.text = [[arrCompleted objectAtIndex:indexPath.row] objectForKey:@"start_date"];
    }
    
    cell.draftType = (int)tableView.tag;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    nSelectedTable = (int)tableView.tag;
    nSelectedRow = (int)indexPath.row;
    
    if (tableView.tag == 10) {
        DraftDetailViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftDetailViewController"];
        detailVC.dicDraft = [arrActive objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (tableView.tag == 11) {
        [_viewConfirmBack setHidden:NO];
    }
    else if (tableView.tag == 12) {
        DraftDetailViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftDetailViewController"];
        detailVC.dicDraft = [arrWaiting objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (tableView.tag == 13) {
        DraftDetailViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftDetailViewController"];
        detailVC.dicDraft = [arrNotStarted objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (tableView.tag == 14) {
        DraftDetailViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftDetailViewController"];
        detailVC.dicDraft = [arrCompleted objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView.tag == 10) {
            [arrActive removeObjectAtIndex:indexPath.row];
        }
        else if (tableView.tag == 11) {
            [arrInvite removeObjectAtIndex:indexPath.row];
        }
        else if (tableView.tag == 12) {
            [arrWaiting removeObjectAtIndex:indexPath.row];
        }
        else if (tableView.tag == 13) {
            [arrNotStarted removeObjectAtIndex:indexPath.row];
        }
        else if (tableView.tag == 14) {
            [arrCompleted removeObjectAtIndex:indexPath.row];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
    }
}


#pragma mark - SwipeableCellDelegate
- (void)OnCreate:(int)nIndex draft_type: (int)draft_type
{
    NSMutableDictionary *dicDraft;
    if (draft_type == 10) {
        dicDraft = [arrActive objectAtIndex:nIndex];
    }
    else if (draft_type == 11) {
        dicDraft = [arrInvite objectAtIndex:nIndex];
    }
    else if (draft_type == 12) {
        dicDraft = [arrWaiting objectAtIndex:nIndex];
    }
    else if (draft_type == 13) {
        dicDraft = [arrNotStarted objectAtIndex:nIndex];
    }
    else if (draft_type == 14) {
        dicDraft = [arrCompleted objectAtIndex:nIndex];
    }
    
    CreateDraftViewController* createVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateDraftViewController"];
    createVC.dicDraft = dicDraft;
    [self.navigationController pushViewController: createVC animated:YES];
}

- (void)OnHide:(int)nIndex draft_type: (int)draft_type
{
    
    NSString *strId = @"";
    if (draft_type == 10) {
        [arrActive removeObjectAtIndex:nIndex];
        strId = [[arrActive objectAtIndex:nIndex] objectForKey:@"id"];

    }
    else if (draft_type == 11) {
        [arrInvite removeObjectAtIndex:nIndex];
        strId = [[arrInvite objectAtIndex:nIndex] objectForKey:@"id"];
    }
    else if (draft_type == 12) {
        [arrWaiting removeObjectAtIndex:nIndex];
        strId = [[arrWaiting objectAtIndex:nIndex] objectForKey:@"id"];
    }
    else if (draft_type == 13) {
        [arrNotStarted removeObjectAtIndex:nIndex];
        strId = [[arrNotStarted objectAtIndex:nIndex] objectForKey:@"id"];
    }
    else if (draft_type == 14) {
        [arrCompleted removeObjectAtIndex:nIndex];
        strId = [[arrCompleted objectAtIndex:nIndex] objectForKey:@"id"];
    }
    
    _constraintActiveHeight.constant = 75 * arrActive.count + 35;
    _constraintInviteHeight.constant = 75 * arrInvite.count + 35;
    _constraintWaitingHeight.constant = 75 * arrWaiting.count + 35;
    _constraintNotStartedHeight.constant = 75 * arrNotStarted.count + 35;
    _constraintCompletedHeight.constant = 75 * arrCompleted.count + 35;
    _constraintTotalHeight.constant = _constraintActiveHeight.constant + _constraintInviteHeight.constant + _constraintWaitingHeight.constant + _constraintNotStartedHeight.constant + _constraintCompletedHeight.constant + 16 * 5 + 85 + 65 + 300;
    
    [_tblActive reloadData];
    [_tblInvite reloadData];
    [_tblWaiting reloadData];
    [_tblNotstarted reloadData];
    [_tblCompleted reloadData];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _constraintTotalHeight.constant)];
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:@"draft" forKey:@"item"];
    [userInfo setObject:strId forKey:@"item_id"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestDeleteItem: userInfo];
    });
}

- (void)OnView:(int)nIndex draft_type: (int)draft_type
{
    NSMutableDictionary *dicDraft;
    if (draft_type == 10) {
        dicDraft = [arrActive objectAtIndex:nIndex];
    }
    else if (draft_type == 11) {
        dicDraft = [arrInvite objectAtIndex:nIndex];
    }
    else if (draft_type == 12) {
        dicDraft = [arrWaiting objectAtIndex:nIndex];
    }
    else if (draft_type == 13) {
        dicDraft = [arrNotStarted objectAtIndex:nIndex];
    }
    else if (draft_type == 14) {
        dicDraft = [arrCompleted objectAtIndex:nIndex];
    }
    
    ViewDraftViewController* viewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewDraftViewController"];
    viewVC.dicDraft = dicDraft;
    [self.navigationController pushViewController: viewVC animated:YES];
}

- (void)OnEdit:(int)nIndex draft_type: (int)draft_type
{
    NSMutableDictionary *dicDraft;
    if (draft_type == 10) {
        dicDraft = [arrActive objectAtIndex:nIndex];
    }
    else if (draft_type == 11) {
        dicDraft = [arrInvite objectAtIndex:nIndex];
    }
    else if (draft_type == 12) {
        dicDraft = [arrWaiting objectAtIndex:nIndex];
    }
    else if (draft_type == 13) {
        dicDraft = [arrNotStarted objectAtIndex:nIndex];
    }
    else if (draft_type == 14) {
        dicDraft = [arrCompleted objectAtIndex:nIndex];
    }
    
    EditDraftViewController* editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDraftViewController"];
    editVC.dicDraft = dicDraft;
    [self.navigationController pushViewController: editVC animated:YES];
}

- (void)cellDidOpen:(UITableViewCell *)cell {
    NSIndexPath *currentEditingIndexPath = 0;
    if (((DraftsTableViewCell*)cell).draftType == 10) {
        [self.tblActive indexPathForCell:cell];
    }
    else if (((DraftsTableViewCell*)cell).draftType == 11) {
        [self.tblInvite indexPathForCell:cell];
    }
    else if (((DraftsTableViewCell*)cell).draftType == 12) {
        [self.tblWaiting indexPathForCell:cell];
    }
    else if (((DraftsTableViewCell*)cell).draftType == 13) {
        [self.tblNotstarted indexPathForCell:cell];
    }
    else if (((DraftsTableViewCell*)cell).draftType == 14) {
        [self.tblCompleted indexPathForCell:cell];
    }
    
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidClose:(UITableViewCell *)cell {
    
    if (((DraftsTableViewCell*)cell).draftType == 10) {
        [self.cellsCurrentlyEditing removeObject:[self.tblActive indexPathForCell:cell]];
    }
    else if (((DraftsTableViewCell*)cell).draftType == 11) {
        [self.cellsCurrentlyEditing removeObject:[self.tblInvite indexPathForCell:cell]];
    }
    else if (((DraftsTableViewCell*)cell).draftType == 12) {
        [self.cellsCurrentlyEditing removeObject:[self.tblWaiting indexPathForCell:cell]];
    }
    else if (((DraftsTableViewCell*)cell).draftType == 13) {
        [self.cellsCurrentlyEditing removeObject:[self.tblNotstarted indexPathForCell:cell]];
    }
    else if (((DraftsTableViewCell*)cell).draftType == 14) {
        [self.cellsCurrentlyEditing removeObject:[self.tblCompleted indexPathForCell:cell]];
    }
    
}

- (IBAction)OnHome:(id)sender {
    SWRevealViewController* mainRevealController = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    mainRevealController = self.revealViewController;
    
    UIViewController* frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    UINavigationController *frontVCNavigate = [[UINavigationController alloc]initWithRootViewController:frontVC];
    [frontVCNavigate setNavigationBarHidden:false];
    
    [mainRevealController pushFrontViewController:frontVCNavigate animated:YES];
}

- (IBAction)OnAccept:(id)sender {
    [_viewConfirmBack setHidden:YES];
    if (nSelectedTable != 11) {
        return;
    }
    
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:[[arrInvite objectAtIndex:nSelectedRow] objectForKey:@"id"] forKey:@"draft_id"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestAcceptInvite: userInfo];
    });
    
//    ActiveDraftViewController* activeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveDraftViewController"];
//    [self.navigationController pushViewController: activeVC animated:YES];
}

- (IBAction)OnViewDraft:(id)sender {
    [_viewConfirmBack setHidden:YES];
    
    NSMutableDictionary *dicDraft = [arrInvite objectAtIndex:nSelectedRow];
    
    ViewDraftViewController* viewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewDraftViewController"];
    viewVC.dicDraft = dicDraft;
    [self.navigationController pushViewController: viewVC animated:YES];
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

            _constraintActiveHeight.constant = 75 * arrActive.count + 35;
            _constraintInviteHeight.constant = 75 * arrInvite.count + 35;
            _constraintWaitingHeight.constant = 75 * arrWaiting.count + 35;
            _constraintNotStartedHeight.constant = 75 * arrNotStarted.count + 35;
            _constraintCompletedHeight.constant = 75 * arrCompleted.count + 35;
            _constraintTotalHeight.constant = _constraintActiveHeight.constant + _constraintInviteHeight.constant + _constraintWaitingHeight.constant + _constraintNotStartedHeight.constant + _constraintCompletedHeight.constant + 16 * 5 + 85 + 65 + 300;
            
            [_tblActive reloadData];
            [_tblInvite reloadData];
            [_tblWaiting reloadData];
            [_tblNotstarted reloadData];
            [_tblCompleted reloadData];
            
            
            [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, _constraintTotalHeight.constant)];

        } else {
            [commonUtils showAlert: nil withMessage:[result objectForKey:@"msg"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestAcceptInvite:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_ACCEPT_INVITE withJSON:(NSMutableDictionary *) params];
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
            
            _constraintActiveHeight.constant = 75 * arrActive.count + 35;
            _constraintInviteHeight.constant = 75 * arrInvite.count + 35;
            _constraintWaitingHeight.constant = 75 * arrWaiting.count + 35;
            _constraintNotStartedHeight.constant = 75 * arrNotStarted.count + 35;
            _constraintCompletedHeight.constant = 75 * arrCompleted.count + 35;
            _constraintTotalHeight.constant = _constraintActiveHeight.constant + _constraintInviteHeight.constant + _constraintWaitingHeight.constant + _constraintNotStartedHeight.constant + _constraintCompletedHeight.constant + 300;
            
            [_tblActive reloadData];
            [_tblInvite reloadData];
            [_tblWaiting reloadData];
            [_tblNotstarted reloadData];
            [_tblCompleted reloadData];
            
            [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _constraintTotalHeight.constant)];
            
        } else {
            [commonUtils showAlert: nil withMessage:[result objectForKey:@"msg"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestDeleteItem:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_DELETE_ITEM withJSON:(NSMutableDictionary *) params];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
    }
}
@end
