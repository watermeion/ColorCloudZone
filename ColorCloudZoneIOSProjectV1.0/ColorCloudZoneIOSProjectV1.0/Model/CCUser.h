//
//  CCUser.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/2/2.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserId             @"user_id"
#define kUserMobile         @"mobile"
#define kUserPassword       @"password"
#define kUserPHPSessid      @"PHPSessid"
#define kUserVerifyCode     @"verify_code"
#define kUserMallName       @"mall_name"
#define kUserFactoryName    @"factory_name"
#define kUserRole           @"role_type"
#define kUserOwnerName      @"realname"
#define kUserHeadImgUrl     @"headimgurl"
#define kUserCardNum        @"bank_card_number"
#define kUserAlipayNum      @"alipay_number"
#define kUserProvinceId     @"province_id"
#define kUserCityId         @"city_id"
#define kUserAreaId         @"area_id"
#define kUserAddress        @"address"
#define kUserVerifyCode     @"verify_code"
#define kUserSaleMarketId   @"wholesale_market_id"
#define kUserAddrInMarket   @"address_in_market"
#define kUserRemark         @"remark"

typedef NS_ENUM(NSUInteger, UserRole) {
    UserRoleUndefined   = 0,
    UserRoleMall        = 3,
    UserRoleFactory     = 4,
    
};

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
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * saleMarketId;
@property (nonatomic, strong) NSString * addrInMarket;
@property (nonatomic, strong) NSString * remark;


+ (CCUser *)currentUser;
+ (void)logout;

+ (NSURLSessionDataTask *)loginWithMobile:(NSString *)mobile password:(NSString *)password withBlock:(void(^)(CCUser * user, NSError * error))block;
+ (NSURLSessionDataTask *)sendVerifyCodeToMobile:(NSString *)mobile withBlock:(void(^)(BOOL succeed, NSError * error))block;
+ (NSURLSessionDataTask *)checkVerifyCode:(NSString *)code mobile:(NSString *)mobile withBlock:(void(^)(BOOL succeed, NSError * error))block;
+ (NSURLSessionDataTask *)checkMobileRegistered:(NSString *)mobile withBlock:(void(^)(BOOL registered, NSError * error))block;
+ (NSURLSessionDataTask *)signupUser:(CCUser *)user withBlock:(void(^)(CCUser * user, NSError * error))block;
@end
