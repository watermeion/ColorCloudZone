//
//  MemberCenterManager.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/20.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVUser.h"

typedef NS_ENUM(NSUInteger, MEMBERCENTERUSERTYPE) {
    MemberCenterUserTypeUnKnown = 0,
    MemberCenterUserTypeSeller = 1,
    MemberCenterUserTypeSupplier = 2,
};

@interface MemberCenterManager : NSObject

@property (nonatomic, strong) AVUser *currentUser;
- (MEMBERCENTERUSERTYPE)currentUserType;
+ (instancetype) singletonInstance;
+ (BOOL) islogin;

+ (void)startLoginAndRegistProcedure;

+ (void)logout;

- (void)setCurrentUserType:(MEMBERCENTERUSERTYPE) userType withCompletion:(void(^)(BOOL success, NSError *error))handler;


+ (void)presentLoginWorkflowWithVC:(UIViewController *) viewController;


@end
