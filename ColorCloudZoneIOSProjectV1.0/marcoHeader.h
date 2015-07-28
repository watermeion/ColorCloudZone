//
//  marcoHeader.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/17.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#ifndef ColorCloudZoneIOSProjectV1_0_marcoHeader_h
#define ColorCloudZoneIOSProjectV1_0_marcoHeader_h

#define BASEBARCOLOR [UIColor colorWithRed:236/255.0 green:191/255.0 blue:81/255.0 alpha:1.0f]




#define MainScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define MainScreenHeight ([UIScreen mainScreen].bounds.size.height)

//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#endif
