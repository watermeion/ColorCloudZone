//
//  MLShopViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/17.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "MLShopViewController.h"

static NSString *const kMLShopContainerPushSegue = @"MLShopContainerPushSegue";





@implementation MLShopViewController

- (void)viewDidLoad
{

    //设置NavigationBar
    UIBarButtonItem *moreFeaturesLeftBarItem = [[UIBarButtonItem alloc]
                                                initWithImage:[UIImage imageNamed:@"moreBarIcon_black.png"]
                                                style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(moreFeaturesLeftBarAction)];

    moreFeaturesLeftBarItem.tintColor = [UIColor blackColor];

    UIBarButtonItem *chatFeaturesLeftBarItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chatIcon_black.png"] style:UIBarButtonItemStylePlain target:self action:@selector(chatFeaturesBarAction)];

    chatFeaturesLeftBarItem.tintColor = [UIColor blackColor];

    self.navigationItem.rightBarButtonItems = @[ moreFeaturesLeftBarItem,chatFeaturesLeftBarItem ];
    self.navigationItem.title = @"我的店铺";

}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)moreFeaturesLeftBarAction
{
    
    
    
}

- (void)chatFeaturesBarAction
{
    
    
    
}



@end
