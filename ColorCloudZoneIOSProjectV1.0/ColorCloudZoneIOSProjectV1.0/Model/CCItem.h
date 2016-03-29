//
//  CCItem.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/29.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kItemId         @"item_id"
#define kItemName       @"item_name"
#define kItemFactoryId  @"factory_id"
#define kItemSN         @"item_sn"
#define kItemClassId    @"class_id"
#define kItemTypeId     @"item_type_id"
#define kItemPrice      @"cost_price"
#define kItemCover      @"base_pic"
#define kItemAssistantPics  @"assistant_pics"
#define kItemDescPics       @"desc_pics"
#define kItemColorProperty  @"item_property0"
#define kItemSizeProperty   @"item_property1"
#define kItemExtendProperty @"extend_property"
#define kItemDesc           @"description"
#define kItemHasSku         @"has_sku"

@interface CCItem : NSObject
@property (nonatomic, strong) NSString * itemId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * factoryId;
@property (nonatomic, strong) NSString * SN;
@property (nonatomic, strong) NSString * classId;
@property (nonatomic, strong) NSString * typeId;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString * cover;
@property (nonatomic, strong) NSArray * assistantPics;
@property (nonatomic, strong) NSArray * descPics;
@property (nonatomic, strong) NSArray * colorProperty;
@property (nonatomic, strong) NSArray * sizeProperty;
@property (nonatomic, strong) NSString * extendProperty;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) BOOL hasSku;


+ (NSURLSessionDataTask *)getItemTypeListWithBlock:(void(^)(NSArray * typeList, NSError * error))block;
+ (NSURLSessionDataTask *)getItemSkuByTypeId:(NSString *)typeId withBlock:(void(^)(NSArray * skuList, NSError * error))block;
+ (NSURLSessionDataTask *)getExtendPropertyListByTypeId:(NSString *)typeId withBlock:(void(^)(NSArray * extendPropertyList, NSError * error))block;
@end
