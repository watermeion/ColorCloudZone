//
//  CCUser.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/2/2.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserId                 @"user_id"
#define kUserMobile             @"mobile"
#define kUserPassword           @"password"
#define kUserPHPSessid          @"PHPSessid"
#define kUserVerifyCode         @"verify_code"
#define kUserMallName           @"mall_name"
#define kUserFactoryName        @"factory_name"
#define kUserRole               @"role_type"
#define kUserOwnerName          @"realname"
#define kUserHeadImgUrl         @"headimgurl"
#define kUserCardNum            @"bank_card_number"
#define kUserAlipayNum          @"alipay_number"
#define kUserProvinceId         @"province_id"
#define kUserCityId             @"city_id"
#define kUserAreaId             @"area_id"
#define kUserProvinceName       @"province_name"
#define kUserCityName           @"city_name"
#define kUserAreaName           @"area_name"
#define kUserAddress            @"address"
#define kUserVerifyCode         @"verify_code"
#define kUserSaleMarketId       @"wholesale_market_id"
#define kUserSaleMarketName     @"wholesale_market_name"
#define kUserSaleMarketAddress  @"address_detail"
#define kUserAddrInMarket       @"address_in_market"
#define kUserRemark             @"remark"
#define kUserIsFollowed         @"isFollowed"
#define kUserNewNum             @"new_num"
#define kUserTotalNum           @"total_num"
#define kUserCoverUrl           @"background_pic"

#define kMemberMobile           kUserMobile
#define kMemberAddress          @"address_detail"
#define kMemberUsername         @"username"
#define kMemberHeadImgUrl       kUserHeadImgUrl

typedef NS_ENUM(NSUInteger, UserRole) {
    UserRoleUndefined   = 0,
    UserRoleMall        = 3,
    UserRoleFactory     = 4,
    
};

@interface CCAddressItem : NSObject
@property (nonatomic, strong) NSString * itemId;
@property (nonatomic, strong) NSString * itemValue;
@end


@interface CCSaleMarket : NSObject
@property (nonatomic, strong) NSString * saleMarketId;
@property (nonatomic, strong) NSString * saleMarketName;
@property (nonatomic, strong) NSString * saleMarketAddress;
@end

@interface CCMember : NSObject
@property (nonatomic, strong) NSString * headImgUrl;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * username;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface CCUser : NSObject
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * phpSessid;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * verifyCode;
@property (nonatomic, assign) UserRole role;
@property (nonatomic, strong) NSString * mallName;
@property (nonatomic, strong) NSString * factoryName;
@property (nonatomic, strong) NSString * ownerName;
@property (nonatomic, strong) NSString * headImgUrl;
@property (nonatomic, strong) NSString * cardNum;
@property (nonatomic, strong) NSString * alipayNum;
@property (nonatomic, strong) NSString * provinceId;
@property (nonatomic, strong) NSString * cityId;
@property (nonatomic, strong) NSString * areaId;
@property (nonatomic, strong) NSString * provinceName;
@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, strong) NSString * areaName;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * saleMarketId;
@property (nonatomic, strong) NSString * saleMarketName;
@property (nonatomic, strong) NSString * saleMarketAddress;
@property (nonatomic, strong) NSString * addrInMarket;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, assign) NSInteger newNum;
@property (nonatomic, assign) NSInteger totalNum;
@property (nonatomic, strong) NSString * coverUrl;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (CCUser *)currentUser;
+ (void)logout;

+ (NSURLSessionDataTask *)loginWithMobile:(NSString *)mobile password:(NSString *)password withBlock:(void(^)(CCUser * user, NSError * error))block;
+ (NSURLSessionDataTask *)sendVerifyCodeToMobile:(NSString *)mobile withBlock:(void(^)(BOOL succeed, NSError * error))block;
+ (NSURLSessionDataTask *)checkVerifyCode:(NSString *)code mobile:(NSString *)mobile withBlock:(void(^)(BOOL succeed, NSError * error))block;
+ (NSURLSessionDataTask *)checkMobileRegistered:(NSString *)mobile withBlock:(void(^)(BOOL registered, NSError * error))block;
+ (NSURLSessionDataTask *)signupUser:(CCUser *)user withBlock:(void(^)(CCUser * user, NSError * error))block;

+ (NSURLSessionDataTask *)getSaleMarketListWithBlock:(void(^)(NSArray * saleMarketList, NSError * error))block;
+ (NSURLSessionDataTask *)getProvinceListWithBlock:(void(^)(NSArray * provinceList, NSError * error))block;
+ (NSURLSessionDataTask *)getCityListByProvinceId:(NSString *)provinceId withBlock:(void(^)(NSArray * cityList, NSError * error))block;
+ (NSURLSessionDataTask *)getAreaListByCityId:(NSString *)cityId withBlock:(void(^)(NSArray * areaList, NSError * error))block;


+ (NSURLSessionDataTask *)addMember:(CCMember *)member withBlock:(void(^)(CCMember * member, NSError * error))block;
+ (NSURLSessionDataTask *)getMemberListByMallId:(NSString *)mallId withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void(^)(NSArray * memberList, NSError * error))block;

+ (NSURLSessionDataTask *)follow:(BOOL)follow factory:(NSString *)factoryId withBlock:(void(^)(BOOL success, NSError * error))block;
+ (NSURLSessionDataTask *)getFollowedFactoryListWithLimit:(NSInteger)limit skip:(NSInteger)skip block:(void(^)(NSArray * followList, NSError * error))block;

+ (NSURLSessionDataTask *)editUserInfo:(CCUser*)user withBlock:(void(^)(BOOL succeed, NSError * error))block;
+ (NSURLSessionDataTask *)setUserCover:(NSString *)url withBlock:(void(^)(BOOL succeed, NSError * error))block;
+ (NSURLSessionDataTask *)getBannerWithBlock:(void(^)(NSArray * banner, NSError *error))block;

@end
