//
//  NSError+CCError.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/26.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "NSError+CCError.h"

@implementation NSError (CCError)
+ (NSError *)errorWithCode:(NSInteger)code
{
    return [NSError errorWithDomain:@"com.colorCloud.cn" code:code userInfo:[NSDictionary dictionary]];
}

+ (NSError *)errorDefault
{
    return [NSError errorWithDomain:@"com.colorCloud.cn" code:-1 userInfo:[NSDictionary dictionary]];
}
@end
