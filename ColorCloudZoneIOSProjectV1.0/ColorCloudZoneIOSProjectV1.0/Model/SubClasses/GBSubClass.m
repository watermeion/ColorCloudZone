//
//  GBSubClass.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/25.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "GBSubClass.h"
//#import <objc/objc-runtime.h>
#import <objc/runtime.h>
@implementation GBSubClass

@dynamic objectId;
@dynamic createdAt;
@dynamic updateAt;




//自注册
+ (void)registerSubclasses{
  //注册所以的Subclasses
    NSArray *subClasses = [GBSubClass findAllSubClassesOf:[GBSubClass class]];
    for (Class childClass  in subClasses) {
        [childClass registerSubclass];
    }
}

+ (NSArray*)findAllSubClassesOf:(Class)defaultClass{

    if (defaultClass == nil) {
        NSAssert(defaultClass, @"defaultClass should not be nil");
        return nil;
    }
    int count = objc_getClassList(NULL, 0);
    if (count <= 0) {
        @throw @"Can not retrieve Obj-C Class List";
        return @[defaultClass];
    }
    NSMutableArray *output = [NSMutableArray new];
    
    Class *classes = (Class *)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    for (int i = 0; i<count; ++i) {
        if (defaultClass == class_getSuperclass(classes[i])) {
            
            [output addObject:classes[i]];
        }
    }

    free(classes);
    return [output copy];

}

@end
