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
#define ModifyPassword @"wearcloud.user.setPassword"
#define FindPassword @"wearcloud.user.findPassword"
#define EditUserInfo @"wearcloud.user.editUserInfo"
#define Logout @"wearcloud.user.logout"
#define FollowFactory   @"wearcloud.mall.followFactory"
#define GetFollowedFactoryList @"wearcloud.mall.getFollowFactoryList"
#define EditUserInfo @"wearcloud.user.editUserInfo"
#define GetBanner @"wearcloud.mall.getBanner"
#define GetUserInfo @"wearcloud.user.getUserInfo"


#define GetWholeSaleMarketList @"wearcloud.wholesaleMarket.getWholesaleMarketList"
#define GetProvinceList @"wearcloud.address.getProvinceList"
#define GetCityList @"wearcloud.address.getCityList"
#define GetAreaList @"wearcloud.address.getAreaList"


#define ItemGetHottestItemsForFactory @"wearcloud.Factory.getHotItemList"
#define ItemGetHottestItemsForMall @"wearcloud.MallCollect.getHotItemList"
#define ItemGetNewestItemsForFactory @"wearcloud.Factory.getNewItemList"
#define ItemGetNewestItemsForMall @"wearcloud.MallCollect.getNewItemList"
#define ItemGetItemList @"wearcloud.item.getItemList"

#define ItemGetClassList @"wearcloud.category.getClassList"
#define ItemGetSortList @"wearcloud.category.getSortListByClassId"
#define ItemGetTypeList @"wearcloud.item.getItemTypeList"
#define ItemGetItemSkuByTypeId @"wearcloud.item.getSkuInfoByTypeId"
#define ItemGetExtendPropByTypeId @"wearcloud.item.getExtendPropByTypeId"
#define ItemUpload @"wearcloud.item.addItem"
#define ItemUnsell @"wearcloud.item.moveStroage"
#define ItemEditInfo @"wearcloud.item.editItem"
#define ItemGetItemDetailInfo @"wearcloud.item.getItemDetailInfo"
#define ItemGetItemFactoryInfo @"wearcloud.item.getItemFactoryInfo"
#define ItemGetItemMemberInfo @"wearcloud.item.getItemMemberInfo"
#define ItemCollectItem @"wearcloud.MallCollect.collectItem"
#define ItemWantItem @"wearcloud.MemberCollect.collectItem"
#define ItemGetFactoryInfo @"wearcloud.item.getItemFactoryInfo"
#define ItemGetLikeList @"wearcloud.item.getItemMemberInfo"
#define ItemMallItemStatistics @"wearcloud.statistics.getMallItemStatistics"
#define ItemFactoryItemStatistics @"wearcloud.statistics.getStatisticsByItemId"

#define MemberAdd @"wearcloud.member.addMember"
#define MemberIsCollectItem @"wearcloud.MemberCollect.isCollectItem"
#define MemberGetMemberList @"wearcloud.member.getMemberList"
#define MemberGetMemberInfo @"wearcloud.member.getMemberInfo"
#define MemberGetLikeList @"wearcloud.MemberCollect.getItemListByDate"
#define MemberCheckRegister @"wearcloud.member.checkMemberRegister"

#endif /* NetAccessAPI_h */
