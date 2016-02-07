//
//  CCUser.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/2/2.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "CCUser.h"
#import "CCAppDotNetClient.h"
#import "NSString+MD5.h"

@implementation CCUser
+ (NSURLSessionDataTask *)loginWithMobile:(NSString *)mobile password:(NSString *)password withBlock:(void(^)(CCUser * user, NSError * error))block
{
    NSDictionary * params = @{@"mobile" : mobile,
                              @"password" : [password md5HexDigest]};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:Login params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//    NSDictionary * user = [[NSDictionary alloc] initWithObjectsAndKeys:username, AcntUsernameKey,
//                           password, @"password", nil];
//    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:user, @"user", nil];
//    return [[ZQAppDotNetAPIClient sharedInstance] POST:@"guest/login" parameters:[NSDictionary dictionaryWithObject:[ZQUtils getJsonStringFromDict:params] forKey:@"params"] success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject objectForKey:@"error"]) {
//            if (block) block(nil, [ZQUtils errorFromDict:[responseObject objectForKey:@"error"]]);
//        } else {
//            NSDictionary * result = [responseObject objectForKey:@"result"];
//            [[NSUserDefaults standardUserDefaults] setObject:[ZQUtils dictWithoutNullFromDict:result] forKey:@"currentAcnt"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            if (block) block([Acnt currentAcnt], nil);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (block) block(nil, error);
//    }];
}
@end
