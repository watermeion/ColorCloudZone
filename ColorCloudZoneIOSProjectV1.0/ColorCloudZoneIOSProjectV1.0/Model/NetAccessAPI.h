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
#define EditUserInfo @"wearcloud.user.editUserInfo"
#define Logout @"wearcloud.user.logout"

#define GetWholeSaleMarketList @"wearcloud.wholesaleMarket.getWholesaleMarketList"
#define GetProvinceList @"wearcloud.address.getProvinceList"
#define GetCityList @"wearcloud.address.getCityList"
#define GetAreaList @"wearcloud.address.getAreaList"

#define ItemGetClassList @"wearcloud.category.getClassList"
#define ItemGetSortList @"wearcloud.category.getSortListByClassId"
#define ItemGetTypeList @"wearcloud.item.getItemTypeList"
#define ItemGetItemSkuByTypeId @"wearcloud.item.getSkuInfoByTypeId"
#define ItemGetExtendPropByTypeId @"wearcloud.item.getExtendPropByTypeId"
#endif /* NetAccessAPI_h */
