//
//  CCFile.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/26.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "CCFile.h"
#import "CCAppDotNetClient.h"
#import "NSString+MD5.h"
#import "NSDictionary+CCJson.h"
#import "NSError+CCError.h"
static NSString * uploadURL = @"http://wearcloud.beyondin.com/api/uploadImage/appid/1/submit/submit";

@implementation CCFile
+ (NSURLSessionUploadTask *) uploadImage:(UIImage *)image withProgress:(void(^)(double progress))progress completionBlock:(void(^)(NSString * url, NSError * error))block
{
    NSError *error = nil;
    
    CCAppDotNetClient *manager = [CCAppDotNetClient sharedInstance];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:uploadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"upfile" fileName:@"boris.png" mimeType:@"image/png"];
    } error:&error];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (progress) progress(uploadProgress.fractionCompleted);
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          block(nil, error);
                      } else {
                          if ([responseObject ccCode] == 0) {
                              NSString * url = [responseObject ccJsonString:@"file_path"];
                              if ([url isKindOfClass:[NSString class]]) {
                                  block(url, nil);
                              } else block(nil, [NSError errorDefault]);
                          } else {
                              block(nil, [NSError errorWithCode:[responseObject ccCode]]);
                          }
                      }
                  }];
    [uploadTask resume];
    return uploadTask;
    
}

+ (NSURL *)ccURLWithString:(NSString *)string
{
    NSString * wholeString = string;
    if (![string hasPrefix:@"http://"]) wholeString = [ImageDomain stringByAppendingString:string];
    return [NSURL URLWithString:wholeString];
}

+ (UIImage *)generateThumbnailOf:(UIImage *)original withSize:(CGFloat)size{
    CGSize newSize = CGSizeMake(size, size);
    CGRect thumbnailRect = CGRectMake(0, 0, size, size);
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    [original drawInRect:thumbnailRect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnail;
}
@end
