//
//  DraftsViewController.m
//  GolfSkin
//
//  Created by scs on 6/19/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "AllDraftersViewController.h"
#import "SWRevealViewController.h"
#import "DraftDetailViewController.h"
#import "ViewDraftViewController.h"
#import "CreateDraftViewController.h"
#import "EditDraftViewController.h"
#import "AllDraftersTableViewCell.h"

@interface AllDraftersViewController ()<AllDraftersTableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *arrDrafters;
    NSMutableArray *arrSearchResult;
    bool isEditing;
    bool isFilterAll;
}
@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;

@end

@implementation AllDraftersViewController
@synthesize createdraftVCDelegate;
@synthesize editdraftVCDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_arrSelected == nil) {
        _arrSelected = [[NSMutableArray alloc] init];
    }

    [self uiSetup];
    [self getDrafters];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uiSetup {
    _btnCancel.layer.cornerRadius = 5;
    
    _viewConfirm.layer.cornerRadius = 20;
    _viewConfirm.layer.masksToBounds = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.viewConfirmDark addGestureRecognizer:singleFingerTap];
    
    _tblDrafters.delegate = self;
    _tblDrafters.dataSource = self;
    
    [self menuSetup];
    
    
    isEditing = NO;
    isFilterAll = YES;
    
    if (isFilterAll) {
        [_imageFilterAll setImage:[UIImage imageNamed:@"icon_checked.png"]];
        [_imageFilterCreated setImage:[UIImage  imageNamed:@"icon_unchecked.png"]];
    }
    else {
        [_imageFilterAll setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
        [_imageFilterCreated setImage:[UIImage  imageNamed:@"icon_checked.png"]];
    }
    
    _viewFilterBack.layer.cornerRadius = 5;
    _viewFilterBack.layer.masksToBounds = YES;
}

- (void)getDrafters {
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestGetAllDrafters: userInfo];
    });
}

#pragma mark - Custom Functions

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [_viewConfirmBack setHidden:YES];
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
    }
}

- (void)saveNewEvent {
    UITextField *textfieldName = (UITextField*)[self.tblDrafters viewWithTag:100];
    UITextField *textfieldEmail = (UITextField*)[self.tblDrafters viewWithTag:101];
    if ([textfieldName.text isEqualToString:@""]) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:@"Fill Drafter Name."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* doneButton = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         [textfieldName becomeFirstResponder];
                                     }];
        
        [alert addAction:doneButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([textfieldEmail.text isEqualToString:@""]) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:@"Fill Email Address."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* doneButton = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         [textfieldEmail becomeFirstResponder];
                                     }];
        
        [alert addAction:doneButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }


    if (isEditing) {
        appController.strUserId = [commonUtils getUserDefault:@"user_id"];
        appController.strToken = [commonUtils getUserDefault:@"token"];
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:appController.strUserId forKey:@"user_id"];
        [userInfo setObject:appController.strToken forKey:@"token"];
        [userInfo setObject:textfieldName.text forKey:@"name"];
        [userInfo setObject:textfieldEmail.text forKey:@"email"];
        
        [commonUtils showActivityIndicator:self.view];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (appController.isLoading) return;
            appController.isLoading = YES;
            
            [self requestAddDrafter: userInfo];
        });
    }
    
}

#pragma mark - UITableViewDelegate, UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrSearchResult.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllDraftersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllDraftersTableViewCell"];
    NSMutableDictionary *dicDrafter = [arrSearchResult objectAtIndex:indexPath.row];
    cell.lblName.text = [dicDrafter objectForKey:@"name"];
    
    if ([[dicDrafter objectForKey:@"is_displayemail"] intValue] == 1) {
        cell.lblEmail.text = [dicDrafter objectForKey:@"email"];
    }
    else {
        cell.lblEmail.text = @"";
    }
    
    cell.nIndex = (int)indexPath.row;
    cell.delegate = self;
    
    bool isSelected = false;
    for (NSString *strID in _arrSelected) {
        if ([strID isEqualToString: [dicDrafter objectForKey:@"id"]]) {
            [cell.viewBackground setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
            isSelected = true;
            break;
        }
    }
    if (!isSelected) {
        [cell.viewBackground setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.1]];
    }
    
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }

    
    if (isEditing && indexPath.row == [arrSearchResult count] - 1) {
        [cell.textfieldNewItem setHidden:NO];
        [cell.textfieldNewEmail setHidden:NO];
        cell.textfieldNewItem.delegate = self;
        cell.textfieldNewEmail.delegate = self;
        [cell.lblName setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
        [cell.lblEmail setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
        cell.textfieldNewItem.tag = 100;
        cell.textfieldNewEmail.tag = 101;
        [cell.textfieldNewItem becomeFirstResponder];
    }
    else {
        [cell.textfieldNewItem setHidden:YES];
        [cell.textfieldNewEmail setHidden:YES];
        [cell.lblName setBackgroundColor:[UIColor clearColor]];
        [cell.lblEmail setBackgroundColor:[UIColor clearColor]];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_strNavigateFrom isEqualToString:@"create_draft"] || [_strNavigateFrom isEqualToString:@"edit_draft"] || [_strNavigateFrom isEqualToString:@"drafters"]) {
        NSString *strDrafterID = [[arrSearchResult objectAtIndex:indexPath.row] objectForKey:@"id"];
        if ([_arrSelected indexOfObjectIdenticalTo:strDrafterID] == NSNotFound) {
            [_arrSelected addObject:strDrafterID];
        }
        else {
            [_arrSelected removeObject:strDrafterID];
        }
        [_tblDrafters reloadData];
    }
    
}


#pragma mark - SwipeableCellDelegate

- (void)OnHide:(int)nIndex {
    NSString *strId = [[arrSearchResult objectAtIndex:nIndex] objectForKey:@"id"];
    [arrSearchResult removeObjectAtIndex:nIndex];
    [_tblDrafters reloadData];
    
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
}

- (void)cellDidOpen:(UITableViewCell *)cell {
    NSIndexPath *currentEditingIndexPath = [self.tblDrafters indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidClose:(UITableViewCell *)cell {
    [self.cellsCurrentlyEditing removeObject:[self.tblDrafters indexPathForCell:cell]];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.tag == 1) {
//        return;
//    }
//    if (!isEditingEmail && !isEditingName) {
//        return;
//    }
//    if (isEditingEmail && textField.tag == 100) {
//        return;
//    }
//    if (isEditingName && textField.tag == 101) {
//        return;
//    }
//    
//    UIAlertController * alert = [UIAlertController
//                                 alertControllerWithTitle:@"Drafters"
//                                 message:@"Are you sure to save new Drafter?"
//                                 preferredStyle:UIAlertControllerStyleAlert];
//    
//    
//    
//    UIAlertAction* yesButton = [UIAlertAction
//                                actionWithTitle:@"Yes"
//                                style:UIAlertActionStyleDefault
//                                handler:^(UIAlertAction * action) {
//                                    [self saveNewEvent:textField];
//                                }];
//    
//    UIAlertAction* noButton = [UIAlertAction
//                               actionWithTitle:@"No"
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction * action) {
//                                   [arrSearchResult removeObjectAtIndex:[arrSearchResult count] - 1];
//                                   [self.tblDrafters reloadData];
//                                   if (isEditingName) {
//                                       isEditingName = NO;
//                                   }
//                                   else {
//                                       isEditingEmail = NO;
//                                   }
//                                   
//                               }];
//    
//    UIAlertAction* cancelButton = [UIAlertAction
//                                   actionWithTitle:@"Cancel"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction * action) {
//                                       [textField becomeFirstResponder];
//                                   }];
//    
//    [alert addAction:yesButton];
//    [alert addAction:noButton];
//    [alert addAction:cancelButton];
//    
//    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        return YES;
    }
    [self saveNewEvent];
    return YES;
}

#pragma mark - IBActions

- (IBAction)OnGetTurn:(id)sender {
}

- (IBAction)OnBack:(id)sender {
    if ([_strNavigateFrom isEqualToString:@"create_draft"]) {
        [createdraftVCDelegate setDrafterlist:_arrSelected];
    }
    if ([_strNavigateFrom isEqualToString:@"edit_draft"]) {
        [editdraftVCDelegate setDrafterlist:_arrSelected];
    }
    if ([_strNavigateFrom isEqualToString:@"drafters"]) {
        [_draftersVCDelegate setDrafterlist:_arrSelected];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnAccept:(id)sender {
    [_viewConfirmBack setHidden:YES];
    DraftDetailViewController* activeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftDetailViewController"];
    [self.navigationController pushViewController: activeVC animated:YES];
}

- (IBAction)OnViewDraft:(id)sender {
    [_viewConfirmBack setHidden:YES];
    ViewDraftViewController* activeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewDraftViewController"];
    [self.navigationController pushViewController: activeVC animated:YES];
}

- (IBAction)OnAdd:(id)sender {
    if (isEditing) {
        return;
    }
    isEditing = YES;
    NSString *strUserid = [commonUtils getUserDefault:@"user_id"];
    NSMutableDictionary *dicNewEvent = [[NSMutableDictionary alloc] init];
    [dicNewEvent setObject:@"" forKey:@"name"];
    [dicNewEvent setObject:@"" forKey:@"email"];
    [dicNewEvent setObject:strUserid forKey:@"user_id"];
    [arrSearchResult addObject:dicNewEvent];
    [_tblDrafters reloadData];
}

- (IBAction)OnFilter:(id)sender {
    [_viewFilter setHidden:YES];
    if (_viewFilter.isHidden == NO) {
        [_viewFilter setHidden:YES];
        return;
    }
    [_viewFilter setHidden:NO];
}

- (IBAction)OnFilterCreated:(id)sender {
    [_viewFilter setHidden:YES];
    if (!isFilterAll) {
        return;
    }
    isFilterAll = NO;
    [_imageFilterCreated setImage:[UIImage imageNamed:@"icon_checked.png"]];
    [_imageFilterAll setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
}

- (IBAction)OnFilterAll:(id)sender {
    [_viewFilter setHidden:YES];
    if (isFilterAll) {
        return;
    }
    isFilterAll = YES;
    [_imageFilterAll setImage:[UIImage imageNamed:@"icon_checked.png"]];
    [_imageFilterCreated setImage:[UIImage  imageNamed:@"icon_unchecked.png"]];
}

- (IBAction)OnSearchChange:(id)sender {
    NSString *strSearch = _textfieldSearch.text;
    [arrSearchResult removeAllObjects];
    
    if ([strSearch isEqualToString:@""]) {
        arrSearchResult = [arrDrafters mutableCopy];
        [_tblDrafters reloadData];
        return;
    }
    
    for (NSMutableDictionary *dicEvent in arrDrafters) {
        NSString *strName = [dicEvent objectForKey:@"name"];
        NSString *strEmail = [dicEvent objectForKey:@"email"];
        if ([strName containsString:strSearch]) {
            [arrSearchResult addObject:dicEvent];
        }
        else if ([strEmail containsString:strSearch]) {
            [arrSearchResult addObject:dicEvent];
        }
    }
    
    [_tblDrafters reloadData];
}



#pragma mark - Request API
- (void) requestGetAllDrafters:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_GET_ALL_DRAFTERS withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            arrDrafters = [result objectForKey:@"data"];
            arrSearchResult = [arrDrafters mutableCopy];
            [_tblDrafters reloadData];
            
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestAddDrafter:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_CREATE_DRAFTER withJSON:(NSMutableDictionary *) params];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            isEditing = NO;
            [arrSearchResult replaceObjectAtIndex:[arrSearchResult count] - 1 withObject:[result objectForKey:@"data"]];
            [_tblDrafters reloadData];
        } else if([status intValue] == 2) {
            isEditing = NO;
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
            [arrSearchResult replaceObjectAtIndex:[arrSearchResult count] - 1 withObject:[result objectForKey:@"data"]];
            [self.tblDrafters reloadData];
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
        }
        
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        [self.tblDrafters reloadData];
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
