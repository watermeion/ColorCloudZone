//
//  NSDictionary+CCJson.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/26.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "NSDictionary+CCJson.h"

@implementation NSDictionary (CCJson)
- (NSInteger) ccJsonInteger:(NSString *)key
{
    NSNumber * number = (NSNumber *)[self objectForKey:key];
    return number.integerValue;
}

- (NSInteger) ccCode
{
    
    NSNumber * number = (NSNumber *)[self objectForKey:@"code"];
    return number.integerValue;
}

+ (NSInteger) ccCodeWithDictionary:(NSDictionary *)dict
{
    
    NSNumber * number = (NSNumber *)[dict objectForKey:@"code"];
    return number.integerValue;
}



- (double) ccJsonDouble:(NSString *)key
{
    NSNumber * number = (NSNumber *)[self objectForKey:key];
    return number.doubleValue;
}


- (NSString *) ccJsonString:(NSString *)key
{
    return (NSString *)[self objectForKey:key];
}


- (NSArray *) ccJsonArray:(NSString *)key
{
    return (NSArray *)[self objectForKey:key];
}

- (NSDictionary *)ccJsonDictionary:(NSString *)key
{
    return (NSDictionary *)[self objectForKey:key];
}
@end
