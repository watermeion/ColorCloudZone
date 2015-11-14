//
//  MLTabBarViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/17.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "MLTabBarViewController.h"
#import "AVUser.h"
#import "MemberCenterManager.h"


@interface MLTabBarViewController ()

@end

@implementation MLTabBarViewController

static MLTabBarViewController *sharedInstance = nil;
- (void)viewDidLoad {
    sharedInstance = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tabBar setTintColor:BASEBARCOLOR];
    self.tabBar.translucent=NO;
    [self setTabBarImage];
    
}

+ (instancetype)sharedInstance{
    return sharedInstance;
}

- (void)setTabBarImage
{
    
    [self.tabBar setTintColor:BASEBARCOLOR];
    self.tabBar.translucent=NO;
    
    UITabBar *tabBar=self.tabBar;
    
    if (tabBar.items.count !=4) {
        return;
    }
    
    
    UITabBarItem *tabBarItem1=[tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2=[tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3=[tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4=[tabBar.items objectAtIndex:3];
    
    tabBarItem1.title=@"店铺";
    
    tabBarItem2.title=@"市场";
    
    tabBarItem3.title=@"会员";
    
    tabBarItem4.title=@"我";
    
    tabBarItem1.selectedImage=[[UIImage imageNamed:@"tab1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.image=[[UIImage imageNamed:@"tab1_unshoot"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem2.selectedImage=[[UIImage imageNamed:@"tab2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.image=[[UIImage imageNamed:@"tab2_unshoot"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem3.selectedImage=[[UIImage imageNamed:@"tab3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.image=[[UIImage imageNamed:@"tab3_unshoot"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem4.selectedImage=[[UIImage imageNamed:@"tab4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.image=[[UIImage imageNamed:@"tab4_unshoot"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)presentLoginAndRegistProcedure{
    [self performSegueWithIdentifier:kMainPresentedLoginAndRegistSegue sender:self];
}


@end
