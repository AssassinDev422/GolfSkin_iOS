//
//  GroupTableViewCell.h
//  GolfSkin
//
//  Created by scs on 6/19/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblGroup;
@property (strong, nonatomic) IBOutlet UITableView *tblDraft;
@property (strong, nonatomic) IBOutlet UILabel *lblDrafteeName;
@property (strong, nonatomic) IBOutlet UILabel *lblDrafterName;
@property (strong, nonatomic) IBOutlet UILabel *lblPlusButton;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UIImageView *imgPlus;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTableviewHeight;
@end
