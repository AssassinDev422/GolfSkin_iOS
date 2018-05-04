//
//  ActiveDraftViewController.m
//  GolfSkin
//
//  Created by scs on 6/19/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "DraftDetailViewController.h"
#import "GroupTableViewCell.h"
#import "SWRevealViewController.h"
#import "ActiveTableViewCell.h"
#import "DraftersViewController.h"
#import "AllDraftersTableViewCell.h"

@interface DraftDetailViewController ()
{
    NSMutableArray *arrDraftees;
    NSMutableArray *arrPicks;
    NSMutableArray *arrRestDraftees;
    NSString *draftStatus;
    bool isEditing;
    int selectedgroup;
    int selectedDrafteeID;
    bool isStartpick;
    bool isAvailablePick;
}
@end

@implementation DraftDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isEditing = false;
    isStartpick = false;
    isAvailablePick = false;
    int nGroupCount = [[_dicDraft objectForKey:@"group_count"] intValue];
    arrDraftees = [[NSMutableArray alloc] initWithCapacity:nGroupCount];
    arrPicks = [[NSMutableArray alloc] initWithCapacity:nGroupCount];
    
    NSArray *draftees = [_dicDraft objectForKey:@"draftee_array"];
    if (nGroupCount == 0) {
        nGroupCount = 1;
    }
    
    for (int i = 0; i < nGroupCount; i++) {
        arrDraftees[i] = [[NSMutableArray alloc] init];
    }
    for (NSDictionary *dicDraftee in draftees) {
        int group = [[dicDraftee objectForKey:@"group"] intValue];
        [arrDraftees[group] addObject: dicDraftee];
    }
    [self menuSetup];
    [self setupUI];
    
    draftStatus = [_dicDraft objectForKey:@"status"];
    if (draftStatus == nil) {
        draftStatus = @"";
    }
    
    if ([draftStatus isEqualToString:@"Active"]) {
        self.navigationItem.title = @"ACTIVE";
    }
    else if ([draftStatus isEqualToString:@"Pending"]) {
        self.navigationItem.title = @"WAITING FOR DRAFTERS";
    }
    else if ([draftStatus isEqualToString:@"Notstarted"]) {
        self.navigationItem.title = @"NOT STARTED";
    }
    else if ([draftStatus isEqualToString:@"Completed"]) {
        self.navigationItem.title = @"COMPLETED";
    }

//    [self refreshContent];

    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:[_dicDraft objectForKey:@"id"] forKey:@"draft_id"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestGetPicks: userInfo];
    });

}


- (void)viewDidAppear:(BOOL)animated {
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _constraintTotalHeight.constant);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Functions

- (void)menuSetup {
//    if (self.revealViewController != nil) {
    
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
    
//    }
}

- (void)setupUI {
//    arrDraftees = @[@{@"draftee":@"Arnold Palmer", @"drafter":@"Jason"},
//                      @{@"draftee":@"Arnold Palmer", @"drafter":@""},
//                      @{@"draftee":@"Neil O'reary", @"drafter":@""},
//                    ];
    
    
    _lblEvent.layer.borderColor = [[UIColor whiteColor] CGColor];
    _lblEvent.layer.borderWidth = 1;
    _lblEvent.layer.cornerRadius = 17;
    
    _lblMoreinfo.layer.borderColor = [[UIColor whiteColor] CGColor];
    _lblMoreinfo.layer.borderWidth = 1;
    _lblMoreinfo.layer.cornerRadius = 17;
    
    _lblDate.layer.borderColor = [[UIColor whiteColor] CGColor];
    _lblDate.layer.borderWidth = 1;
    _lblDate.layer.cornerRadius = 17;
    
    _btnHome.layer.borderWidth = 1;
    _btnHome.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnHome.layer.cornerRadius = 20;
    _btnAutofill.layer.borderWidth = 1;
    _btnAutofill.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnAutofill.layer.cornerRadius = 20;
    
    _tblGroup.delegate = self;
    _tblGroup.dataSource = self;
    
    _lblDraftName.text = [_dicDraft objectForKey:@"draft_name"];
    _lblEvent.text = [_dicDraft objectForKey:@"event_name"];
    _lblMoreinfo.text = [_dicDraft objectForKey:@"more_info"];
    
    NSDate *startdate = [commonUtils stringToDate:[_dicDraft objectForKey:@"start_date"] dateFormat:@"yyyy-MM-dd"];
    NSString *strStart = [commonUtils dateToString:startdate dateFormat:@"MM/dd/yyyy"];
    _lblDate.text = strStart;
    
}

- (void)refreshContent {
    CGFloat height = 0;
    for (NSArray *arrDrafts in arrDraftees) {
        height += arrDrafts.count * 50 + 155;
    }
    _constraintTableHeight.constant = height;
    _constraintTotalHeight.constant = 142 + _constraintTableHeight.constant + 50 + 40 * 2 + 25 + 50 + 20 + 55;

    [_tblGroup reloadData];
    
    if ([[_dicDraft objectForKey:@"draft_order"] isEqualToString:@"pool"]) {
        _lblTurn.text = @"No order";
        isAvailablePick = true;
    }
    else {
        NSMutableDictionary *dicCurrentTurn = [self getCurrentTurn];
        NSMutableDictionary *dicNextTurn = [self getNextTurn];
        
        if (dicCurrentTurn == nil || dicNextTurn == nil) {
            isAvailablePick = false;
            return;
        }
        
        draftStatus = [_dicDraft objectForKey:@"status"];
        if (draftStatus == nil) {
            draftStatus = @"";
        }
        
        if ([draftStatus isEqualToString:@"Active"]) {
            _lblTurn.text = [NSString stringWithFormat:@"%@'s turn.(%@ is Next.)", [dicCurrentTurn objectForKey:@"name"], [dicNextTurn objectForKey:@"name"]];
            if ([[dicCurrentTurn objectForKey:@"user_id"] isEqualToString:appController.strUserId]) {
                isAvailablePick = true;
            }
            else {
                isAvailablePick = false;
            }
        }
        else if ([draftStatus isEqualToString:@"Pending"]) {
            isAvailablePick = false;
            _lblTurn.text = @"Draft Order";
        }
        else if ([draftStatus isEqualToString:@"Notstarted"]) {
            isAvailablePick = false;
            _lblTurn.text = @"Draft Order";
        }
        else if ([draftStatus isEqualToString:@"Completed"]) {
            isAvailablePick = false;
            _lblTurn.text = @"";
        }

        
    }
    
    [self checkRestDraftees];
    if ([arrRestDraftees count] == 1) {
        [_btnAutofill setEnabled:YES];
        [_btnAutofill setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else {
        [_btnAutofill setEnabled:NO];
        [_btnAutofill setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void)AddDrafteeAction:(UIButton*)sender{
    if (isEditing) {
        return;
    }
    selectedgroup = (int)sender.tag - 10;
    NSMutableDictionary *dicNew = [[NSMutableDictionary alloc] init];
    [dicNew setObject:@"" forKey:@"draftee_name"];
    [arrDraftees[selectedgroup] addObject:dicNew];
    
    isEditing = true;

    [self refreshContent];
}

- (NSMutableDictionary*)getPrevTurn {
    NSMutableArray *arrDrafters = [_dicDraft objectForKey:@"drafter_array"];
    if ([arrDrafters count] == 0) {
        return nil;
    }
    
    if ([arrDrafters count] == 1) {
        return arrDrafters[0];
    }
    
    if ([arrPicks count] == 0) {
        return arrDrafters[0];
    }
    
    NSString *currentUserID = [arrPicks[0] objectForKey:@"user_id"];
    for (NSMutableDictionary *dicDrafter in arrDrafters) {
        if ([currentUserID isEqualToString:[dicDrafter objectForKey:@"user_id"]]) {
            return dicDrafter;
        }
    }
    return nil;
    
}

- (NSMutableDictionary*)getCurrentTurn {
    if ([[_dicDraft objectForKey:@"draft_order"] isEqualToString:@"pool"]) {
        return nil;
    }
    
    NSMutableArray *arrDrafters = [_dicDraft objectForKey:@"drafter_array"];
    if ([arrDrafters count] == 0) {
        return nil;
    }
    
    if ([arrDrafters count] == 1) {
        return arrDrafters[0];
    }
    
    if ([arrPicks count] == 0) {
        return arrDrafters[0];
    }
    
    NSString *currentUserID = [arrPicks[0] objectForKey:@"user_id"];
    
    if ([[_dicDraft objectForKey:@"draft_order"] isEqualToString:@"standard"]) {
        for (int i = 0; i < [arrDrafters count]; i++) {
            NSMutableDictionary *dicDrafter = [arrDrafters objectAtIndex:i];
            if ([currentUserID isEqualToString:[dicDrafter objectForKey:@"user_id"]]) {
                if (i == [arrDrafters count] - 1) {
                    return [arrDrafters objectAtIndex:0];
                }
                return [arrDrafters objectAtIndex:i + 1];
            }
        }
    }
    else if ([[_dicDraft objectForKey:@"draft_order"] isEqualToString:@"snake"]) {
        
        for (int i = 0; i < [arrDrafters count]; i++) {
            NSMutableDictionary *dicDrafter = [arrDrafters objectAtIndex:i];
            if ([currentUserID isEqualToString:[dicDrafter objectForKey:@"user_id"]]) {
                
                if ([arrPicks count] < 2 || [[arrPicks[0] objectForKey:@"order"] intValue] > [[arrPicks[1] objectForKey:@"order"] intValue] ) {
                    if (i == [arrDrafters count] - 1) {
                        return dicDrafter;
                    }
                    return [arrDrafters objectAtIndex:i + 1];
                }
                else if ([[arrPicks[1] objectForKey:@"order"] intValue] == [[arrPicks[0] objectForKey:@"order"] intValue]) {
                    if (i == 0) {
                        return arrDrafters[1];
                    }
                    else {
                        return arrDrafters[i - 1];
                    }
                }
                else {
                    if (i == 0) {
                        return dicDrafter;
                    }
                    return [arrDrafters objectAtIndex:i - 1];
                }
                
            }
        }
        return nil;
    }
    return nil;
}

- (NSMutableDictionary*)getNextTurn {
    if ([[_dicDraft objectForKey:@"draft_order"] isEqualToString:@"pool"]) {
        return nil;
    }
    
    NSMutableArray *arrDrafters = [_dicDraft objectForKey:@"drafter_array"];
    if ([arrDrafters count] == 0) {
        return nil;
    }
    
    if ([arrDrafters count] == 1) {
        return arrDrafters[0];
    }
    
    if ([arrPicks count] == 0) {
        return arrDrafters[1];
    }
    
    NSString *currentUserID = [arrPicks[0] objectForKey:@"user_id"];
    
    if ([[_dicDraft objectForKey:@"draft_order"] isEqualToString:@"standard"]) {
        for (int i = 0; i < [arrDrafters count]; i++) {
            NSMutableDictionary *dicDrafter = [arrDrafters objectAtIndex:i];
            if ([currentUserID isEqualToString:[dicDrafter objectForKey:@"user_id"]]) {
                if (i == [arrDrafters count] - 1) {
                    return [arrDrafters objectAtIndex:1];
                }
                if (i == [arrDrafters count] - 2) {
                    return [arrDrafters objectAtIndex:0];
                }
                return [arrDrafters objectAtIndex:i + 1];
            }
        }
    }
    else if ([[_dicDraft objectForKey:@"draft_order"] isEqualToString:@"snake"]) {
        
        for (int i = 0; i < [arrDrafters count]; i++) {
            NSMutableDictionary *dicDrafter = [arrDrafters objectAtIndex:i];
            if ([currentUserID isEqualToString:[dicDrafter objectForKey:@"user_id"]]) {
                
                if ([arrPicks count] < 2 || [[arrPicks[0] objectForKey:@"order"] intValue] > [[arrPicks[1] objectForKey:@"order"] intValue] ) {
                    if (i == [arrDrafters count] - 2) {
                        return [arrDrafters objectAtIndex:[arrDrafters count] - 1];
                    }
                    if (i == [arrDrafters count] - 1) {
                        return [arrDrafters objectAtIndex:[arrDrafters count] - 2];
                    }
                    
                    return [arrDrafters objectAtIndex:i + 2];
                }
                else if ([[arrPicks[1] objectForKey:@"order"] intValue] == [[arrPicks[0] objectForKey:@"order"] intValue]) {
                    if (i == 0) {
                        if ([arrPicks count] == 2) {
                            return arrPicks[1];
                        }
                        return arrDrafters[2];
                    }
                    else {
                        if ([arrPicks count] == 2) {
                            return arrPicks[0];
                        }
                        return arrDrafters[i - 2];
                    }
                }
                else {
                    if (i == 0) {
                        return arrDrafters[1];
                    }
                    if (i == 1) {
                        return arrDrafters[0];
                    }
                    return [arrDrafters objectAtIndex:i - 2];
                }
                
            }
        }
        return nil;
    }
    return nil;
}


- (NSMutableArray*)checkRestDraftees {
    
    NSMutableArray *arrDraftees1 = [_dicDraft objectForKey:@"draftee_array"];
    NSMutableArray *arrDraftees2 = [arrDraftees1 mutableCopy];
    
    for (NSMutableDictionary *dicDraftee in arrDraftees1) {
        for (NSMutableDictionary *pick in arrPicks) {
            if ([[pick objectForKey:@"draftee_id"] isEqualToString:[dicDraftee objectForKey:@"draftee_id"]]) {
                [arrDraftees2 removeObject:dicDraftee];
                break;
            }
        }
    }
    arrRestDraftees = arrDraftees2;
    return arrDraftees2;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - UITableViewDelegate, UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 100) {
        return arrDraftees.count;
    }
    else {
        return [[arrDraftees objectAtIndex: tableView.tag - 101] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupTableViewCell"];
        cell.tblDraft.tag = 101 + indexPath.row;
        cell.tblDraft.layer.cornerRadius = 10;
        cell.tblDraft.layer.borderWidth = 1;
        cell.tblDraft.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:231.0/255.0] CGColor];
        cell.tblDraft.delegate = self;
        cell.tblDraft.dataSource = self;
        [cell.tblDraft reloadData];
        
        cell.lblDrafteeName.text = [_dicDraft objectForKey:@"draftee_label"];
        cell.lblDrafterName.text = [_dicDraft objectForKey:@"drafter_label"];
        cell.lblGroup.text = [NSString stringWithFormat:@"GROUP%ld", indexPath.row + 1];
        
        if ([[_dicDraft objectForKey:@"is_allow_newpick"] intValue] == 0) {
            cell.btnAdd.hidden = YES;
            cell.lblPlusButton.hidden = YES;
            cell.imgPlus.hidden = YES;
        }
        else {
            cell.btnAdd.hidden = NO;
            cell.lblPlusButton.hidden = NO;
            cell.imgPlus.hidden = NO;
            cell.lblPlusButton.text = [_dicDraft objectForKey:@"draftee_label"];
            cell.btnAdd.tag = 10 + indexPath.row;
        }
        
        [cell.btnAdd addTarget:self action:@selector(AddDrafteeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *arrDraft = [arrDraftees objectAtIndex:indexPath.row];
        cell.constraintTableviewHeight.constant = arrDraft.count * 50 + 35;
        
        return cell;
    }
    else {
        AllDraftersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllDraftersTableViewCell"];
        NSDictionary *draftee =  [[arrDraftees objectAtIndex: tableView.tag - 101] objectAtIndex: indexPath.row];
        cell.lblDraftee.text = [draftee objectForKey:@"draftee_name"];
//        cell.lblDrafter.text = [draftee objectForKey:@"drafter"];
        
        cell.lblDrafter.text = @"";
        for (NSMutableDictionary *dicPick in arrPicks) {
            if ([[dicPick objectForKey:@"draft_draftee_id"] isEqualToString:[draftee objectForKey:@"id"]]) {
                if ([[_dicDraft objectForKey:@"is_hide"] intValue] == 0) {
                    cell.lblDrafter.text = [dicPick objectForKey:@"name"];
                }
                else {
                    cell.lblDrafter.text = @"picked";
                }
            }
        }
        
        if (selectedgroup == tableView.tag - 101) {
            if (isEditing && indexPath.row == [arrDraftees[tableView.tag - 101] count] - 1) {
                [cell.textfieldNewItem setHidden:NO];
                [cell.lblDraftee setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.1]];
                cell.textfieldNewItem.tag = 1000;
                [cell.textfieldNewItem becomeFirstResponder];
            }
            else {
                [cell.textfieldNewItem setHidden:YES];
                [cell.lblDraftee setBackgroundColor:[UIColor clearColor]];
                
            }
        }
        else {
            [cell.textfieldNewItem setHidden:YES];
            [cell.lblDraftee setBackgroundColor:[UIColor clearColor]];
            
        }

        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag <= 100) {
        return;
    }
    if (isEditing) {
        return;
    }
    if (!isAvailablePick) {
        return;
    }
    
    NSMutableDictionary *dicDraftee = [arrDraftees[tableView.tag - 101] objectAtIndex:indexPath.row];
    
    if ([[_dicDraft objectForKey:@"draft_order"] isEqualToString:@"snake"] || [[_dicDraft objectForKey:@"draft_order"] isEqualToString:@"standard"]) {
        bool isPickable = false;
        for (NSMutableDictionary *dicRestDraftee in arrRestDraftees) {
            if ([[dicRestDraftee objectForKey:@"id"] isEqualToString:[dicDraftee objectForKey:@"id"]]) {
                isPickable = true;
                break;
            }
        }
        if (!isPickable) {
            return;
        }
    }
    
    [dicDraftee setObject:[appController.dicUserInfo objectForKey:@"name"] forKey:@"name"];
    [dicDraftee setObject:[dicDraftee objectForKey:@"id"] forKey:@"draft_draftee_id"];
    
    if (!isStartpick) {
        [arrPicks addObject:dicDraftee];
        isStartpick = YES;
    }
    else {
        [arrPicks replaceObjectAtIndex:[arrPicks count] - 1 withObject:dicDraftee];
    }
    
    [_tblGroup reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        NSArray *arrDraft = [arrDraftees objectAtIndex:indexPath.row];
        return arrDraft.count * 50 + 155;
    }
    return 50;
}

- (IBAction)OnHome:(id)sender {
    if (isEditing) {
        UITextField *textfielname = (UITextField*)[self.tblGroup viewWithTag:1000];
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
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:appController.strUserId forKey:@"user_id"];
        [userInfo setObject:appController.strToken forKey:@"token"];
        [userInfo setObject:textfielname.text forKey:@"draftee_name"];
        [userInfo setObject:[_dicDraft objectForKey:@"id"] forKey:@"draft_id"];
        [userInfo setObject:[NSString stringWithFormat:@"%d", selectedgroup]  forKey:@"group"];
        
        [commonUtils showActivityIndicator:self.view];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (appController.isLoading) return;
            appController.isLoading = YES;
            
            [self requestAddDraftee: userInfo];
        });
        

    }
    else {
        if (isStartpick) {
            NSMutableDictionary *dicPick = [arrPicks objectAtIndex:[arrPicks count] - 1];
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:appController.strUserId forKey:@"user_id"];
            [userInfo setObject:appController.strToken forKey:@"token"];
            [userInfo setObject:[dicPick objectForKey:@"draft_draftee_id"] forKey:@"draft_draftee_id"];
            [userInfo setObject:[dicPick objectForKey:@"draft_id"] forKey:@"draft_id"];
            [userInfo setObject:@"1" forKey:@"event_type"];
            
            if ([arrRestDraftees count] == 1) {
                [userInfo setObject:@"1" forKey:@"is_completed"];
            }
            else {
                [userInfo setObject:@"0" forKey:@"is_completed"];
            }
            
            [commonUtils showActivityIndicator:self.view];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (appController.isLoading) return;
                appController.isLoading = YES;
                
                [self requestAddPick: userInfo];
            });
        }
    }
}

- (IBAction)OnAutofill:(id)sender {
    if (arrDraftees == nil || [arrDraftees count] == 0) {
        return;
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:[[arrRestDraftees objectAtIndex:0] objectForKey:@"id"] forKey:@"draft_draftee_id"];
    [userInfo setObject:[_dicDraft objectForKey:@"id"] forKey:@"draft_id"];
    [userInfo setObject:@"1" forKey:@"event_type"];
    
    if ([arrRestDraftees count] == 1) {
        [userInfo setObject:@"1" forKey:@"is_completed"];
    }
    else {
        [userInfo setObject:@"0" forKey:@"is_completed"];
    }
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestAddPick: userInfo];
    });
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnDrafters:(id)sender {
    DraftersViewController* draftsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftersViewController"];
    draftsVC.dicDraft = _dicDraft;
    [self.navigationController pushViewController: draftsVC animated:YES];
}


- (void) requestAddDraftee:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_CREATE_DRAFTEE_DRAFT withJSON:(NSMutableDictionary *) params];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            isEditing = NO;
            NSMutableDictionary *draft = [result objectForKey:@"data"];
            
            [_dicDraft setObject:[draft objectForKey:@"draftee_array"] forKey:@"draftee_array"];
            [_dicDraft setObject:[draft objectForKey:@"draftees"] forKey:@"draftees"];
            
            int nGroupCount = [[_dicDraft objectForKey:@"group_count"] intValue];
            arrDraftees = [[NSMutableArray alloc] initWithCapacity:nGroupCount];
            NSArray *draftees = [_dicDraft objectForKey:@"draftee_array"];
            
            for (int i = 0; i < nGroupCount; i++) {
                arrDraftees[i] = [[NSMutableArray alloc] init];
            }
            for (NSDictionary *dicDraftee in draftees) {
                int group = [[dicDraftee objectForKey:@"group"] intValue];
                [arrDraftees[group] addObject: dicDraftee];
            }
            
            [self refreshContent];

        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
            [self.tblGroup reloadData];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        [self.tblGroup reloadData];
    }
}

- (void) requestGetPicks:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_GET_PICKS withJSON:(NSMutableDictionary *) params];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            arrPicks = [result objectForKey:@"data"];
            [self refreshContent];
            
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
            [self.tblGroup reloadData];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        [self.tblGroup reloadData];
    }
}

- (void) requestAddPick:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_ADD_PICK withJSON:(NSMutableDictionary *) params];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            isEditing = NO;
            arrPicks = [result objectForKey:@"data"];
            [self refreshContent];
            
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
            [self.tblGroup reloadData];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        [self.tblGroup reloadData];
    }
}

@end
