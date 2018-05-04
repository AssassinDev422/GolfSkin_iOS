//
//  CreateDraftViewController.h
//  GolfSkin
//
//  Created by scs on 6/17/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateDraftViewController : UIViewController

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
@property (strong, nonatomic) IBOutlet UITextField *textfieldDrafteeNum;
@property (strong, nonatomic) IBOutlet UITextField *textfieldPicksMaxNum;
@property (strong, nonatomic) IBOutlet UITextField *textfieldMaxTotalNum;
@property (strong, nonatomic) IBOutlet UITextField *textfieldStartDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDraftID;

@property (strong, nonatomic) IBOutlet UIButton *btnHome;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIImageView *imageSnake;
@property (strong, nonatomic) IBOutlet UIImageView *imageStandard;
@property (strong, nonatomic) IBOutlet UIImageView *imagePool;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintPickBottom;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)OnSnakeChoose:(id)sender;
- (IBAction)OnStandardChoose:(id)sender;
- (IBAction)OnPoolChooose:(id)sender;

- (IBAction)OnEventChoose:(id)sender;
- (IBAction)OnEventTypeChoose:(id)sender;
- (IBAction)OnMoreInfoChoose:(id)sender;
- (IBAction)OnDraftNameChoose:(id)sender;
- (IBAction)OnDrafteeChoose:(id)sender;
- (IBAction)OnDrafterChoose:(id)sender;
- (IBAction)OnShowPicker:(id)sender;
- (IBAction)OnHidePicker:(id)sender;
- (IBAction)OnPickerChange:(id)sender;
- (IBAction)OnBack:(id)sender;

- (IBAction)OnSave:(id)sender;
- (IBAction)OnCancel:(id)sender;
- (IBAction)OnCopyDraft:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *dicDraft;

@end

@protocol CreateDraftVCDelegate <NSObject>

- (void)setEvent: (NSDictionary*)event;
- (void)setEventType: (NSDictionary*)event_type;
- (void)setMoreInfo: (NSDictionary*)more_info;
- (void)setDraftName: (NSDictionary*)draft_name;
- (void)setDraftee: (NSDictionary*)draftee;
- (void)setDrafteelist: (NSMutableArray*)arrDraftees;
- (void)setDrafterlist: (NSMutableArray*)arrDrafters;

@end
