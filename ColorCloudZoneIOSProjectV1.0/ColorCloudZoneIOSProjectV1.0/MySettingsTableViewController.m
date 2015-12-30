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

@interface MySettingsTableViewController ()

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
    [shop fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            self.nameLabel.text = [object objectForKey:@"shopName"];
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


@end
