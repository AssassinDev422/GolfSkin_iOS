//
//  SwipeableCell.h
//  SwipeableTableCell
//
//  Created by Ellen Shapiro on 1/5/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DraftsTableViewDelegate <NSObject>
- (void)OnCreate:(int)draft_id draft_type:(int)draftType;
- (void)OnHide:(int)draft_id draft_type:(int)draftType;
- (void)OnView:(int)draft_id draft_type:(int)draftType;
- (void)OnEdit:(int)draft_id draft_type:(int)draftType;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end


@interface DraftsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *itemText;
@property (nonatomic) int nIndex;
@property (nonatomic) int draftType;
@property (nonatomic, weak) id <DraftsTableViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *lblDraftName;
@property (nonatomic, weak) IBOutlet UILabel *lblEvent;
@property (nonatomic, weak) IBOutlet UILabel *lblMoreInfo;
@property (nonatomic, weak) IBOutlet UILabel *lblStartDate;


- (void)openCell;

@end
