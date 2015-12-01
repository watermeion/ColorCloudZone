//
//  PersonProfileViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/3.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "PersonProfileViewController.h"
#import "MLTabBarViewController.h"

@implementation PersonProfileViewController

- (IBAction)doneAction:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
    MLTabBarViewController *tabbar = [mainStoryboard instantiateViewControllerWithIdentifier:@"SellersTabViewController"];
    [UIApplication sharedApplication].delegate.window.rootViewController = tabbar;
}
- (IBAction)uploadAvatarAction:(id)sender {
}
@end
