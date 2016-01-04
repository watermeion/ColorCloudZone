//
//  ComSettingsTableViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/23.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "ComSettingsTableViewController.h"
#import "SVProgressHud.h"

@interface ComSettingsTableViewController ()

@end

@implementation ComSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _nameLabel.text = @"";
    [SVProgressHUD showInfoWithStatus:@"正在获取信息"];
    AVObject * manufacture = [[AVUser currentUser] objectForKey:@"manufacture"];
    [manufacture fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
