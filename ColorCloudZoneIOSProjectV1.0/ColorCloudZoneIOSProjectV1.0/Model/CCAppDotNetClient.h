//
//  CCAppDotNetClient.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 15/7/31.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "NetAccessAPI.h"

@interface CCAppDotNetClient : AFHTTPSessionManager
+ (instancetype)sharedInstance;
+ (NSDictionary*)generateParamsWithAPI:(NSString*)apiName params:(NSDictionary*)params;
@end
