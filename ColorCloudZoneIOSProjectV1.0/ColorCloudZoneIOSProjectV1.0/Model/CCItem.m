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

@implementation CCItemType

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.typeId = [dict ccJsonString:kItemTypeId];
        self.name = [dict ccJsonString:kItemTypeName];
    }
    return self;
}

@end

@implementation CCItemClass
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.classId = [dict ccJsonString:kItemClassId];
        self.className = [dict ccJsonString:kItemClassName];
        self.classIconUrl = [dict ccJsonString:kItemClassIconUrl];
    }
    return self;
}
@end

@implementation CCItemSort
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.sortId = [dict ccJsonString:kItemSortId];
        self.sortName = [dict ccJsonString:kItemSortName];
    }
    return self;
}
@end

@implementation CCItemPropertyValue
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.valueId = [dict ccJsonString:kItemPropertyValueId];
        self.value = [dict ccJsonString:kItemPropertyValue];
    }
    return self;
}
@end

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

+ (NSURLSessionDataTask *)getClassListWithBlock:(void (^)(NSArray *, NSError *))block
{
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetClassList params:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSArray * dicts = [responseObject ccJsonArray:@"data"];
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dict in dicts) {
                CCItemClass * class = [[CCItemClass alloc]initWithDictionary:dict];
                [arr addObject:class];
            }
            block([NSArray arrayWithArray:arr], nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)getSortListByClassId:(NSString *)classId withBlock:(void (^)(NSArray *, NSError *))block
{
    NSDictionary * params = @{kItemClassId : classId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetSortList params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSArray * dicts = [responseObject ccJsonArray:@"data"];
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dict in dicts) {
                CCItemSort * sort = [[CCItemSort alloc]initWithDictionary:dict];
                [arr addObject:sort];
            }
            block([NSArray arrayWithArray:arr], nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)getTypeListWithBlock:(void(^)(NSArray * typeList, NSError * error))block
{
    
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetTypeList params:nil] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSArray * dicts = [responseObject ccJsonArray:@"data"];
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dict in dicts) {
                CCItemType * type = [[CCItemType alloc]initWithDictionary:dict];
                [arr addObject:type];
            }
            block([NSArray arrayWithArray:arr], nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];

}


+ (NSURLSessionDataTask *)getColorListByTypeId:(NSString *)typeId withBlock:(void(^)(NSArray * colorList, NSError * error))block
{
    NSDictionary * params = @{kItemTypeId : typeId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetItemSkuByTypeId params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSMutableArray * arr = [NSMutableArray array];
            NSArray * listDicts = [responseObject ccJsonArray:@"data"];
            for (NSDictionary * dict in listDicts)
                if ([dict ccJsonInteger:@"serial"] == 0) {
                    NSArray * colorDicts = [dict ccJsonArray:@"prop_value"];
                    for (NSDictionary * dict in colorDicts) {
                        CCItemPropertyValue * propVal = [[CCItemPropertyValue alloc] initWithDictionary:dict];
                        [arr addObject:propVal];
                    }
                } else continue;
            block(arr, nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)getSizeListByTypeId:(NSString *)typeId withBlock:(void(^)(NSArray * sizeList, NSError * error))block
{
    NSDictionary * params = @{kItemTypeId : typeId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetItemSkuByTypeId params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode]==0) {
            NSMutableArray * arr = [NSMutableArray array];
            NSArray * listDicts = [responseObject ccJsonArray:@"data"];
            for (NSDictionary * dict in listDicts)
                if ([dict ccJsonInteger:@"serial"] == 1) {
                    NSArray * colorDicts = [dict ccJsonArray:@"prop_value"];
                    for (NSDictionary * dict in colorDicts) {
                        CCItemPropertyValue * propVal = [[CCItemPropertyValue alloc] initWithDictionary:dict];
                        [arr addObject:propVal];
                    }
                } else continue;
            block(arr, nil);
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
            NSMutableArray * arr = [NSMutableArray array];
            NSArray * listDicts = [responseObject ccJsonArray:@"data"];
            NSDictionary * dict = [listDicts firstObject];
            NSArray * colorDicts = [dict ccJsonArray:@"prop_value"];
            for (NSDictionary * dict in colorDicts) {
                CCItemPropertyValue * propVal = [[CCItemPropertyValue alloc] initWithDictionary:dict];
                [arr addObject:propVal];
            }
            block(arr, nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (NSURLSessionDataTask *)uploadItem:(CCItem *)item withBlock:(void (^)(CCItem *, NSError *))block
{
    return nil;
}

@end
