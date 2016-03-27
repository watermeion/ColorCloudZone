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
#import "NSDictionary+CCJson.h"
#import "NSError+CCError.h"

@implementation CCUser
+ (NSURLSessionDataTask *)loginWithMobile:(NSString *)mobile password:(NSString *)password withBlock:(void(^)(CCUser * user, NSError * error))block
{
    NSDictionary * params = @{kUserMobile : mobile,
                              @"password" : [password md5HexDigest]};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:Login params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
            NSString * cookie = [response.allHeaderFields objectForKey:@"Set-Cookie"];
            NSRange range = [cookie rangeOfString:@"PHPSESSID="];
            NSString * temp = [cookie substringFromIndex:range.location + range.length];
            NSString * phpsessid = [temp substringToIndex:[temp rangeOfString:@";"].location];
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)checkMobileRegistered:(NSString *)mobile withBlock:(void(^)(BOOL registered, NSError * error))block
{
    NSDictionary * params = @{kUserMobile : mobile};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:CheckMobileRegistered params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            if ([responseObject ccJsonInteger:@"data"] == 0) {
                block(NO, nil);
            } else {
                block(YES, nil);
            }
        } else {
            block(NO, [NSError errorDefault]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO, error);
    }];
}
+ (NSURLSessionDataTask *)sendVerifyCodeToMobile:(NSString *)mobile withBlock:(void(^)(BOOL succeed, NSError * error))block
{
    NSDictionary * params = @{kUserMobile : mobile};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:CheckMobileRegistered params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            block (YES, nil);
        } else {
            block(NO, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO, error);
    }];
}

+ (NSURLSessionDataTask *)checkVerifyCode:(NSString *)code mobile:(NSString *)mobile withBlock:(void(^)(BOOL succeed, NSError * error))block
{
    
    NSDictionary * params = @{kUserMobile : mobile,
                              kUserVerifyCode : code};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:CheckMobileRegistered params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            if ([responseObject ccJsonInteger:@"data"] == 1) {
                block(YES, nil);
            } else {
                block(NO, nil);
            }
        } else {
            block(NO, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO, error);
    }];
}

+ (NSURLSessionDataTask *)signupUser:(CCUser *)user withBlock:(void(^)(CCUser * user, NSError * error))block
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:user.mobile forKey:kUserMobile];
    [params setObject:[user.password md5HexDigest] forKey:kUserPassword];
    [params setObject:user.verifyCode forKey:kUserVerifyCode];
    [params setObject:@(user.role) forKey:kUserRole];
    [params setObject:user.ownerName forKey:kUserOwnerName];
    [params setObject:user.address forKey:kUserAddress];
    [params setObject:@"default" forKey:kUserHeadImgUrl];
    [params setObject:@"default" forKey:kUserProvince];
    [params setObject:@"default" forKey:kUserCity];
    [params setObject:@"default" forKey:kUserArea];
    [params setObject:@"default" forKey:kUserSaleMarket];
    if (user.role == UserRoleMall) [params setObject:user.mallName forKey:kUserMallName];
    else {
        [params setObject:user.factoryName forKey:kUserFactoryName];
        [params setObject:user.cardId forKey:kUserCardId];
        [params setObject:user.alipayId forKey:kUserAlipayId];
        [params setObject:@"default" forKey:kUserAddrInMarket];
    }
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:Signup params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
            NSString * cookie = [response.allHeaderFields objectForKey:@"Set-Cookie"];
            NSRange range = [cookie rangeOfString:@"PHPSESSID="];
            NSString * temp = [cookie substringFromIndex:range.location + range.length];
            NSString * phpsessid = [temp substringToIndex:[temp rangeOfString:@";"].location];
            user.phpSessid = phpsessid;
            user.userId = [responseObject ccJsonString:kUserId];
            block(user, nil);
        } else {
            block(nil, [NSError errorDefault]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}
@end
