//
//  GBCustomViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/20.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "GBCustomViewController.h"
#import "MemberCenterManager.h"

@interface GBCustomViewController ()

@end

@implementation GBCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkUserStatus];
    
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


- (void)checkUserStatus{
    if (![MemberCenterManager islogin]) {
        [[MemberCenterManager singletonInstance] startLoginAndRegistProcedure];
    }
}


@end
