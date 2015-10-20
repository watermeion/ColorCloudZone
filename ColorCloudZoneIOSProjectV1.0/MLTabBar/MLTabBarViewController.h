//
//  MLTabBarViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/17.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "marcoHeader.h"

static NSString *const kMainPresentedLoginAndRegistSegue = @"MainPresentedLoginAndRegistSegue";
@interface MLTabBarViewController : UITabBarController

+ (instancetype)sharedInstance;
- (void)presentLoginAndRegistProcedure;
@end
