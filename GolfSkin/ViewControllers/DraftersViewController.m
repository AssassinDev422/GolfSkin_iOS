//
//  ActiveDraftViewController.m
//  GolfSkin
//
//  Created by scs on 6/19/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "DraftersViewController.h"
#import "GroupTableViewCell.h"
#import "SWRevealViewController.h"
#import "ActiveTableViewCell.h"
#import "DraftDetailViewController.h"
#import "AllDraftersTableViewCell.h"
#import "AllDraftersViewController.h"
#import "MessageViewController.h"
#import "DemoMessagesViewController.h"

@interface DraftersViewController ()<AllDraftersTableViewDelegate, DraftersVCDelegate, UITextFieldDelegate>
{
    
    NSMutableArray *arrDrafters;
    bool isEditing;
}

@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;

@end

@implementation DraftersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self menuSetup];
    
    isEditing = NO;
    
    arrDrafters = [_dicDraft objectForKey:@"drafter_array"];
    
    _constraintTableHeight.constant = [arrDrafters count] * 50 + 35;
    CGFloat totalHeight = _constraintTableHeight.constant + 142 + 85 + 100;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height - 64;
    if (totalHeight < screenHeight) {
        totalHeight = screenHeight;
    }
    _constraintTotalHeight.constant = totalHeight;
    
    _lblEvent.layer.borderColor = [[UIColor whiteColor] CGColor];
    _lblEvent.layer.borderWidth = 1;
    _lblEvent.layer.cornerRadius = 17;
    
    _lblMoreinfo.layer.borderColor = [[UIColor whiteColor] CGColor];
    _lblMoreinfo.layer.borderWidth = 1;
    _lblMoreinfo.layer.cornerRadius = 17;
    
    _lblDate.layer.borderColor = [[UIColor whiteColor] CGColor];
    _lblDate.layer.borderWidth = 1;
    _lblDate.layer.cornerRadius = 17;
    
    _tblDrafters.layer.cornerRadius = 10;
    _tblDrafters.layer.borderWidth = 1;
    _tblDrafters.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:231.0/255.0] CGColor];
    _tblDrafters.delegate = self;
    _tblDrafters.dataSource = self;
    
    self.navigationItem.title = [_dicDraft objectForKey:@"draftee_label"];

}

- (void)viewDidAppear:(BOOL)animated {
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _constraintTotalHeight.constant);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuSetup {
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
    
}

- (void)refreshContent {
    _constraintTableHeight.constant = [arrDrafters count] * 50 + 35;
    CGFloat totalHeight = _constraintTableHeight.constant + 142 + 85 + 100;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height - 64;
    if (totalHeight < screenHeight) {
        totalHeight = screenHeight;
    }
    _constraintTotalHeight.constant = totalHeight;
    
    [_tblDrafters reloadData];
}

- (void)setDrafterlist: (NSMutableArray*)array_drafters {
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:[_dicDraft objectForKey:@"id"] forKey:@"draft_id"];
    
    NSString *strDrafters = @"";
    strDrafters = [array_drafters componentsJoinedByString:@"|"];
    [userInfo setObject:strDrafters forKey:@"drafters"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestEditDrafters: userInfo];
    });
}


#pragma mark - SwipeableCellDelegate

- (void)OnHide:(int)nIndex {
    
    NSString *strId = [[arrDrafters objectAtIndex:nIndex] objectForKey:@"id"];
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:@"drafter" forKey:@"item"];
    [userInfo setObject:strId forKey:@"item_id"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestDeleteItem: userInfo];
    });
    
    [arrDrafters removeObjectAtIndex:nIndex];
    [self refreshContent];

}

- (void)cellDidOpen:(UITableViewCell *)cell {
    NSIndexPath *currentEditingIndexPath = [self.tblDrafters indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidClose:(UITableViewCell *)cell {
    [self.cellsCurrentlyEditing removeObject:[self.tblDrafters indexPathForCell:cell]];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrDrafters.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllDraftersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllDraftersTableViewCell"];
    NSDictionary *drafter =  [arrDrafters objectAtIndex: indexPath.row];
    cell.lblDraftee.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.lblDrafter.text = [drafter objectForKey:@"name"];
    
    if ([[drafter objectForKey:@"invitation"] intValue] == 0) {
        cell.myContentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];
    }
    else {
        cell.myContentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.nIndex = (int)indexPath.row;
    cell.delegate = self;
    
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *drafter =  [arrDrafters objectAtIndex: indexPath.row];
//    DemoMessagesViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoMessagesViewController"];
//    [self.navigationController pushViewController:messageVC animated:YES];
    
    MessageViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    messageVC.receipt_id = [drafter objectForKey:@"user_id"];
    [self.navigationController pushViewController:messageVC animated:YES];

}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (IBAction)OnNewDrafter:(id)sender {
    AllDraftersViewController *drafterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AllDraftersViewController"];
    drafterVC.strNavigateFrom = @"drafters";
    drafterVC.draftersVC = self;
    drafterVC.arrSelected = [_dicDraft objectForKey:@"drafters"];
    drafterVC.draftersVCDelegate = self;
    
    [self.navigationController pushViewController:drafterVC animated:YES];
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request API
- (void) requestEditDrafters:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_EDIT_DRAFTERS withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
            
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
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
            isEditing = NO;
            
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
            [self.tblDrafters reloadData];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        [self.tblDrafters reloadData];
    }
}

@end
