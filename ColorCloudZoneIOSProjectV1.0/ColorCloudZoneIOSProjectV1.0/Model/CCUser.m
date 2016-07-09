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
#import "CCItem.h"

static CCUser * currentUserSingleton;

@implementation CCAddressItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary idKey:(NSString *)idKey valueKey:(NSString *)valueKey
{
    self = [super init];
    if (self) {
        self.itemId = [dictionary ccJsonString:idKey];
        self.itemValue = [dictionary ccJsonString:valueKey];
    }
    return self;
}
@end

@implementation CCSaleMarket

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    
    self = [super init];
    if (self) {
        self.saleMarketId = [dictionary ccJsonString:kUserSaleMarketId];
        self.saleMarketName = [dictionary ccJsonString:kUserSaleMarketName];
        self.saleMarketAddress = [dictionary ccJsonString:kUserSaleMarketAddress];
    }
    return self;
}

@end

@implementation CCMember


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.memberId = [dictionary ccJsonString:kMemberId];
        self.mobile = [dictionary ccJsonString:kMemberMobile];
        self.headImgUrl = [dictionary ccJsonString:kMemberHeadImgUrl];
        self.address = [dictionary ccJsonString:kMemberAddress];
        self.username = [dictionary ccJsonString:kMemberUsername];
    }
    return self;
}

@end

@implementation CCUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self fillWithDictionary:dictionary];
    }
    return self;
}

- (void)fillWithDictionary:(NSDictionary *)dictionary
{
    self.userId = [dictionary ccJsonString:kUserId];
    self.role = [dictionary ccJsonInteger:kUserRole];
    self.phpSessid = [dictionary ccJsonString:kUserPHPSessid];
    self.mobile = [dictionary ccJsonString:kUserMobile];
    self.mallName = [dictionary ccJsonString:kUserMallName];
    self.factoryName = [dictionary ccJsonString:kUserFactoryName];
    self.ownerName = [dictionary ccJsonString:kUserOwnerName];
    self.headImgUrl = [dictionary ccJsonString:kUserHeadImgUrl];
    self.cardNum = [dictionary ccJsonString:kUserCardNum];
    self.alipayNum = [dictionary ccJsonString:kUserAlipayNum];
    self.provinceId = [dictionary ccJsonString:kUserProvinceId];
    self.cityId = [dictionary ccJsonString:kUserCityId];
    self.areaId = [dictionary ccJsonString:kUserAreaId];
    self.provinceName = [dictionary ccJsonString:kUserProvinceName];
    self.cityName = [dictionary ccJsonString:kUserCityName];
    self.areaName = [dictionary ccJsonString:kUserAreaName];
    self.address = [dictionary ccJsonString:kUserAddress];
    self.saleMarketId = [dictionary ccJsonString:kUserSaleMarketId];
    self.saleMarketName = [dictionary ccJsonString:kUserSaleMarketName];
    self.saleMarketAddress = [dictionary ccJsonString:kUserSaleMarketAddress];
    self.addrInMarket = [dictionary ccJsonString:kUserAddrInMarket];
    self.remark = [dictionary ccJsonString:kUserRemark];
    self.isFollowed = [dictionary ccJsonInteger:kUserIsFollowed];
    self.newNum = [dictionary ccJsonInteger:kUserNewNum];
    self.totalNum = [dictionary ccJsonInteger:kUserTotalNum];
    self.coverUrl = [dictionary ccJsonString:kUserCoverUrl];

}

- (NSDictionary *)generateDictionary
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (self.userId) [dict setObject:self.userId forKey:kUserId];
    [dict setObject:@(self.role) forKey:kUserRole];
    if (self.phpSessid) [dict setObject:self.phpSessid forKey:kUserPHPSessid];
    if (self.mobile) [dict setObject:self.mobile forKey:kUserMobile];
    if (self.mallName) [dict setObject:self.mallName forKey:kUserMallName];
    if (self.factoryName) [dict setObject:self.factoryName forKey:kUserFactoryName];
    if (self.ownerName) [dict setObject:self.ownerName forKey:kUserOwnerName];
    if (self.headImgUrl) [dict setObject:self.headImgUrl forKey:kUserHeadImgUrl];
    if (self.cardNum) [dict setObject:self.cardNum forKey:kUserCardNum];
    if (self.alipayNum) [dict setObject:self.alipayNum forKey:kUserAlipayNum];
    if (self.provinceId) [dict setObject:self.provinceId forKey:kUserProvinceId];
    if (self.cityId) [dict setObject:self.cityId forKey:kUserCityId];
    if (self.areaId) [dict setObject:self.areaId forKey:kUserAreaId];
    if (self.provinceName) [dict setObject:self.provinceName forKey:kUserProvinceName];
    if (self.cityName) [dict setObject:self.cityName forKey:kUserCityName];
    if (self.areaName) [dict setObject:self.areaName forKey:kUserAreaName];
    if (self.address) [dict setObject:self.address forKey:kUserAddress];
    if (self.saleMarketId) [dict setObject:self.saleMarketId forKey:kUserSaleMarketId];
    if (self.saleMarketName) [dict setObject:self.saleMarketName forKey:kUserSaleMarketName];
    if (self.saleMarketAddress) [dict setObject:self.saleMarketAddress forKey:kUserSaleMarketAddress];
    if (self.addrInMarket) [dict setObject:self.addrInMarket forKey:kUserAddrInMarket];
    if (self.remark) [dict setObject:self.remark forKey:kUserRemark];
    if (self.coverUrl) [dict setObject:self.coverUrl forKey:kUserCoverUrl];
    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (CCUser *)currentUser
{
    if (!currentUserSingleton) {
        NSDictionary * userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
        if (userDict) currentUserSingleton = [[CCUser alloc] initWithDictionary:userDict];
    }
    return currentUserSingleton;
}

+ (void)reloadCurrentUser
{
    NSDictionary * userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    if (userDict) currentUserSingleton = [[CCUser alloc] initWithDictionary:userDict];
}

+ (void)logout
{
    currentUserSingleton = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


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
            CCUser * user = [[CCUser alloc] initWithDictionary:[responseObject ccJsonDictionary:@"data"]];
            user.phpSessid = phpsessid;
            [[NSUserDefaults standardUserDefaults] setObject:[user generateDictionary] forKey:@"currentUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            block(user, nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}
+ (NSURLSessionDataTask *)getUserInfo:(CCUser *)user withBlock:(void(^)(CCUser * user, NSError * error))block
{
    NSDictionary * params = @{kUserId : user.userId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:GetUserInfo params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            [user fillWithDictionary:[responseObject ccJsonDictionary:@"data"]];
            block(user, nil);
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
    [params setObject:user.headImgUrl forKey:kUserHeadImgUrl];
    [params setObject:user.saleMarketId forKey:kUserSaleMarketId];
    [params setObject:user.provinceId forKey:kUserProvinceId];
    [params setObject:user.cityId forKey:kUserCityId];
    [params setObject:user.areaId forKey:kUserAreaId];
    if (user.remark) [params setObject:user.remark forKey:kUserRemark];
    if (user.role == UserRoleMall) [params setObject:user.mallName forKey:kUserMallName];
    else {
        [params setObject:user.factoryName forKey:kUserFactoryName];
        [params setObject:user.cardNum forKey:kUserCardNum];
        [params setObject:user.alipayNum forKey:kUserAlipayNum];
        [params setObject:user.addrInMarket forKey:kUserAddrInMarket];
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
            [[NSUserDefaults standardUserDefaults] setObject:[user generateDictionary] forKey:@"currentUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            block(user, nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)modifyPwdWithOldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd block:(void(^)(BOOL succeed, NSError * error))block
{
    NSDictionary * params = @{@"old_password" : [oldPwd md5HexDigest],
                              @"new_password" : [newPwd md5HexDigest]};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ModifyPassword params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            block(YES, nil);
        } else {
            block(NO, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO, error);
    }];
}
+ (NSURLSessionDataTask *)findPwdWithMobile:(NSString *)mobile verifyCode:(NSString *)verifyCode newPwd:(NSString *)newPwd block:(void(^)(BOOL succeed, NSError * error))block
{
    NSDictionary * params = @{kUserMobile : mobile,
                              kUserVerifyCode : verifyCode,
                              @"new_password" : [newPwd md5HexDigest]};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:FindPassword params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            block(YES, nil);
        } else {
            block(NO, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO, error);
    }];
}


+ (NSURLSessionDataTask *)getSaleMarketListWithBlock:(void(^)(NSArray * saleMarketList, NSError * error))block
{
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:GetWholeSaleMarketList params:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSArray * dicts = [responseObject ccJsonArray:@"data"];
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dict in dicts) {
                CCSaleMarket * market = [[CCSaleMarket alloc]initWithDictionary:dict];
                [arr addObject:market];
            }
            block([NSArray arrayWithArray:arr], nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)getProvinceListWithBlock:(void(^)(NSArray * provinceList, NSError * error))block
{
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:GetProvinceList params:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSArray * dicts = [responseObject ccJsonArray:@"data"];
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dict in dicts) {
                CCAddressItem * item = [[CCAddressItem alloc]initWithDictionary:dict idKey:kUserProvinceId valueKey:kUserProvinceName];
                [arr addObject:item];
            }
            block([NSArray arrayWithArray:arr], nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)getCityListByProvinceId:(NSString *)provinceId withBlock:(void(^)(NSArray * cityList, NSError * error))block
{
    NSDictionary * params = @{kUserProvinceId : provinceId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:GetCityList params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSArray * dicts = [responseObject ccJsonArray:@"data"];
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dict in dicts) {
                CCAddressItem * item = [[CCAddressItem alloc]initWithDictionary:dict idKey:kUserCityId valueKey:kUserCityName];
                [arr addObject:item];
            }
            block([NSArray arrayWithArray:arr], nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)getAreaListByCityId:(NSString *)cityId withBlock:(void(^)(NSArray * areaList, NSError * error))block
{
    NSDictionary * params = @{kUserCityId : cityId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:GetAreaList params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSArray * dicts = [responseObject ccJsonArray:@"data"];
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dict in dicts) {
                CCAddressItem * item = [[CCAddressItem alloc]initWithDictionary:dict idKey:kUserAreaId valueKey:kUserAreaName];
                [arr addObject:item];
            }
            block([NSArray arrayWithArray:arr], nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)addMember:(CCMember *)member withBlock:(void (^)(CCMember *, NSError *))block
{
    NSDictionary * params = @{kMemberMobile : member.mobile,
                              kMemberUsername : member.username,
                              kMemberHeadImgUrl : member.headImgUrl,
                              kMemberAddress : member.address};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:MemberAdd params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            block(member, nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)getMemberListByMallId:(NSString *)mallId withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *, NSError *))block
{
    NSDictionary * params = @{kItemMallId : mallId,
                              kItemLimit : @(limit),
                              kItemSkip : @(skip)};
    
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:MemberGetMemberList params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSMutableArray * arr = [NSMutableArray array];
            NSDictionary * data = [responseObject ccJsonDictionary:@"data"];
            if (![data isKindOfClass:[NSDictionary class]]) {
                block([NSArray array], nil);
                return ;
            }
            NSArray * listDicts = [data ccJsonArray:@"list"];
            if (![listDicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
            for (NSDictionary * dict in listDicts) {
                CCMember * member = [[CCMember alloc] initWithDictionary:dict];
                [arr addObject:member];
            }
            block(arr, nil);

        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}
+ (NSURLSessionDataTask *)getMemberInfo:(CCMember *)member block:(void (^)(CCMember * member, NSError *error))block
{
    NSDictionary * params = @{@"member_id" : member.memberId};
    
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:MemberGetMemberInfo params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSDictionary * data = [responseObject ccJsonDictionary:@"data"];
            if (![data isKindOfClass:[NSDictionary class]]) {
                block(member, nil);
                return ;
            }
            member.mobile = [data ccJsonString:kMemberUsername];
            member.address = [data ccJsonString:kMemberAddress];
            member.headImgUrl = [data ccJsonString:kMemberHeadImgUrl];
            block(member, nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)follow:(BOOL)follow factory:(NSString *)factoryId withBlock:(void (^)(BOOL, NSError *))block
{
    NSDictionary * params = @{@"isFollow" : @(follow),
                              kItemFactoryId : factoryId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:FollowFactory params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            block(YES, nil);
        } else {
            block(NO, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO, error);
    }];
}

+ (NSURLSessionDataTask *)getFollowedFactoryListWithLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *, NSError *))block
{
    
    NSDictionary * params = @{kItemMallId : [CCUser currentUser].userId,
                              kItemLimit : @(limit),
                              kItemSkip : @(skip)};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:GetFollowedFactoryList params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSMutableArray * arr = [NSMutableArray array];
            NSDictionary * data = [responseObject ccJsonDictionary:@"data"];
            if (![data isKindOfClass:[NSDictionary class]]) {
                block([NSArray array], nil);
                return ;
            }
            NSArray * listDicts = [data ccJsonArray:@"list"];
            if (![listDicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
            for (NSDictionary * dict in listDicts) {
                CCUser * factory = [[CCUser alloc] initWithDictionary:dict];
                [arr addObject:factory];
            }
            block([NSArray arrayWithArray:arr], nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}



+ (NSURLSessionDataTask *)editUserInfoWithBlock:(void (^)(BOOL, NSError *))block
{
    NSDictionary * params = [[CCUser currentUser] generateDictionary];
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:EditUserInfo params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            block(YES, nil);
            [[NSUserDefaults standardUserDefaults] setObject:[[CCUser currentUser] generateDictionary] forKey:@"currentUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            [CCUser reloadCurrentUser];
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CCUser reloadCurrentUser];
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)setUserCover:(NSString *)url withBlock:(void (^)(BOOL, NSError *))block
{
    NSDictionary * params = @{kUserCoverUrl : url};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:EditUserInfo params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            block(YES, nil);
            [CCUser currentUser].coverUrl = url;
            [[NSUserDefaults standardUserDefaults] setObject:[[CCUser currentUser] generateDictionary] forKey:@"currentUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)getBannerWithBlock:(void (^)(NSArray *, NSError *))block
{
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:GetBanner params:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSMutableArray * arr = [NSMutableArray array];
            NSDictionary * data = [responseObject ccJsonDictionary:@"data"];
            if (![data isKindOfClass:[NSDictionary class]]) {
                block([NSArray array], nil);
                return ;
            }
            NSArray * urlDicts = [data ccJsonArray:@"list"];
            if (![urlDicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
            for (NSString * url in urlDicts) {
                [arr addObject:url];
            }
            block([NSArray arrayWithArray:arr], nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];

}


+ (NSURLSessionDataTask *)getLikeListOfMember:(CCMember *)member withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *, NSError *))block
{
    NSDictionary * params = @{@"member_id" : member.memberId,
                              kItemLimit : @(limit),
//                              kItemSkip : @(skip),
                              @"FirstRow" : @(skip)};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:MemberGetLikeList params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            NSMutableArray * arr = [NSMutableArray array];
            NSArray * listDicts = [responseObject ccJsonArray:@"data"];
            if (![listDicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
            for (NSDictionary * dict in listDicts) {
                CCItem * item = [[CCItem alloc] initWithDictionary:dict];
                [arr addObject:item];
            }
            block(arr, nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)checkMemberRegisteredByMobile:(NSString *)mobile withBlock:(void (^)(BOOL, NSError *))block
{
    NSDictionary * params = @{kMemberMobile : mobile};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:MemberCheckRegister params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            NSInteger data = [responseObject ccJsonInteger:@"data"];
            block(data?YES : NO, nil);
        } else {
            block(NO, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO, error);
    }];

}
@end
