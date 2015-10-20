//
//  MemberCenterManager.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/20.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "MemberCenterManager.h"
#import "AVUser.h"
#import "MLTabBarViewController.h"

@implementation MemberCenterManager

static MemberCenterManager *singletonInstance;
+ (instancetype)singletonInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonInstance = [[MemberCenterManager alloc]init];
    });
    return singletonInstance;
}

+(BOOL)islogin{
    AVUser *currentUser = [AVUser currentUser];
    return currentUser?YES:NO;
}

- (void)startLoginAndRegistProcedure{
    MLTabBarViewController *tab = [MLTabBarViewController sharedInstance];
    if (tab) {
        [tab presentLoginAndRegistProcedure];
    }
}

+ (void)logout{
    [AVUser logOut];
}
@end
