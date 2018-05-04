//
//  ActiveDraftViewController.h
//  GolfSkin
//
//  Created by scs on 6/19/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraftDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblDraftName;
@property (strong, nonatomic) IBOutlet UILabel *lblEvent;
@property (strong, nonatomic) IBOutlet UILabel *lblMoreinfo;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTurn;

@property (strong, nonatomic) IBOutlet UITableView *tblGroup;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTotalHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTableHeight;

@property (strong, nonatomic) IBOutlet UIButton *btnHome;
@property (strong, nonatomic) IBOutlet UIButton *btnAutofill;


@property (strong, nonatomic) IBOutlet NSMutableDictionary *dicDraft;


- (IBAction)OnHome:(id)sender;
- (IBAction)OnAutofill:(id)sender;
- (IBAction)OnBack:(id)sender;
- (IBAction)OnDrafters:(id)sender;

@end
