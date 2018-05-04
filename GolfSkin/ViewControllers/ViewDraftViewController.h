//
//  CreateDraftViewController.h
//  GolfSkin
//
//  Created by scs on 6/17/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewDraftViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnItemMenu;

@property (strong, nonatomic) IBOutlet UITextField *textfieldEvent;
@property (strong, nonatomic) IBOutlet UITextField *textfieldEventType;
@property (strong, nonatomic) IBOutlet UITextField *textfieldMoreInfo;
@property (strong, nonatomic) IBOutlet UITextField *textfieldDraftName;
@property (strong, nonatomic) IBOutlet UITextField *textfieldDrafteeLabel;
@property (strong, nonatomic) IBOutlet UITextField *textfieldDrafterLabel;
@property (strong, nonatomic) IBOutlet UISwitch *switchNewPicksYes;
@property (strong, nonatomic) IBOutlet UISwitch *switchSamePickYes;
@property (strong, nonatomic) IBOutlet UISwitch *switchHidePick;
@property (strong, nonatomic) IBOutlet UISwitch *switchStart;
@property (strong, nonatomic) IBOutlet UISwitch *switchComplete;
@property (strong, nonatomic) IBOutlet UITextField *textfieldDrafteeNum;
@property (strong, nonatomic) IBOutlet UITextField *textfieldPicksMaxNum;
@property (strong, nonatomic) IBOutlet UITextField *textfieldMaxTotalNum;
@property (strong, nonatomic) IBOutlet UITextField *textfieldStartDate;
@property (strong, nonatomic) IBOutlet UITextField *textfieldCompleteDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDraftID;

@property (strong, nonatomic) IBOutlet UIButton *btnHome;
@property (strong, nonatomic) IBOutlet UIImageView *imageSnake;
@property (strong, nonatomic) IBOutlet UIImageView *imageStandard;
@property (strong, nonatomic) IBOutlet UIImageView *imagePool;

- (IBAction)SnakeChooseAction:(id)sender;
- (IBAction)StandardChooseAction:(id)sender;
- (IBAction)PoolChoooseAction:(id)sender;

- (IBAction)OnSwitchNewpicksYes:(id)sender;
- (IBAction)OnSwitchSamepicksYes:(id)sender;
- (IBAction)OnEdit:(id)sender;
- (IBAction)OnCancel:(id)sender;
- (IBAction)OnBack:(id)sender;


@property (strong, nonatomic) NSMutableDictionary *dicDraft;

@end
