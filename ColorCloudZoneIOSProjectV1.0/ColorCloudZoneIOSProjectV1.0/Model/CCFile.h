//
//  CCFile.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/26.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ImageDomain @"http://wearcloud.beyondin.com"

@interface CCFile : NSObject

+ (NSURLSessionUploadTask *) uploadImage:(UIImage *)image withProgress:(void(^)(double progress))progress completionBlock:(void(^)(NSString * url, NSError * error))block;
+ (UIImage *)generateThumbnailOf:(UIImage *)original withSize:(CGFloat)size;
+ (NSURL *)ccURLWithString:(NSString *)string;
@end
