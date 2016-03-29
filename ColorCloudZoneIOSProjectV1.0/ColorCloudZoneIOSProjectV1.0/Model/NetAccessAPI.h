//
//  NetAccessAPI.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/2/4.
//  Copyright © 2016年 SHS. All rights reserved.
//

#ifndef NetAccessAPI_h
#define NetAccessAPI_h

#define APIHOST              @"http://wearcloud.beyondin.com/?m=api&a=api"

#define Login @"wearcloud.user.login"
#define CheckMobileRegistered @"wearcloud.user.checkMobileRegistered"
#define SendVerifyCode @"wearcloud.user.sendVerifyCode"
#define CheckVerifyCodeValid @"wearcloud.user.checkVerifyCodeValid"
#define Signup @"wearcloud.user.signup"
#define Logout @"wearcloud.user.logout"


#define ItemGetTypeList @"wearcloud.item.getTypeList"
#define ItemGetItemSkuByTypeId @"wearcloud.item.getItemSkuByTypeId"
#define ItemGetExtendPropByTypeId @"wearcloud.item.getExtendPropByTypeId"
#endif /* NetAccessAPI_h */
