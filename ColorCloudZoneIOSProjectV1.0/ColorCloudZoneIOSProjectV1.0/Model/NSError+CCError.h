//
//  NSError+CCError.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/26.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (CCError)
+ (NSError *)errorWithCode:(NSInteger)code;
+ (NSError *)errorDefault;
@end
