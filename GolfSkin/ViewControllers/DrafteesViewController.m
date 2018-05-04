//
//  DraftsViewController.m
//  GolfSkin
//
//  Created by scs on 6/19/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "DrafteesViewController.h"
#import "SWRevealViewController.h"
#import "ViewDraftViewController.h"
#import "CreateDraftViewController.h"
#import "EditDraftViewController.h"
#import "AllDraftersTableViewCell.h"
#import "DraftDetailViewController.h"
#import "VSDropdown.h"

@interface DrafteesViewController ()<AllDraftersTableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray *arrDraftee;
    NSMutableArray *arrSearchResult;
    NSMutableArray *arrEventTypes;
    bool isEditing;
    bool isFilterAll;
    int nTypeIndex;
}
@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;

@end

@implementation DrafteesViewController
@synthesize createdraftVCDelegate;
@synthesize editdraftVCDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self menuSetup];
    
    isEditing = NO;
    isFilterAll = YES;
    
    if (_arrSelected == nil) {
        _arrSelected = [[NSMutableArray alloc] init];
    }
    
    [self uiSetup];
    [self getDraftees];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Functions
- (void)uiSetup {
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
    
    nTypeIndex = -1;
    
    _btnCancel.layer.cornerRadius = 5;
    
    _viewConfirm.layer.cornerRadius = 20;
    _viewConfirm.layer.masksToBounds = YES;

   
    _tblDraftee.delegate = self;
    _tblDraftee.dataSource = self;
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.viewConfirmDark addGestureRecognizer:singleFingerTap];

}

- (void)getDraftees {
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestGetDraftees: userInfo];
    });
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [_viewConfirmBack setHidden:YES];
}

- (void)menuSetup {
    if (self.revealViewController != nil) {
        _btnItemMenu.target = self.revealViewController;
        [_btnItemMenu setAction:@selector( revealToggle: )];
        //        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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

- (void)saveNewDraftee {
    UITextField *textfielname = (UITextField*)[self.tblDraftee viewWithTag:101];
    if ([textfielname.text isEqualToString:@""]) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Draftee"
                                     message:@"New Event name can't be empty!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* doneButton = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         [textfielname becomeFirstResponder];
                                     }];
        
        [alert addAction:doneButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (nTypeIndex == -1) {
        _constraintPickerBottom.constant = 0;
    }
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:textfielname.text forKey:@"draftee_name"];
    [userInfo setObject:[[arrEventTypes objectAtIndex: nTypeIndex] objectForKey:@"id"] forKey:@"event_type"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestAddDraftee: userInfo];
    });
}

- (void)OnDropdown:(id)sender {
    _constraintPickerBottom.constant = 0;
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
    NSMutableDictionary *dicDraftee = [arrSearchResult objectAtIndex:indexPath.row];
    cell.lblName.text = [dicDraftee objectForKey:@"draftee_name"];
    cell.lblEventType.text = [[arrSearchResult objectAtIndex:indexPath.row] objectForKey:@"event_type_name"];
    cell.nIndex = (int)indexPath.row;
    cell.delegate = self;
    
    bool isSelected = false;
    for (NSString *strID in _arrSelected) {
        if ([strID isEqualToString: [dicDraftee objectForKey:@"id"]]) {
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
        cell.textfieldNewItem.delegate = self;
        [cell.btnEventType setHidden:NO];
        [cell.btnEventType addTarget:self action:@selector(OnDropdown:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnEventType.tag = 100;
        cell.textfieldNewItem.tag = 101;
        [cell.lblName setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
        [cell.lblEventType setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
        [cell.textfieldNewItem becomeFirstResponder];
    }
    else {
        [cell.textfieldNewItem setHidden:YES];
        [cell.btnEventType setHidden:YES];
        [cell.lblName setBackgroundColor:[UIColor clearColor]];
        [cell.lblEventType setBackgroundColor:[UIColor clearColor]];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_strNavigateFrom isEqualToString:@"create_draft"] || [_strNavigateFrom isEqualToString:@"edit_draft"]) {
        NSString *strDrafteeID = [[arrSearchResult objectAtIndex:indexPath.row] objectForKey:@"id"];
        if ([_arrSelected indexOfObjectIdenticalTo:strDrafteeID] == NSNotFound) {
            [_arrSelected addObject:strDrafteeID];
        }
        else {
            [_arrSelected removeObject:strDrafteeID];
        }
        [_tblDraftee reloadData];
    }
}


#pragma mark - SwipeableCellDelegate

- (void)OnHide:(int)nIndex {
    NSString *strId = [[arrDraftee objectAtIndex:nIndex] objectForKey:@"id"];
    [arrSearchResult removeObjectAtIndex:nIndex];
    [_tblDraftee reloadData];
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:@"draftee" forKey:@"item"];
    [userInfo setObject:strId forKey:@"item_id"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestDeleteItem: userInfo];
    });
    
}

- (void)cellDidOpen:(UITableViewCell *)cell {
    NSIndexPath *currentEditingIndexPath = [self.tblDraftee indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidClose:(UITableViewCell *)cell {
    [self.cellsCurrentlyEditing removeObject:[self.tblDraftee indexPathForCell:cell]];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    return;
    if (textField.tag == 1) {
        return;
    }
    if (!isEditing) {
        return;
    }
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Draftee"
                                 message:@"Are you sure to save new Event?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self saveNewDraftee];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [arrSearchResult removeObjectAtIndex:[arrSearchResult count] - 1];
                                   [self.tblDraftee reloadData];
                                   isEditing = NO;
                               }];
    
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [textField becomeFirstResponder];
                                   }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        return YES;
    }
    [self saveNewDraftee];
    return YES;
}

#pragma mark - IBActions

- (IBAction)OnGetTurn:(id)sender {
}

- (IBAction)OnBack:(id)sender {
    if ([_strNavigateFrom isEqualToString:@"create_draft"]) {
        [createdraftVCDelegate setDrafteelist:_arrSelected];
    }
    if ([_strNavigateFrom isEqualToString:@"edit_draft"]) {
        [editdraftVCDelegate setDrafteelist:_arrSelected];
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
    [dicNewEvent setObject:@"" forKey:@"draftee_name"];
    [dicNewEvent setObject:strUserid forKey:@"user_id"];
    [arrSearchResult addObject:dicNewEvent];
    [_tblDraftee reloadData];
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
        arrSearchResult = [arrDraftee mutableCopy];
        [_tblDraftee reloadData];
        return;
    }
    
    for (NSMutableDictionary *dicEvent in arrDraftee) {
        NSString *strEventName = [dicEvent objectForKey:@"draftee_name"];
        if ([strEventName containsString:strSearch]) {
            [arrSearchResult addObject:dicEvent];
        }
    }
    
    [_tblDraftee reloadData];
}

- (IBAction)OnHidePicker:(id)sender {
    _constraintPickerBottom.constant = -220;
}

- (IBAction)OnSend:(id)sender {
    [self saveNewDraftee];
}

#pragma mark - Request API
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;//Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [arrEventTypes count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[arrEventTypes objectAtIndex:row] objectForKey:@"event_type"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    UIButton *btnEventType = (UIButton*)[self.tblDraftee viewWithTag:100];
    nTypeIndex = (int)row;
    [btnEventType setTitle:[[arrEventTypes objectAtIndex:row] objectForKey:@"event_type"] forState:UIControlStateNormal];
}

#pragma mark - Request API
- (void) requestGetDraftees:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_GET_ALL_DRAFTEES withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            arrDraftee = [[result objectForKey:@"data"] objectForKey:@"draftees"];
            arrEventTypes = [[result objectForKey:@"data"] objectForKey:@"event_types"];
            arrSearchResult = [arrDraftee mutableCopy];
            [_tblDraftee reloadData];
            [_pickerView reloadAllComponents];
            
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestAddDraftee:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_CREATE_DRAFTEE withJSON:(NSMutableDictionary *) params];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            isEditing = NO;
            arrDraftee = [[result objectForKey:@"data"] objectForKey:@"draftees"];
            arrEventTypes = [[result objectForKey:@"data"] objectForKey:@"event_types"];

            arrSearchResult = [arrDraftee mutableCopy];
            [_tblDraftee reloadData];
            [_pickerView reloadAllComponents];
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
            [self.tblDraftee reloadData];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        [self.tblDraftee reloadData];
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
            [self.tblDraftee reloadData];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        [self.tblDraftee reloadData];
    }
}

@end
