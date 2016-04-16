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
#import "CCUser.h"

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
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.assistantPics = [NSMutableArray array];
        self.descPics = [NSMutableArray array];
        self.colorProperty = [NSMutableArray array];
        self.sizeProperty = [NSMutableArray array];
        self.hasSku = YES;
    }
    return self;
    
}
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        
//        @property (nonatomic, strong) CCItemClass * itemClass;
//        @property (nonatomic, strong) CCItemSort * itemSort;
//        @property (nonatomic, strong) CCItemType * itemType;
//        @property (nonatomic, strong) NSMutableArray * colorProperty;
//        @property (nonatomic, strong) NSMutableArray * sizeProperty;
//        @property (nonatomic, strong) NSMutableArray * extendProperty;
//        @property (nonatomic, assign) BOOL hasSku;
        
        self.itemId = [dict ccJsonString:kItemId];
        self.name = [dict ccJsonString:kItemName];
        self.factoryId = [dict ccJsonString:kItemFactoryId];
        self.SN = [dict ccJsonString:kItemSN];
        self.price = [dict ccJsonFloat:kItemPrice];
        self.cover = [dict ccJsonString:kItemCover];
        NSString * assPicsStr = [dict ccJsonString:kItemAssistantPics];
        self.assistantPics = [NSMutableArray arrayWithArray:[assPicsStr componentsSeparatedByString:@";"]];
        NSString * descPicsStr = [dict ccJsonString:kItemAssistantPics];
        self.descPics = [NSMutableArray arrayWithArray:[descPicsStr componentsSeparatedByString:@";"]];
        self.desc = [dict ccJsonString:kItemDesc];
        self.likeNum = [dict ccJsonInteger:kItemLikeNum];
        self.collectNum = [dict ccJsonInteger:kItemCollectNum];
        self.newCount = [dict ccJsonInteger:kItemNewCount];
        NSString * dateStr = [dict ccJsonString:kItemDate];
        if (dateStr.length > 0) {
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM";
            self.date = [formatter dateFromString:dateStr];
        }
    }
    return self;
}

- (void)getDetailFromDictionary:(NSDictionary *)dictionary
{
    self.isCollected = [dictionary ccJsonInteger:kItemIsCollected];
    self.desc = [dictionary ccJsonString:kItemDesc];
    
    NSArray * extendPropDicts = [dictionary ccJsonArray:@"item_extend_property"];
    if ([extendPropDicts isKindOfClass:[NSArray class]] && extendPropDicts.count > 0) {
        NSDictionary * dict = [extendPropDicts firstObject];
        self.extendProperty = [[CCItemPropertyValue alloc] initWithDictionary:dict];
    }
    
    NSDictionary * skuInfoDict =  [dictionary ccJsonDictionary:@"sku_info"];
    NSDictionary * colorDict = [skuInfoDict ccJsonDictionary:@"property1"];
    NSArray * colorValueDict = [colorDict ccJsonArray:@"value_list"];
    self.colorProperty = [NSMutableArray array];
    for (NSDictionary * dict in colorValueDict) {
        CCItemPropertyValue * value = [[CCItemPropertyValue alloc] initWithDictionary:dict];
        [self.colorProperty addObject:value];
    }
    NSDictionary * sizeDict = [skuInfoDict ccJsonDictionary:@"property2"];
    NSArray * sizeValueDict = [sizeDict ccJsonArray:@"value_list"];
    self.sizeProperty = [NSMutableArray array];
    for (NSDictionary * dict in sizeValueDict) {
        CCItemPropertyValue * value = [[CCItemPropertyValue alloc] initWithDictionary:dict];
        [self.sizeProperty addObject:value];
    }
    
//    data =     {
//        "item_info" =         {
//            "class_id" = 10;
//            "factory_id" = 13098;
//            "item_type_id" = 68;
//            "sort_id" = 15;
//        };
//    };
}

- (NSDictionary *)genarateDictionary
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (self.itemId) [dict setObject:self.itemId forKey:kItemId];
    if ([CCUser currentUser].userId) [dict setObject:[CCUser currentUser].userId forKey:kItemFactoryId];
    if (self.name) [dict setObject:self.name forKey:kItemName];
    if (self.factoryId) [dict setObject:self.factoryId forKey:kItemFactoryId];
    if (self.SN) [dict setObject:self.SN forKey:kItemSN];
    if (self.itemClass.classId) [dict setObject:self.itemClass.classId forKey:kItemClassId];
    if (self.itemSort.sortId) [dict setObject:self.itemSort.sortId forKey:kItemSortId];
    if (self.itemType.typeId) [dict setObject:self.itemType.typeId forKey:kItemTypeId];
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
    
    NSString * colors = @"";
    for (CCItemPropertyValue * prop in self.colorProperty) {
        if (colors.length > 0) colors = [colors stringByAppendingString:@","];
        colors = [colors stringByAppendingString:prop.valueId];
    }
    [dict setObject:colors forKey:kItemColorProperty];
    
    NSString * sizes = @"";
    for (CCItemPropertyValue * prop in self.sizeProperty) {
        if (sizes.length > 0) sizes = [sizes stringByAppendingString:@","];
        sizes = [sizes stringByAppendingString:prop.valueId];
    }
    [dict setObject:sizes forKey:kItemSizeProperty];
    
    if (self.extendProperty.valueId) [dict setObject:self.extendProperty.valueId forKey:kItemExtendProperty];
    
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
            if (![dicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
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
            if (![dicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
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
            if (![dicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
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
            if (![listDicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
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
            if (![listDicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
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
            if (![listDicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
            NSDictionary * dict = [listDicts firstObject];
            NSArray * propDicts = [dict ccJsonArray:@"prop_value"];
            if (![propDicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
            for (NSDictionary * dict in propDicts) {
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
    NSDictionary * params = [item genarateDictionary];
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemUpload params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            NSDictionary * data = [responseObject ccJsonDictionary:@"data"];
            item.itemId = [data ccJsonString:kItemId];
            block(item, nil);
        } else {
            block(item, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(item, error);
    }];
}

+ (NSURLSessionDataTask *)getItemListByHottest:(BOOL)hottest forFactory:(NSString *)factoryId withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *, NSError *))block
{
    NSDictionary * params = @{kItemFactoryId : factoryId,
                              kItemLimit : @(limit),
                              kItemSkip : @(skip)};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:hottest?ItemGetHottestItemsForFactory : ItemGetNewestItemsForFactory params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (NSURLSessionDataTask *)getItemListByHottest:(BOOL)hottest forMall:(NSString *)mallId withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *, NSError *))block
{
    NSDictionary * params = @{kItemMallId : mallId,
                              kItemLimit : @(limit),
                              kItemSkip : @(skip)};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:hottest?ItemGetHottestItemsForMall : ItemGetNewestItemsForMall params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (NSURLSessionDataTask *)getItemListByHottest:(BOOL)hottest saleMarketId:(NSString *)marketId classId:(NSString *)classId sortId:(NSString *)sortId withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void (^)(NSArray *, NSError *))block
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@(hottest) forKey:kItemHottest];
    if (marketId) [params setObject:marketId forKey:kUserSaleMarketId];
    if (classId) [params setObject:classId forKey:kItemClassId];
    if (sortId) [params setObject:sortId forKey:kItemSortId];
    [params setObject:@(limit) forKey:kItemLimit];
    [params setObject:@(skip) forKey:kItemSkip];
    
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetItemList params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
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


+ (NSURLSessionDataTask *)getItemDetailInfo:(CCItem *)item withBlock:(void (^)(CCItem *, NSError *))block
{
    NSDictionary * params = @{kItemId : item.itemId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetItemDetailInfo params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            NSDictionary * data = [responseObject ccJsonDictionary:@"data"];
            [item getDetailFromDictionary:data];
            block(item, nil);
        } else {
            block(item, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(item, error);
    }];
}

+ (NSURLSessionDataTask *)collect:(BOOL)collect item:(CCItem *)item price:(float)price withBlock:(void (^)(BOOL, NSError *))block
{
    NSDictionary * params = @{@"isCollect" : @(collect),
                              kItemId : item.itemId,
                              @"item_price": @(price),
                              kItemFactoryId : item.factoryId};
    
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemCollectItem params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (NSURLSessionDataTask *)want:(BOOL)want item:(CCItem *)item color:(NSString *)colorId size:(NSString *)sizeId byMemberMobile:(NSString *)mobile withBlock:(void (^)(BOOL, NSError *))block
{
    NSDictionary * params = @{@"isCollect" : @(want),
                              kItemId : item.itemId,
                              kMemberMobile : mobile,
                              @"property_value1" : colorId,
                              @"property_value2" : sizeId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemCollectItem params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (NSURLSessionDataTask *)getItemFactory:(CCItem *)item withBlock:(void (^)(CCUser *, NSError *))block
{
    
    NSDictionary * params = @{kItemId : item.itemId};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetFactoryInfo params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            NSDictionary * data = [responseObject ccJsonDictionary:@"data"];
            CCUser * factory = [[CCUser alloc] initWithDictionary:data];
            block(factory, nil);
        } else {
            block(nil, [NSError errorWithCode:[responseObject ccCode]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];

}

+ (NSURLSessionDataTask *)getItemLikeList:(CCItem *)item limit:(NSInteger)limit skip:(NSInteger)skip withBlock:(void (^)(NSArray *, NSError *))block
{
    NSDictionary * params = @{kItemId : item.itemId,
                              kItemLimit : @(limit),
                              kItemSkip : @(skip)};
    return [[CCAppDotNetClient sharedInstance] POST:@"" parameters:[CCAppDotNetClient generateParamsWithAPI:ItemGetLikeList params:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject ccCode] == 0) {
            NSMutableArray * arr = [NSMutableArray array];
            NSArray * listDicts = [responseObject ccJsonArray:@"data"];
            if (![listDicts isKindOfClass:[NSArray class]]) {
                block([NSArray array], nil);
                return ;
            }
            for (NSDictionary * dict in listDicts) {
                CCMember * member = [[CCMember alloc ] initWithDictionary:dict];
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
@end
