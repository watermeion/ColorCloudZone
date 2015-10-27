//
//  GBSubClass.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/25.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "AVObject.h"
#import "AVObject+Subclass.h"
#import <AVOSCloud/AVSubclassing.h>

/**
 *  base class for subclassing
 *  this class has basic properties for AVSubClass
 */
@interface GBSubClass : AVObject <AVSubclassing>

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSDate *updateAt;
@property (nonatomic, strong) NSDate *createdAt;



+ (void)registerSubclasses;

@end
