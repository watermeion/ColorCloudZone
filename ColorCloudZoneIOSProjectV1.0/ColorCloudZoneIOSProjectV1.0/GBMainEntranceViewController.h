//
//  GBMainEntranceViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/11/10.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "GBCustomViewController.h"
//the entrance for instance
@interface GBMainEntranceViewController : GBCustomViewController
- (void)changeToMainWorkFlow;
+ (instancetype)sharedInstance;
@end
