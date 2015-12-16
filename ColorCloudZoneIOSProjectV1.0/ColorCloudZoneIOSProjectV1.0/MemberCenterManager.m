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
#import "MLNavigationController.h"
@implementation MemberCenterManager

static MemberCenterManager *singletonInstance;


- (AVUser*)currentUser{
    return [AVUser currentUser];
}

- (MEMBERCENTERUSERTYPE)currentUserType {
    return ((NSNumber *)[[AVUser currentUser] objectForKey:@"userType"]).integerValue;
}


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

+ (void)startLoginAndRegistProcedure{
    MLTabBarViewController *tab = [MLTabBarViewController sharedInstance];
    if (tab) {
        [tab presentLoginAndRegistProcedure];
    }
}

+ (void)logout{
    [AVUser logOut];
}


- (void)setCurrentUserType:(MEMBERCENTERUSERTYPE) userType withCompletion:(void(^)(BOOL success, NSError *error))handler{
    if ([self.class islogin]) {
        AVUser *currentUser = [AVUser currentUser];
       //TODO 设置userType
        [currentUser setObject:@(userType) forKey:@"userType"];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error && succeeded) {
                
            }
            if (handler) {
                handler(succeeded,error);
            }
        }];
    }else{
        [self.class startLoginAndRegistProcedure];
    }
}

+ (void)presentLoginWorkflowWithVC:(UIViewController *)viewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    MLNavigationController *navi = [[MLNavigationController alloc]initWithRootViewController:loginVC];
    [viewController presentViewController:loginVC animated:YES completion:nil];
}
@end
