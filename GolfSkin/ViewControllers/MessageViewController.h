//
//  MessageViewController.h
//  uomi
//
//  Created by scs on 10/25/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"

@interface MessageViewController : UIViewController<UIBubbleTableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tblMessages;
@property (strong, nonatomic) IBOutlet UITextField *textfieldMessage;
@property (strong, nonatomic) IBOutlet UIView *viewInput;

@property (strong, nonatomic) NSMutableArray *arrUsers;
@property (strong, nonatomic) NSString *receipt_id;
@property (strong, nonatomic) NSMutableDictionary *sender_info;

- (IBAction)OnCamera:(id)sender;
- (IBAction)Onback:(id)sender;
- (IBAction)OnSend:(id)sender;
@end
