//
//  MLShopViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/17.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "MLShopViewController.h"
#import "MLShopContainViewController.h"
#import "UIImageView+WebCache.h"
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

    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width / 2.0;
    AVObject * shop = [[AVUser currentUser] objectForKey:@"shop"];
    [shop fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            self.nameLabel.text = [object objectForKey:@"shopName"];
            AVFile * avatar = [shop objectForKey:@"shopLogo"];
            [self.avatar sd_setImageWithURL:[NSURL URLWithString:avatar.url]];
            
        }
    }];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    MLShopContainViewController * vc = (MLShopContainViewController*)segue.destinationViewController;
    vc.parentVC = self;
    self.selectionBar.delegate = vc;
}

@end
