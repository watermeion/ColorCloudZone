//
//  Shop.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/11/2.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "Shop.h"





@implementation Shop

@dynamic shopAddress;
@dynamic shopAddressGeo;
@dynamic shopCityCode;
@dynamic shopCityName;
@dynamic shopClasses;
@dynamic shopKeyword;
@dynamic shopLogo;
@dynamic shopName;
@dynamic shopOwnerName;
@dynamic shopOwnerPhone;
@dynamic shopProvince;
@dynamic shopSignature;
@dynamic showInHome;

@dynamic userId;

+ (NSString *)parseClassName {
    return @"Shop";
}

@end
