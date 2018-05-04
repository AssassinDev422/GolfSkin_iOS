//
//  ActiveDraftViewController.h
//  GolfSkin
//
//  Created by scs on 6/19/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragAndDropTableView.h"

@interface DraftersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,DragAndDropTableViewDataSource,DragAndDropTableViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblDraftName;
@property (strong, nonatomic) IBOutlet UILabel *lblEvent;
@property (strong, nonatomic) IBOutlet UILabel *lblMoreinfo;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDrafteeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblDrafterLabel;
@property (strong, nonatomic) IBOutlet UITableView *tblDrafters;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTotalHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTableHeight;

@property (strong, nonatomic) IBOutlet NSMutableDictionary *dicDraft;

- (IBAction)OnNewDrafter:(id)sender;
- (IBAction)OnBack:(id)sender;

@end

@protocol DraftersVCDelegate <NSObject>

- (void)setDrafterlist: (NSMutableArray*)arrDrafters;

@end
