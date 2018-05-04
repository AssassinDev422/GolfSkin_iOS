//
//  SlideViewController.h
//  GolfSkin
//
//  Created by scs on 6/10/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tblMenu;

@end
