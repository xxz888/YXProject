//
//  YXPlusManager.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/17.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessdBlockType)();
typedef void(^FailBlockType)();
typedef void(^SuccessdBlockTypeParameter)(id object);
#define YX_BLOCK (id)dic success:(SuccessdBlockTypeParameter)successBlock

@interface YXPlusManager : NSObject
+ (instancetype)sharedInstance;
-(void)requestZhiNan1Get:YX_BLOCK;
-(void)requestCollect_optionGet:YX_BLOCK;
-(void)requestAll_optionGet:YX_BLOCK;

#pragma mark ==========增加收货地址==========
-(void)requestAddressAddPOST:YX_BLOCK;
#pragma mark ==========更改收货地址==========
-(void)requestAddressChangePOST:YX_BLOCK;
#pragma mark ==========删除收货地址==========
-(void)requestAddressDelPOST:YX_BLOCK;
#pragma mark ==========查询收货地址==========
-(void)requestAddressListGet:YX_BLOCK;
#pragma mark ==========获取首页分类及商品列表==========
-(void)requestIntegral_classify:YX_BLOCK;
#pragma mark ==========积分商城首页推荐==========
-(void)requestIntegral_Commodity_recommendGet:YX_BLOCK;
#pragma mark ==========id找商品==========
-(void)requestInIdOutIntegral_commodity:YX_BLOCK;
#pragma mark ==========新增订单==========
-(void)requestAddShopIntegral_orderPOST:YX_BLOCK;

#pragma mark ==========获取帮忙好友列表==========
-(void)requestOption_lock_history:YX_BLOCK;
#pragma mark ==========邀请好友记录==========
-(void)requestyaoqinghaoyojilu:YX_BLOCK;
#pragma mark ==========发送用户私信==========
-(void)requestChatting_ListoryPOST:YX_BLOCK;
#pragma mark ==========获取用户未读消息==========
-(void)requestChatting_ListoryGet:YX_BLOCK;
#pragma mark ==========邀请好友解锁==========
-(void)requestOption_lock_historyPOST:YX_BLOCK;
#pragma mark ==========添加tag==========
-(void)requestAddIu_tagPOST:YX_BLOCK;
#pragma mark ==========查看收藏==========
-(void)requestUserShouCangGet:YX_BLOCK;
#pragma mark ==========收藏==========
-(void)requestUserShouCangPOST:YX_BLOCK;
#pragma mark ==========请求tag是否收藏==========
-(void)requestUserIsShouCangGet:YX_BLOCK;
-(void)requestBlackGet:YX_BLOCK;
-(void)requestPubTagPOST:YX_BLOCK;
@end

