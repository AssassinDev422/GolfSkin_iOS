//
//  SlideViewController.m
//  GolfSkin
//
//  Created by scs on 6/10/17.
//  Copyright © 2017 GolfSkin. All rights reserved.
//

#import "SlideViewController.h"
#import "SlideTableViewCell.h"
#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "CreateDraftViewController.h"
#import "ProfileViewController.h"
#import "DraftsViewController.h"
#import "FirstViewController.h"
#import "EventsViewController.h"

@interface SlideViewController ()
{
    NSArray *arrMenu;
    NSArray *arrMenuIcon;
}
@end

@implementation SlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrMenu = [NSArray arrayWithObjects:
               @"Home",
               @"Drafts",
               @"Create Draft",
               @"Drafters",
               @"Draft Players",
               @"Events",
               @"Event Types",
               @"Draft Names",
               @"More Info",
               @"User Profile",
               @"Sign Out",
               nil];
    
    arrMenuIcon = [NSArray arrayWithObjects:
               @"icon_menu_home.png",
               @"icon_menu_drafts.png",
               @"icon_menu_create.png",
               @"icon_menu_drafters.png",
               @"icon_menu_draftees.png",
               @"icon_menu_event.png",
               @"icon_menu_eventtype.png",
               @"icon_menu_draftname.png",
               @"icon_menu_moreinfo.png",
               @"icon_menu_profile.png",
               @"icon_menu_signout.png",
               nil];
    
    _tblMenu.delegate = self;
    _tblMenu.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrMenu count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SlideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SlideTableViewCell"];
    cell.lblMenu.text = [arrMenu objectAtIndex:indexPath.row];
    cell.imgMenuIcon.image = [UIImage imageNamed:[arrMenuIcon objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWRevealViewController* mainRevealController = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    mainRevealController = self.revealViewController;
    
    UIViewController* frontVC;
    
    if (indexPath.row == 0) {
        frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        ((HomeViewController*)frontVC).isFirst = false;
    }
    else if (indexPath.row == 1) {
        frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftsViewController"];
    }
    else if (indexPath.row == 2) {
        frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateDraftViewController"];
    }
    else if (indexPath.row == 3) {
        frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AllDraftersViewController"];
    }
    else if (indexPath.row == 4) {
        frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DrafteesViewController"];
    }
    else if (indexPath.row == 5) {
        frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsViewController"];
        ((EventsViewController*)frontVC).strNavigateFrom = @"menu";
    }
    else if (indexPath.row == 6) {
        frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventTypesViewController"];
    }
    else if (indexPath.row == 7) {
        frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftNameViewController"];
    }
    else if (indexPath.row == 8) {
        frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreInfoViewController"];
    }
    else if (indexPath.row == 9) {
        frontVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    }
    else if (indexPath.row == 10) {
        [commonUtils setUserDefault:@"isLoggedin" withFormat:@"0"];
        FirstViewController *firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
        [self.navigationController pushViewController:firstVC animated:NO];
    }
    
    UINavigationController *frontVCNavigate = [[UINavigationController alloc]initWithRootViewController:frontVC];
    [frontVCNavigate setNavigationBarHidden:false];
    
    [mainRevealController pushFrontViewController:frontVCNavigate animated:YES];
}

@end
