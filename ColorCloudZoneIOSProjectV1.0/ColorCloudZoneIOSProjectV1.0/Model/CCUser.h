//
//  CCUser.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/2/2.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCUser : NSObject
@property (nonatomic, strong) NSString * userId;

+ (NSURLSessionDataTask *)loginWithMobile:(NSString *)mobile password:(NSString *)password withBlock:(void(^)(CCUser * user, NSError * error))block;
@end
