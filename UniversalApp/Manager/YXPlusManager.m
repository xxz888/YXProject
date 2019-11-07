//
//  YXPlusManager.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/17.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXPlusManager.h"
#import "HttpRequest.h"

#define RREQUEST_POST(paramters)     [HTTP_POST(paramters) Parameters:dic sucess:^(id responseObject) {\
successBlock(responseObject);\
} failure:^(NSError *error) {\
}];


#define RREQUEST_GET(paramters)     [HTTP_GET(paramters)  sucess:^(id responseObject) {\
successBlock(responseObject);\
} failure:^(NSError *error) {\
}];

#define HTTP_POST(pi) HttpRequest httpRequestPostPi:pi
#define HTTP_GET(pi)  HttpRequest httpRequestGetPi:pi
@implementation YXPlusManager
/*单例*/
+ (instancetype)sharedInstance{
    static YXPlusManager *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[YXPlusManager alloc]init];
    });
    return s_instance;
}
#pragma mark ==========GET请求模版==========
-(void)requestGET:YX_BLOCK{
    NSString * url = @"";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========POST请求模版==========
-(void)requestPOST:YX_BLOCK{
    [HTTP_POST(@"") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}


-(void)requestZhiNan1Get:YX_BLOCK{
    NSString * url = @"/pub/option/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}


-(void)requestCollect_optionGet:YX_BLOCK{
    NSString * url = @"/pub/collect_option/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
-(void)requestAll_optionGet:YX_BLOCK{
    NSString * url = @"/pub/all_option/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========增加收货地址==========
-(void)requestAddressAddPOST:YX_BLOCK{
    [HTTP_POST(@"/users/address") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

#pragma mark ==========更改收货地址==========
-(void)requestAddressChangePOST:YX_BLOCK{
    [HTTP_POST(@"/users/address") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========删除收货地址==========
-(void)requestAddressDelPOST:YX_BLOCK{
    [HTTP_POST(@"/users/address") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========查询收货地址==========
-(void)requestAddressListGet:YX_BLOCK{
    [HTTP_GET(@"/users/address")  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========积分商城首页推荐==========
-(void)requestIntegral_Commodity_recommendGet:YX_BLOCK{
    [HTTP_GET(@"/shop/integral_commodity_recommend")  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========获取首页分类及商品列表==========
-(void)requestIntegral_classify:YX_BLOCK{
    [HTTP_GET(@"/shop/integral_classify")  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========id找商品==========
-(void)requestInIdOutIntegral_commodity:YX_BLOCK{
    [HTTP_GET([@"/shop/integral_commodity/?commodity_id=" append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}


#pragma mark ==========新增订单==========
-(void)requestAddShopIntegral_orderPOST:YX_BLOCK{
    [HTTP_POST(@"/shop/integral_oder/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}


#pragma mark ==========获取帮忙好友列表==========
-(void)requestOption_lock_history:YX_BLOCK{
    [HTTP_GET(@"/pub/option_lock_history/")  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========邀请好友记录==========
-(void)requestyaoqinghaoyojilu:YX_BLOCK{
    [HTTP_GET(@"/users/invite/")  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========发送用户私信==========
-(void)requestChatting_ListoryPOST:YX_BLOCK{
    [HTTP_POST(@"/pub/chatting_history/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========获取用户未读消息==========
-(void)requestChatting_ListoryGet:YX_BLOCK{
    [HTTP_GET(@"/pub/chatting_history/")  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========邀请好友解锁==========
-(void)requestOption_lock_historyPOST:YX_BLOCK{
    [HTTP_POST(@"/pub/option_lock_history/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========添加tag==========
-(void)requestAddIu_tagPOST:YX_BLOCK{
    [HTTP_POST(@"/users/iu_tag/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

@end
