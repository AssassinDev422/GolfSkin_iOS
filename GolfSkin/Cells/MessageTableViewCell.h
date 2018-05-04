//
//  MessageTableViewCell.h
//  uomi
//
//  Created by scs on 10/25/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viewOtherShadow;
@property (strong, nonatomic) IBOutlet UIView *viewOtherContent;
@property (strong, nonatomic) IBOutlet UILabel *lblOtherMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblOtherName;
@property (strong, nonatomic) IBOutlet UILabel *lblOtherTime;
@property (strong, nonatomic) IBOutlet UIView *viewOtherTime;

@property (strong, nonatomic) IBOutlet UIView *viewMeShadow;
@property (strong, nonatomic) IBOutlet UIView *viewMeContent;
@property (strong, nonatomic) IBOutlet UILabel *lblMeMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblMeTime;
@property (strong, nonatomic) IBOutlet UIView *viewMeTime;
@end
