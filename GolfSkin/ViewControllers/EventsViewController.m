//
//  DraftsViewController.m
//  GolfSkin
//
//  Created by scs on 6/19/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "EventsViewController.h"
#import "SWRevealViewController.h"
#import "ViewDraftViewController.h"
#import "CreateDraftViewController.h"
#import "EditDraftViewController.h"
#import "AllDraftersTableViewCell.h"

@interface EventsViewController ()<AllDraftersTableViewDelegate, UITextFieldDelegate, CreateDraftVCDelegate, EditDraftVCDelegate>
{
    NSMutableArray *arrEvents;
    NSMutableArray *arrSearchResult;
    bool isEditing;
    bool isFilterAll;
}
@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;

@end

@implementation EventsViewController
@synthesize createdraftVCDelegate;
@synthesize editdraftVCDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _btnCancel.layer.cornerRadius = 5;
    
    _viewConfirm.layer.cornerRadius = 20;
    _viewConfirm.layer.masksToBounds = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.viewConfirmDark addGestureRecognizer:singleFingerTap];
    
    _tblEvents.delegate = self;
    _tblEvents.dataSource = self;
    
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
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestGetEvents: userInfo];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)saveNewEvent:(UITextField*)textField {
    if ([textField.text isEqualToString:@""]) {
       
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Event"
                                     message:@"New Event name can't be empty!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* doneButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [textField becomeFirstResponder];
                                       }];
        
        [alert addAction:doneButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:textField.text forKey:@"event_name"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestAddEvent: userInfo];
    });
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
    NSMutableDictionary *dicEvent = [arrSearchResult objectAtIndex:indexPath.row];
    cell.lblName.text = [dicEvent objectForKey:@"event_name"];
    cell.nIndex = (int)indexPath.row;
    cell.delegate = self;
    
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
    
    if (isEditing && indexPath.row == [arrSearchResult count] - 1) {
        [cell.textfieldNewItem setHidden:NO];
        cell.textfieldNewItem.delegate = self;
        [cell.lblName setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
        [cell.textfieldNewItem becomeFirstResponder];
    }
    else {
        [cell.textfieldNewItem setHidden:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_strNavigateFrom isEqualToString:@"create_draft"]) {
        NSDictionary *dicEvent = [arrSearchResult objectAtIndex:indexPath.row];
        [createdraftVCDelegate setEvent:dicEvent];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([_strNavigateFrom isEqualToString:@"edit_draft"]) {
        NSDictionary *dicEvent = [arrSearchResult objectAtIndex:indexPath.row];
        [editdraftVCDelegate setEvent:dicEvent];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - SwipeableCellDelegate

- (void)OnHide:(int)nIndex {
    NSString *strId = [[arrSearchResult objectAtIndex:nIndex] objectForKey:@"id"];
    [arrSearchResult removeObjectAtIndex:nIndex];
    [_tblEvents reloadData];
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:@"event" forKey:@"item"];
    [userInfo setObject:strId forKey:@"item_id"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestDeleteItem: userInfo];
    });
}

- (void)cellDidOpen:(UITableViewCell *)cell {
    NSIndexPath *currentEditingIndexPath = [self.tblEvents indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidClose:(UITableViewCell *)cell {
    [self.cellsCurrentlyEditing removeObject:[self.tblEvents indexPathForCell:cell]];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        return;
    }
    if (!isEditing) {
        return;
    }
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Event"
                                 message:@"Are you sure to save new Event?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self saveNewEvent:textField];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [arrSearchResult removeObjectAtIndex:[arrSearchResult count] - 1];
                                   [self.tblEvents reloadData];
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
    [self saveNewEvent:textField];
    return YES;
}

#pragma mark - IBActions

- (IBAction)OnGetTurn:(id)sender {
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnAccept:(id)sender {
   
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
    [dicNewEvent setObject:@"" forKey:@"event_name"];
    [dicNewEvent setObject:strUserid forKey:@"user_id"];
    [arrSearchResult addObject:dicNewEvent];
    [_tblEvents reloadData];
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
        arrSearchResult = [arrEvents mutableCopy];
        [_tblEvents reloadData];
        return;
    }
    
    for (NSMutableDictionary *dicEvent in arrEvents) {
        NSString *strEventName = [dicEvent objectForKey:@"event_name"];
        if ([strEventName containsString:strSearch]) {
            [arrSearchResult addObject:dicEvent];
        }
    }
    
    [_tblEvents reloadData];
}



#pragma mark - Request API
- (void) requestGetEvents:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_GET_EVENTS withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            arrEvents = [result objectForKey:@"data"];
            arrSearchResult = [arrEvents mutableCopy];
            [_tblEvents reloadData];
            
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestAddEvent:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_CREATE_EVENTS withJSON:(NSMutableDictionary *) params];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            isEditing = NO;
            arrEvents = [result objectForKey:@"data"];
            arrSearchResult = [arrEvents mutableCopy];
            [_tblEvents reloadData];
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
            [self.tblEvents reloadData];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        [self.tblEvents reloadData];
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
            [self.tblEvents reloadData];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        [self.tblEvents reloadData];
    }
}

@end
