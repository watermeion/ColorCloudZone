//
//  Product.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/25.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "AVObject.h"
#import "AVObject+Subclass.h"
#import "GBSubClass.h"
#import <AVOSCloud/AVSubclassing.h>
@interface Product : GBSubClass <AVSubclassing>

//lazy Model,
@property (nonatomic,strong) NSString *productFactory;
@property (nonatomic,strong) NSString *productColor;

@property (nonatomic,strong) NSNumber *like;
@property (nonatomic,strong) NSString *productDescri;
@property (nonatomic,strong) AVFile   *productImage;
@property (nonatomic,strong) NSString *productShoulderSize;
@property (nonatomic,strong) NSString *productSize;
@property (nonatomic,strong) NSString *productStyle;

@property (nonatomic,strong) NSNumber *productMemberWantTime;
@property (nonatomic,strong) NSString *productMaterial;
@property (nonatomic,strong) NSNumber *productSaleNum;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSNumber *productStock;
@property (nonatomic,strong) NSNumber *productPriseCount;
@property (nonatomic,strong) NSString *productNum;
@property (nonatomic,strong) NSString *productWaistSize;
@property (nonatomic,strong) NSNumber *productPrice;

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSNumber *productInquiryTime;
@property (nonatomic,strong) NSString *productBustSize;
@property (nonatomic,strong) NSNumber *productWholeSale;
@property (nonatomic,strong) NSString *productAddress;

@property (nonatomic,strong) NSNumber *collection;
@property (nonatomic,strong) NSNumber *productShopWantTime;



@end
