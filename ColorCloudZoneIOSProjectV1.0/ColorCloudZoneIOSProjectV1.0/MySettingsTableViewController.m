//
//  MySettingsTableViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/23.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "MySettingsTableViewController.h"
#import "MemberCenterManager.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LoginAndRegistNaviController.h"

@interface MySettingsTableViewController () <UIActionSheetDelegate>

@end

@implementation MySettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewWillAppear:(BOOL)animated
{
    AVObject * shop = [[AVUser currentUser] objectForKey:@"shop"];
    [shop fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//    [shop fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            self.shopNameLabel.text = [object objectForKey:@"shopName"];
            self.nameLabel.text = [object objectForKey:@"shopOwnerName"];
            self.addressLabel.text = [object objectForKey:@"shopAddress"];
            AVFile * avatar = [shop objectForKey:@"shopLogo"];
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar.url]];
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == ([tableView numberOfSections] - 1) && indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定要退出吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认退出" otherButtonTitles:nil];
        [actionSheet showInView:self.view];
        actionSheet.tag = 10;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10 && buttonIndex == 0) {
        
        LoginAndRegistNaviController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginAndRegistNaviController"];
        AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
        delegate.window.rootViewController = vc;
        [AVUser logOut];
    }
}
@end
