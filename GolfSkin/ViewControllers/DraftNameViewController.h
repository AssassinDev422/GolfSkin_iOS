//
//  DraftsViewController.h
//  GolfSkin
//
//  Created by scs on 6/19/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateDraftViewController.h"
#import "EditDraftViewController.h"

@interface DraftNameViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnItemMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnItemFilter;
@property (strong, nonatomic) IBOutlet UITableView *tblEvents;

@property (strong, nonatomic) IBOutlet UIView *viewConfirmBack;
@property (strong, nonatomic) IBOutlet UIView *viewConfirm;
@property (strong, nonatomic) IBOutlet UIView *viewConfirmDark;
@property (strong, nonatomic) IBOutlet UIView *viewFilter;
@property (strong, nonatomic) IBOutlet UIView *viewFilterBack;
@property (strong, nonatomic) IBOutlet UIImageView *imageFilterCreated;
@property (strong, nonatomic) IBOutlet UIImageView *imageFilterAll;
@property (strong, nonatomic) IBOutlet UITextField *textfieldSearch;

@property (nonatomic, strong) NSString *strNavigateFrom;
@property (nonatomic, strong) CreateDraftViewController *createDraftVC;
@property (nonatomic, strong) EditDraftViewController *editDraftVC;
@property (nonatomic, strong) id <CreateDraftVCDelegate> createdraftVCDelegate;
@property (nonatomic, strong) id <EditDraftVCDelegate> editdraftVCDelegate;

- (IBAction)OnGetTurn:(id)sender;
- (IBAction)OnBack:(id)sender;
- (IBAction)OnAccept:(id)sender;
- (IBAction)OnViewDraft:(id)sender;
- (IBAction)OnAdd:(id)sender;
- (IBAction)OnFilter:(id)sender;
- (IBAction)OnFilterCreated:(id)sender;
- (IBAction)OnFilterAll:(id)sender;
- (IBAction)OnSearchChange:(id)sender;
@end
