//
//  Shop.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/11/2.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "GBSubClass.h"

@interface Shop : GBSubClass


@property (nonatomic,strong) NSString *shopAddress;
@property (nonatomic,strong) AVGeoPoint *shopAddressGeo;
@property (nonatomic,strong) NSString *shopCityCode;
@property (nonatomic,strong) NSString *shopCityName;
@property (nonatomic,strong) NSString *shopClasses;
@property (nonatomic,strong) NSString *shopKeyword;
@property (nonatomic,strong) AVFile *shopLogo;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSString *shopOwnerName;
@property (nonatomic,strong) NSString *shopOwnerPhone;
@property (nonatomic,strong) NSString *shopProvince;
@property (nonatomic,strong) NSString *shopSignature;
@property (nonatomic) BOOL showInHome;

@property (nonatomic,strong) NSString *userId;

@end
