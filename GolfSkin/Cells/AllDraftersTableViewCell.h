//
//  SwipeableCell.h
//  SwipeableTableCell
//
//  Created by Ellen Shapiro on 1/5/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllDraftersTableViewDelegate <NSObject>
- (void)OnHide:(int)draft_id;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end


@interface AllDraftersTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *itemText;
@property (nonatomic) int nIndex;
@property (nonatomic, weak) id <AllDraftersTableViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIView *myContentView;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (strong, nonatomic) IBOutlet UITextField *textfieldNewItem;
@property (strong, nonatomic) IBOutlet UITextField *textfieldNewEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblEventType;
@property (strong, nonatomic) IBOutlet UIButton *btnEventType;
@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UILabel *lblDrafter;
@property (strong, nonatomic) IBOutlet UILabel *lblDraftee;

- (void)openCell;

@end
