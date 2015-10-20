//
//  MemberCenterManager.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/20.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberCenterManager : NSObject

+ (instancetype) singletonInstance;
+ (BOOL) islogin;

- (void)startLoginAndRegistProcedure;

+ (void)logout;

@end
