//
//  CCItem.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/29.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kItemId                 @"item_id"
#define kItemName               @"item_name"
#define kItemFactoryId          @"factory_id"
#define kItemSN                 @"item_sn"
#define kItemClassId            @"class_id"
#define kItemClassName          @"class_name"
#define kItemClassIconUrl       @"class_icon"
#define kItemSortId             @"sort_id"
#define kItemSortName           @"sort_name"
#define kItemTypeId             @"item_type_id"
#define kItemTypeName           @"item_type_name"
#define kItemPrice              @"cost_price"
#define kItemCover              @"base_pic"
#define kItemAssistantPics      @"assistant_pics"
#define kItemDescPics           @"desc_pics"
#define kItemColorProperty      @"item_property0"
#define kItemSizeProperty       @"item_property1"
#define kItemExtendProperty     @"extend_property"
#define kItemPropertyValue      @"property_value"
#define kItemPropertyValueId    @"property_value_id"
#define kItemDesc               @"description"
#define kItemHasSku             @"has_sku"

@interface CCItemType : NSObject
@property (nonatomic, strong) NSString * typeId;
@property (nonatomic, strong) NSString * name;
@end
@interface CCItemClass : NSObject
@property (nonatomic, strong) NSString * classId;
@property (nonatomic, strong) NSString * className;
@property (nonatomic, strong) NSString * classIconUrl;
@end
@interface CCItemSort : NSObject
@property (nonatomic, strong) NSString * sortId;
@property (nonatomic, strong) NSString * sortName;
@end

//@interface CCItemProperty : NSObject
//@property (nonatomic, strong) NSString * propertyId;
//@property (nonatomic, strong) NSString * name;
//@property (nonatomic, strong) NSArray * propertyValues;
//@end

@interface CCItemPropertyValue : NSObject
@property (nonatomic, strong) NSString * valueId;
@property (nonatomic, strong) NSString * value;
@end

@interface CCItem : NSObject
@property (nonatomic, strong) NSString * itemId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * factoryId;
@property (nonatomic, strong) NSString * SN;
@property (nonatomic, strong) CCItemClass * itemClass;
@property (nonatomic, strong) CCItemSort * itemSort;
@property (nonatomic, strong) CCItemType * itemType;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString * cover;
@property (nonatomic, strong) NSMutableArray * assistantPics;
@property (nonatomic, strong) NSMutableArray * descPics;
@property (nonatomic, strong) NSMutableArray * colorProperty;
@property (nonatomic, strong) NSMutableArray * sizeProperty;
@property (nonatomic, strong) NSMutableArray * extendProperty;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) BOOL hasSku;


+ (NSURLSessionDataTask *)getClassListWithBlock:(void(^)(NSArray * classList, NSError * error))block;
+ (NSURLSessionDataTask *)getSortListByClassId:(NSString *)classId withBlock:(void(^)(NSArray * sortList, NSError * error))block;
+ (NSURLSessionDataTask *)getTypeListWithBlock:(void(^)(NSArray * typeList, NSError * error))block;
+ (NSURLSessionDataTask *)getExtendPropertyListByTypeId:(NSString *)typeId withBlock:(void(^)(NSArray * extendPropertyList, NSError * error))block;
+ (NSURLSessionDataTask *)getColorListByTypeId:(NSString *)typeId withBlock:(void(^)(NSArray * colorList, NSError * error))block
;
+ (NSURLSessionDataTask *)getSizeListByTypeId:(NSString *)typeId withBlock:(void(^)(NSArray * sizeList, NSError * error))block
;
+ (NSURLSessionDataTask *)uploadItem:(CCItem *)item withBlock:(void(^)(CCItem * item, NSError * error))block;
@end
