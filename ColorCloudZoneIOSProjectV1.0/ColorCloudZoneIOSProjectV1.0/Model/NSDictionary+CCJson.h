//
//  NSDictionary+CCJson.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/26.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CCJson)

- (NSInteger) ccJsonInteger:(NSString *)key;
- (NSInteger) ccCode;

+ (NSInteger) ccCodeWithDictionary:(NSDictionary *)dict;

- (double) ccJsonDouble:(NSString *)key;
- (float) ccJsonFloat:(NSString *)key;

- (NSString *) ccJsonString:(NSString *)key;

- (NSArray *) ccJsonArray:(NSString *)key;

- (NSDictionary *)ccJsonDictionary:(NSString *)key;
@end
