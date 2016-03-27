//
//  CCAppDotNetClient.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 15/7/31.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "CCAppDotNetClient.h"
#import "NSString+MD5.h"
@implementation CCAppDotNetClient

+ (instancetype)sharedInstance
{
    static CCAppDotNetClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CCAppDotNetClient alloc] initWithBaseURL:[NSURL URLWithString:APIHOST]];
        _sharedInstance.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", nil];
//        _sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];
//        _sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
//        [_sharedInstance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [_sharedInstance.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    });
    return _sharedInstance;
}

+ (NSDictionary*)generateParamsWithAPI:(NSString*)apiName params:(NSDictionary*)params
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"appid"];
    [dict setObject:apiName forKey:@"api_name"];
    [dict setObject:@"" forKey:@"PHPSESSID"];
    [dict addEntriesFromDictionary:params];
    NSArray * keys = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSString * token = @"";
    for (NSString * key in keys) {
        if ([keys indexOfObject:key] > 0) token = [token stringByAppendingString:@"&"];
        token = [token stringByAppendingFormat:@"%@=%@", key, dict[key]];
    }
    token = [token stringByAppendingString:@"@J4*A9N7&B^jxY7j6sWv8m5%q_p+z-h="];
    [dict setObject:[token md5HexDigest] forKey:@"token"];
    return dict;
}

+ (BOOL)isTesting
{
    return YES;
}
@end
