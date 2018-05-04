//
//  CreateDraftViewController.m
//  GolfSkin
//
//  Created by scs on 6/17/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "EditDraftViewController.h"
#import "SWRevealViewController.h"
#import "DraftsViewController.h"
#import "EventsViewController.h"
#import "EventTypesViewController.h"
#import "MoreInfoViewController.h"
#import "DraftNameViewController.h"
#import "DrafteesViewController.h"
#import "DraftersViewController.h"
#import "AllDraftersViewController.h"

@interface EditDraftViewController ()<EditDraftVCDelegate, UITextFieldDelegate>
{
    NSString *draft_order;
    NSString *pickDate;
}
@end

@implementation EditDraftViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self uiSetup];
    [self menuSetup];
    
    pickDate = @"";
    
    if (_dicDraft) {
        _textfieldEvent.text = [_dicDraft objectForKey:@"event_name"];
        _textfieldEventType.text = [_dicDraft objectForKey:@"event_type"];
        _textfieldMoreInfo.text = [_dicDraft objectForKey:@"more_info"];
        _textfieldDraftName.text = [_dicDraft objectForKey:@"draft_name"];
        _textfieldDrafteeLabel.text = [_dicDraft objectForKey:@"draftee_label"];
        _textfieldDrafterLabel.text = [_dicDraft objectForKey:@"drafter_label"];
        _textfieldDrafteeNum.text = [_dicDraft objectForKey:@"group_count"];
        _textfieldPicksMaxNum.text = [_dicDraft objectForKey:@"max_pick_group"];
        _textfieldMaxTotalNum.text = [_dicDraft objectForKey:@"max_pick_user"];
        _lblDraftID.text = [_dicDraft objectForKey:@"id"];
        
        NSDate *startdate = [commonUtils stringToDate:[_dicDraft objectForKey:@"start_date"] dateFormat:@"yyyy-MM-dd"];
        NSString *strStart = [commonUtils dateToString:startdate dateFormat:@"MM/dd/yyyy"];
        NSDate *completedate = [commonUtils stringToDate:[_dicDraft objectForKey:@"complete_date"] dateFormat:@"yyyy-MM-dd"];
        NSString *strComplete = [commonUtils dateToString:completedate dateFormat:@"MM/dd/yyyy"];
        
        _textfieldStartDate.text = strStart;
        _textfieldCompleteDate.text = strComplete;

        [_switchNewPicksYes setOn:YES];
        [_switchSamePickYes setOn:YES];
        [_switchStart setOn:YES];
        if ([[_dicDraft objectForKey:@"is_allow_newpick"] isEqualToString:@"0"]) {
            [_switchNewPicksYes setOn:NO];
        }
        if ([[_dicDraft objectForKey:@"is_allow_newpick"] isEqualToString:@"0"]) {
            [_switchSamePickYes setOn:NO];
        }
        if ([[_dicDraft objectForKey:@"is_hide"] isEqualToString:@"0"]) {
            [_switchSamePickYes setOn:NO];
        }
        
        if ([[_dicDraft objectForKey:@"is_started"] isEqualToString:@"0"]) {
            [_switchStart setOn:NO];
        }
        if ([[_dicDraft objectForKey:@"is_completed"] isEqualToString:@"0"]) {
            [_switchComplete setOn:NO];
        }
        
        if ([[_dicDraft objectForKey:@"draft_order"] isEqualToString:@"snake"]) {
            draft_order = @"snake";
            [_imageSnake setImage:[UIImage imageNamed:@"icon_checked.png"]];
            [_imageStandard setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
            [_imagePool setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
        }
        else if ([[_dicDraft objectForKey:@"draft_order"] isEqualToString:@"standard"]) {
            draft_order = @"standard";
            [_imageSnake setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
            [_imageStandard setImage:[UIImage imageNamed:@"icon_checked.png"]];
            [_imagePool setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
        }
        else {
            draft_order = @"pool";
            [_imageSnake setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
            [_imageStandard setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
            [_imagePool setImage:[UIImage imageNamed:@"icon_checked.png"]];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    _scrollView.contentSize = CGSizeMake(screenWidth, 1665);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuSetup {
    if (self.revealViewController != nil) {
        
        [self.navigationController setNavigationBarHidden:false];
        self.navigationItem.hidesBackButton = true;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]                                                       forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-60, -60)
                                                             forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)uiSetup {
    [self.navigationController setNavigationBarHidden:false];
    self.navigationItem.hidesBackButton = true;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:48.0/255.0 green:62.0/255.0 blue:168.0/255.0 alpha:1];
    
    _btnHome.layer.borderWidth = 1;
    _btnHome.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnHome.layer.cornerRadius = 20;
    _btnCancel.layer.borderWidth = 1;
    _btnCancel.layer.borderColor = [[UIColor whiteColor] CGColor];
    _btnCancel.layer.cornerRadius = 20;
    
    _textfieldStartDate.delegate = self;
    _textfieldCompleteDate.delegate = self;
    
    _textfieldEvent.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldEvent.layer.borderWidth = 1;
    _textfieldEvent.layer.cornerRadius = 5;
    
    _textfieldDraftName.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldDraftName.layer.borderWidth = 1;
    _textfieldDraftName.layer.cornerRadius = 5;
    
    _textfieldEventType.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldEventType.layer.borderWidth = 1;
    _textfieldEventType.layer.cornerRadius = 5;
    
    _textfieldMoreInfo.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldMoreInfo.layer.borderWidth = 1;
    _textfieldMoreInfo.layer.cornerRadius = 5;
    
    _textfieldDrafteeNum.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldDrafteeNum.layer.borderWidth = 1;
    _textfieldDrafteeNum.layer.cornerRadius = 5;
    
    _textfieldStartDate.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldStartDate.layer.borderWidth = 1;
    _textfieldStartDate.layer.cornerRadius = 5;
    
    _textfieldCompleteDate.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldCompleteDate.layer.borderWidth = 1;
    _textfieldCompleteDate.layer.cornerRadius = 5;
    
    _textfieldMaxTotalNum.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldMaxTotalNum.layer.borderWidth = 1;
    _textfieldMaxTotalNum.layer.cornerRadius = 5;
    
    _textfieldPicksMaxNum.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldPicksMaxNum.layer.borderWidth = 1;
    _textfieldPicksMaxNum.layer.cornerRadius = 5;
    
    _textfieldDrafteeLabel.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldDrafteeLabel.layer.borderWidth = 1;
    _textfieldDrafteeLabel.layer.cornerRadius = 5;
    
    _textfieldDrafterLabel.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldDrafterLabel.layer.borderWidth = 1;
    _textfieldDrafterLabel.layer.cornerRadius = 5;
    
    _textfieldDrafterLabel.layer.borderColor = [[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1] CGColor];
    _textfieldDrafterLabel.layer.borderWidth = 1;
    _textfieldDrafterLabel.layer.cornerRadius = 5;
    
}

- (void)setEvent: (NSDictionary*)event {
    [_dicDraft setObject:[event objectForKey:@"event_name"] forKey:@"event_name"];
    [_dicDraft setObject:[event objectForKey:@"id"] forKey:@"event_id"];
    _textfieldEvent.text = [event objectForKey:@"event_name"];
}

- (void)setEventType: (NSDictionary*)event_type {
    [_dicDraft setObject:[event_type objectForKey:@"event_type"] forKey:@"event_type"];
    [_dicDraft setObject:[event_type objectForKey:@"id"] forKey:@"event_type_id"];
    _textfieldEventType.text = [event_type objectForKey:@"event_type"];
}

- (void)setMoreInfo:(NSDictionary *)more_info {
    [_dicDraft setObject:[more_info objectForKey:@"more_info"] forKey:@"more_info"];
    [_dicDraft setObject:[more_info objectForKey:@"id"] forKey:@"more_info_id"];
    _textfieldMoreInfo.text = [more_info objectForKey:@"more_info"];
}

- (void)setDraftName:(NSDictionary *)draft_name {
    [_dicDraft setObject:[draft_name objectForKey:@"draft_name"] forKey:@"draft_name"];
    [_dicDraft setObject:[draft_name objectForKey:@"id"] forKey:@"draft_name_id"];
    _textfieldDraftName.text = [draft_name objectForKey:@"draft_name"];
}

- (void)setDrafteelist: (NSMutableArray*)arrDraftees {
    [_dicDraft setObject:arrDraftees forKey:@"draftees"];
}

- (void)setDrafterlist: (NSMutableArray*)arrDrafters {
    [_dicDraft setObject:arrDrafters forKey:@"drafters"];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    _constraintPickBottom.constant = 0;
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return YES;
}

#pragma mark - IBActions

- (IBAction)SnakeChooseAction:(id)sender {
    _imageSnake.image = [UIImage imageNamed:@"icon_checked.png"];
    _imageStandard.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imagePool.image = [UIImage imageNamed:@"icon_unchecked.png"];
    [_switchSamePickYes setOn:NO];
}

- (IBAction)StandardChooseAction:(id)sender {
    _imageSnake.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imageStandard.image = [UIImage imageNamed:@"icon_checked.png"];
    _imagePool.image = [UIImage imageNamed:@"icon_unchecked.png"];
    [_switchSamePickYes setOn:NO];

}

- (IBAction)PoolChoooseAction:(id)sender {
    _imageSnake.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imageStandard.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imagePool.image = [UIImage imageNamed:@"icon_checked.png"];
    [_switchSamePickYes setOn:YES];
}

- (IBAction)OnSnakeChoose:(id)sender {
    draft_order = @"snake";
    _imageSnake.image = [UIImage imageNamed:@"icon_checked.png"];
    _imageStandard.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imagePool.image = [UIImage imageNamed:@"icon_unchecked.png"];
}

- (IBAction)OnStandardChoose:(id)sender {
    draft_order = @"standard";
    _imageSnake.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imageStandard.image = [UIImage imageNamed:@"icon_checked.png"];
    _imagePool.image = [UIImage imageNamed:@"icon_unchecked.png"];
    
}

- (IBAction)OnPoolChooose:(id)sender {
    draft_order = @"pool";
    _imageSnake.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imageStandard.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imagePool.image = [UIImage imageNamed:@"icon_checked.png"];
    
}

- (IBAction)OnEventChoose:(id)sender {
    EventsViewController *eventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsViewController"];
    eventVC.strNavigateFrom = @"edit_draft";
    eventVC.editDraftVC = self;
    eventVC.editdraftVCDelegate = self;
    [self.navigationController pushViewController:eventVC animated:YES];
    
}

- (IBAction)OnEventTypeChoose:(id)sender {
    EventTypesViewController *eventTypeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventTypesViewController"];
    eventTypeVC.strNavigateFrom = @"edit_draft";
    eventTypeVC.editDraftVC = self;
    eventTypeVC.editdraftVCDelegate = self;
    [self.navigationController pushViewController:eventTypeVC animated:YES];
}

- (IBAction)OnMoreInfoChoose:(id)sender {
    MoreInfoViewController *moreinfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreInfoViewController"];
    moreinfoVC.strNavigateFrom = @"edit_draft";
    moreinfoVC.editDraftVC = self;
    moreinfoVC.editdraftVCDelegate = self;
    [self.navigationController pushViewController:moreinfoVC animated:YES];
    
}


- (IBAction)OnDraftNameChoose:(id)sender {
    DraftNameViewController *draftnameVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftNameViewController"];
    draftnameVC.strNavigateFrom = @"edit_draft";
    draftnameVC.editDraftVC = self;
    draftnameVC.editdraftVCDelegate = self;
    [self.navigationController pushViewController:draftnameVC animated:YES];
}

- (IBAction)OnDrafteeChoose:(id)sender {
    DrafteesViewController *drafteeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DrafteesViewController"];
    drafteeVC.strNavigateFrom = @"create_draft";
    drafteeVC.editDraftVC = self;
    drafteeVC.arrSelected = [_dicDraft objectForKey:@"draftees"];
    drafteeVC.editdraftVCDelegate = self;
    [self.navigationController pushViewController:drafteeVC animated:YES];
}

- (IBAction)OnDrafterChoose:(id)sender {
    AllDraftersViewController *drafterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AllDraftersViewController"];
    drafterVC.strNavigateFrom = @"create_draft";
    drafterVC.editDraftVC = self;
    drafterVC.arrSelected = [_dicDraft objectForKey:@"drafters"];
    drafterVC.editdraftVCDelegate = self;
    [self.navigationController pushViewController:drafterVC animated:YES];
}


- (IBAction)OnHidePicker:(id)sender {
    _constraintPickBottom.constant = -220;
}

- (IBAction)OnPickerChange:(id)sender {
    if ([pickDate isEqualToString:@"start"]) {
        _textfieldStartDate.text = [commonUtils dateToString:_datePicker.date dateFormat:@"MM/dd/YYYY"];

    }
    else if ([pickDate isEqualToString:@"complete"]) {
        _textfieldCompleteDate.text = [commonUtils dateToString:_datePicker.date dateFormat:@"MM/dd/YYYY"];
        
    }
}

- (IBAction)OnShowPicker:(id)sender {
    pickDate = @"start";
    _constraintPickBottom.constant = 0;
    
}

- (IBAction)OnShowPicker2:(id)sender {
    pickDate = @"complete";
    _constraintPickBottom.constant = 0;

}

- (IBAction)OnHome:(id)sender {
    if ([_textfieldEvent.text isEqual:@""] ||
        [_textfieldEventType.text isEqual:@""] ||
        [_textfieldMoreInfo.text isEqual:@""] ||
        [_textfieldDraftName.text isEqual:@""] ||
        [_textfieldMaxTotalNum.text isEqual:@""] ||
        [_textfieldPicksMaxNum.text isEqual:@""] ||
        [_textfieldDrafteeNum.text isEqual:@""] ||
        [_textfieldDraftName.text isEqual:@""]) {
        
        [commonUtils showAlert:nil withMessage:@"Please fill forms" view:self];
        return;
    }
    
    if (_switchStart.isOn && [_textfieldStartDate.text isEqualToString:@""]) {
        [commonUtils showAlert:nil withMessage:@"Please fill Start Date" view:self];
        return;
    }
    
    if (_switchComplete.isOn && [_textfieldCompleteDate.text isEqualToString:@""]) {
        [commonUtils showAlert:@"Edit Draft" withMessage:@"Please fill Complete Date" view:self];
        return;
    }
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    appController.strToken = [commonUtils getUserDefault:@"token"];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:appController.strToken forKey:@"token"];
    [userInfo setObject:[_dicDraft objectForKey:@"id"] forKey:@"draft_id"];
    [userInfo setObject:[_dicDraft objectForKey:@"event_id"] forKey:@"event"];
    [userInfo setObject:[_dicDraft objectForKey:@"event_type_id"] forKey:@"event_type"];
    [userInfo setObject:[_dicDraft objectForKey:@"more_info_id"] forKey:@"more_info"];
    [userInfo setObject:[_dicDraft objectForKey:@"draft_name_id"] forKey:@"draft_name"];
    
    NSString *strDrafteeLabel = _textfieldDrafteeLabel.text;

    if ([strDrafteeLabel isEqualToString:@""]) {
        strDrafteeLabel = @"Players";
    }
    
    NSString *strDrafterLabel = _textfieldDrafteeLabel.text;
    if ([strDrafterLabel isEqualToString:@""]) {
        strDrafterLabel = @"Drafters";
    }
    
    [userInfo setObject:strDrafteeLabel forKey:@"draftee_label"];
    [userInfo setObject:strDrafterLabel forKey:@"drafter_label"];
    
    [userInfo setObject:draft_order forKey:@"draft_order"];
    [userInfo setObject:[_switchNewPicksYes isOn] == true ? @"1" : @"0" forKey:@"is_newpick"];
    [userInfo setObject:[_switchSamePickYes isOn] == true ? @"1" : @"0" forKey:@"is_samepick"];
    [userInfo setObject:[_switchHidePick isOn] == true ? @"1" : @"0" forKey:@"is_hide"];
    [userInfo setObject:_textfieldDrafteeNum.text forKey:@"group_count"];
    [userInfo setObject:_textfieldPicksMaxNum.text forKey:@"max_pick_group"];
    [userInfo setObject:_textfieldMaxTotalNum.text forKey:@"max_pick_user"];
    [userInfo setObject:[_switchStart isOn] == true ? @"1" : @"0" forKey:@"is_started"];
    [userInfo setObject:[_switchComplete isOn] == true ? @"1" : @"0" forKey:@"is_completed"];
    
    NSString *strDraftees = @"";
    if ([_dicDraft objectForKey:@"draftees"] != nil) {
        NSMutableArray *arrDraftees = [_dicDraft objectForKey:@"draftees"];
        strDraftees = [arrDraftees componentsJoinedByString:@"|"];
    }
    [userInfo setObject:strDraftees forKey:@"draftees"];
    
    NSString *strDrafters = @"";
    if ([_dicDraft objectForKey:@"drafters"] != nil) {
        NSMutableArray *arrDrafters = [_dicDraft objectForKey:@"drafters"];
        strDrafters = [arrDrafters componentsJoinedByString:@"|"];
    }
    [userInfo setObject:strDrafters forKey:@"drafters"];
    
    if (_switchStart.isOn) {
        NSDate *startdate = [commonUtils stringToDate:_textfieldStartDate.text dateFormat:@"MM/dd/yyyy"];
        NSString *strStart = [commonUtils dateToString:startdate dateFormat:@"yyyy-MM-dd"];
        [userInfo setObject:strStart forKey:@"start_date"];
        
    }
    
    if (_switchComplete.isOn) {
        NSDate *completedate = [commonUtils stringToDate:_textfieldCompleteDate.text dateFormat:@"MM/dd/yyyy"];
        NSString *strComplete = [commonUtils dateToString:completedate dateFormat:@"yyyy-MM-dd"];
        [userInfo setObject:strComplete forKey:@"complete_date"];
    }
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestEditDraft: userInfo];
    });
}

- (IBAction)OnCancel:(id)sender {
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request API
- (void) requestEditDraft:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_EDIT_DRAFT withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        
        if([status intValue] == 0) {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
            
        } else {
            [commonUtils showAlert: @"GolfSkin" withMessage:[result objectForKey:@"msg"] view:self];
            DraftsViewController* draftsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftsViewController"];
            UINavigationController *frontVCNavigate = [[UINavigationController alloc]initWithRootViewController:draftsVC];
            SWRevealViewController* mainRevealController = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            mainRevealController.frontViewController = frontVCNavigate;
            [self.navigationController pushViewController:mainRevealController animated:YES];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

@end
