//
//  CreateDraftViewController.m
//  GolfSkin
//
//  Created by scs on 6/17/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "ViewDraftViewController.h"
#import "SWRevealViewController.h"
#import "EditDraftViewController.h"

@interface ViewDraftViewController ()

@end

@implementation ViewDraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiSetup];
    [self menuSetup];
    
    if (_dicDraft) {
        _textfieldEvent.text = [_dicDraft objectForKey:@"event_name"];
        _textfieldEventType.text = [_dicDraft objectForKey:@"event_type"];
        _textfieldMoreInfo.text = [_dicDraft objectForKey:@"more_info"];
        _textfieldDraftName.text = [_dicDraft objectForKey:@"draft_name"];
        _textfieldDrafteeLabel.text = [_dicDraft objectForKey:@"draftee_label"];
        _textfieldDrafterLabel.text = [_dicDraft objectForKey:@"drafter_label"];
        _textfieldStartDate.text = [_dicDraft objectForKey:@"start_date"];
        _textfieldCompleteDate.text = [_dicDraft objectForKey:@"complete_date"];
        _textfieldDrafteeNum.text = [_dicDraft objectForKey:@"group_count"];
        _textfieldPicksMaxNum.text = [_dicDraft objectForKey:@"max_pick_group"];
        _textfieldMaxTotalNum.text = [_dicDraft objectForKey:@"max_pick_user"];
        _lblDraftID.text = [_dicDraft objectForKey:@"id"];
        
        [_switchNewPicksYes setOn:YES];
        [_switchSamePickYes setOn:YES];
        [_switchStart setOn:YES];
        if ([[_dicDraft objectForKey:@"is_allow_newpick"] isEqualToString:@"0"]) {
            [_switchNewPicksYes setOn:NO];
        }
        if ([[_dicDraft objectForKey:@"is_allow_newpick"] isEqualToString:@"0"]) {
            [_switchSamePickYes setOn:NO];
        }
        if ([[_dicDraft objectForKey:@"is_started"] isEqualToString:@"0"]) {
            [_switchStart setOn:NO];
        }
        if ([[_dicDraft objectForKey:@"is_completed"] isEqualToString:@"0"]) {
            [_switchComplete setOn:NO];
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

- (IBAction)SnakeChooseAction:(id)sender {
    _imageSnake.image = [UIImage imageNamed:@"icon_checked.png"];
    _imageStandard.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imagePool.image = [UIImage imageNamed:@"icon_unchecked.png"];
}

- (IBAction)StandardChooseAction:(id)sender {
    _imageSnake.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imageStandard.image = [UIImage imageNamed:@"icon_checked.png"];
    _imagePool.image = [UIImage imageNamed:@"icon_unchecked.png"];

}

- (IBAction)PoolChoooseAction:(id)sender {
    _imageSnake.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imageStandard.image = [UIImage imageNamed:@"icon_unchecked.png"];
    _imagePool.image = [UIImage imageNamed:@"icon_checked.png"];

}

- (IBAction)OnSwitchNewpicksYes:(id)sender {
}

- (IBAction)OnSwitchSamepicksYes:(id)sender {
}

- (IBAction)OnEdit:(id)sender {
    EditDraftViewController* editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDraftViewController"];
    editVC.dicDraft = _dicDraft;
    [self.navigationController pushViewController: editVC animated:YES];
}

- (IBAction)OnCancel:(id)sender {
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
