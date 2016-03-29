//
//  AppDelegate.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/13.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "AppDelegate.h"

#import <AVOSCloud/AVOSCloud.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MemberCenterManager.h"
#import "GBSubClass.h"
#import "GBMainEntranceViewController.h"
#import "LoginAndRegistNaviController.h"
#import "MLTabBarViewController.h"
#import "RegisterAfterViewController.h"
#import "CCFile.h"
#import "CCItem.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application
    [AVOSCloud setApplicationId:@"ipyoirkh7rdk3e7e6uxu7fwib7wbteoy0bgfc0mj9upi3shi"
                      clientKey:@"a4bid0onrnho8kfdw9qyqwxm972pbk20wbgvz6kgz16r1w8a"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //
    AVObject *launchRecordObject = [AVObject objectWithClassName:@"LaunchRecordObject"];
    [launchRecordObject setObject:@"bar" forKey:@"foo"];
    [launchRecordObject setObject:launchOptions forKey:@"LaunchOption"];
    [launchRecordObject save];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
    //
    [GBSubClass registerSubclasses];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
    if ([CCUser currentUser]) {
        if ([CCUser currentUser].role == UserRoleFactory) {
            UINavigationController * nav = [mainStoryboard instantiateViewControllerWithIdentifier:@"SupplierNavigationController"];
            self.window.rootViewController = nav;
        }else if([CCUser currentUser].role == UserRoleMall){
            MLTabBarViewController * tabbar = [mainStoryboard instantiateViewControllerWithIdentifier:@"SellersTabViewController"];
            self.window.rootViewController = tabbar;
        } else {
            [CCUser logout];
            LoginAndRegistNaviController * vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginAndRegistNaviController"];
            self.window.rootViewController = vc;
        }
    }
    else {
        LoginAndRegistNaviController * vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginAndRegistNaviController"];
        self.window.rootViewController = vc;

    }
    [CCItem getItemTypeListWithBlock:^(NSArray *typeList, NSError *error) {
        
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
