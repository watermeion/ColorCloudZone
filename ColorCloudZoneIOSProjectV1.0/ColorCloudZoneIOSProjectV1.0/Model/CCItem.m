//
//  CCItem.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/29.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "CCItem.h"

#import "CCAppDotNetClient.h"
#import "NSString+MD5.h"
#import "NSDictionary+CCJson.h"
#import "NSError+CCError.h"


@implementation CCItem
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        
//        @property (nonatomic, strong) NSString * itemId;
//        @property (nonatomic, strong) NSString * itemNam;
//        @property (nonatomic, strong) NSString * factoryId;
//        @property (nonatomic, strong) NSString * itemSN;
//        @property (nonatomic, strong) NSString * classId;
//        @property (nonatomic, strong) NSString * typeId;
//        @property (nonatomic, assign) float price;
//        @property (nonatomic, strong) NSString * cover;
//        @property (nonatomic, strong) NSArray * assistantPics;
//        @property (nonatomic, strong) NSArray * descPics;
//        @property (nonatomic, strong) NSArray * colorProperty;
//        @property (nonatomic, strong) NSArray * sizeProperty;
//        @property (nonatomic, strong) NSString * extendProperty;
//        @property (nonatomic, strong) NSString * desc;
//        @property (nonatomic, assign) BOOL hasSku;
        
        self.itemId = [dict ccJsonString:kItemId];
        self.name = [dict ccJsonString:kItemName];
        self.factoryId = [dict ccJsonString:kItemFactoryId];
        self.SN = [dict ccJsonString:kItemSN];
    }
    return self;
}

- (NSDictionary *)genarateDictionary
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (self.itemId) [dict setObject:self.itemId forKey:kItemId];
    if (self.name) [dict setObject:self.name forKey:kItemName];
    if (self.factoryId) [dict setObject:self.factoryId forKey:kItemFactoryId];
    if (self.SN) [dict setObject:self.SN forKey:kItemSN];
    if (self.classId) [dict setObject:self.classId forKey:kItemClassId];
    if (self.typeId) [dict setObject:self.typeId forKey:kItemTypeId];
    [dict setObject:@(self.price) forKey:kItemPrice];
    if (self.cover) [dict setObject:self.cover forKey:kItemCover];
    if (self.assistantPics.count > 0) {
        NSString * urls = [self.assistantPics objectAtIndex:0];
        for (NSInteger index = 1; index < self.assistantPics.count; index++)
            urls = [urls stringByAppendingFormat:@";%@",[self.assistantPics objectAtIndex:index]];
        [dict setObject:urls forKey:kItemAssistantPics];
    }
    
    if (self.descPics.count > 0) {
        NSString * urls = [self.descPics objectAtIndex:0];
        for (NSInteger index = 1; index < self.descPics.count; index++)
            urls = [urls stringByAppendingFormat:@";%@",[self.descPics objectAtIndex:index]];
        [dict setObject:urls forKey:kItemDescPics];
    }
    
    
    if (self.colorProperty.count > 0) {
        NSString * ids = [self.colorProperty objectAtIndex:0];
        for (NSInteger index = 1; index < self.colorProperty.count; index++)
            ids = [ids stringByAppendingFormat:@",%@",[self.colorProperty objectAtIndex:index]];
        [dict setObject:ids forKey:kItemColorProperty];
    }
    
    if (self.sizeProperty.count > 0) {
        NSString * ids = [self.sizeProperty objectAtIndex:0];
        for (NSInteger index = 1; index < self.sizeProperty.count; index++)
            ids = [ids stringByAppendingFormat:@",%@",[self.sizeProperty objectAtIndex:index]];
        [dict setObject:ids forKey:kItemSizeProperty];
    }
    
    if (self.extendProperty) [dict setObject:self.extendProperty forKey:kItemExtendProperty];
    if (self.desc) [dict setObject:self.desc forKey:kItemDesc];
    [dict setObject:@(self.hasSku) forKey:kItemHasSku];
    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (NSURLSessionDataTask *)getItemTypeListWithBlock:(void(^)(NSArray * typeList, NSError * error))block
{
    
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetTypeList params:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];

}

+ (NSURLSessionDataTask *)getItemSkuByTypeId:(NSString *)typeId withBlock:(void(^)(NSArray * skuList, NSError * error))block
{
    NSDictionary * params = @{kItemTypeId : typeId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetItemSkuByTypeId params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)getExtendPropertyListByTypeId:(NSString *)typeId withBlock:(void(^)(NSArray * extendPropertyList, NSError * error))block
{
    NSDictionary * params = @{kItemTypeId : typeId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetExtendPropByTypeId params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}
@end
