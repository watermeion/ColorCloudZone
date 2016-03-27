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

@implementation CCFile
- (void) upload
{
    NSError *error = nil;
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                           URLString:requestObj.requestUrl
                                                                          parameters:requestObj.requestParams
                                                           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                               
                                                               //[formData appendPartWithFormData:data name:@"file"];
                                                               [formData appendPartWithFileData:data name:@"upfile" fileName:@"boris.png" mimeType:@"image/png"];
                                                           }
                                                                               error:&error];
    
    
    CCAppDotNetClient *manager = [CCAppDotNetClient sharedInstance];
    AFHTTPResponseSerializer *responseSerializer = manager.responseSerializer;
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:&progress
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
                                                                  
                                                                  if (error) {
                                                                      failure(error);
                                                                  } else {
                                                                      success(responseObject);
                                                                  }
                                                              }];
    [uploadTask resume];
    
}
@end
