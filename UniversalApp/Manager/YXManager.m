//
//  YXManager.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXManager.h"
#import "HttpRequest.h"

#define RREQUEST_POST(paramters)     [HTTP_POST(paramters) Parameters:dic sucess:^(id responseObject) {\
successBlock(responseObject);\
} failure:^(NSError *error) {\
}];


#define RREQUEST_GET(paramters)     [HTTP_GET(paramters)  sucess:^(id responseObject) {\
successBlock(responseObject);\
} failure:^(NSError *error) {\
}];

@interface YXManager ()

@end
#define HTTP_POST(pi) HttpRequest httpRequestPostPi:pi
#define HTTP_GET(pi)  HttpRequest httpRequestGetPi:pi

@implementation YXManager

/*单例*/
+ (instancetype)sharedInstance{
    static YXManager *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[YXManager alloc]init];
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

#pragma mark ==========登录==========
-(void)requestLoginPOST:YX_BLOCK{
    [HTTP_POST(@"/users/register/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

#pragma mark ==========登录验证码==========
-(void)requestSmscodeGET:YX_BLOCK{
    NSString * url = @"/pub/smscode/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}



#pragma mark ==========我的关注==========
-(void)requestLikesGET:YX_BLOCK{
    NSString * url = @"/users/likes/";
    [HTTP_GET([[url append:dic] append:@"/0/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}

#pragma mark ==========取消关注==========
-(void)requestLikesActionGET:YX_BLOCK{
    NSString * url = @"/users/likes/3/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 请求广告 ==========
-(void)requestGETAdvertising:YX_BLOCK{
    kWeakSelf(self);
    NSString * url = @"/pub/advertising/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        [weakself.advertisingArray removeAllObjects];
        [weakself.advertisingArray addObject:responseObject];
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 请求新闻 ==========
-(void)requestGETInformation:YX_BLOCK{
    NSString * url = @"/pub/information/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ==========请求七牛tocken==========
-(void)requestQiniu_tokenGET:YX_BLOCK{
    NSString * url = @"/pub/qiniu_token/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject){
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 请求品牌 ==========
-(void)requestCigar_brand:YX_BLOCK{
    NSString * url = @"/cigar/cigar_brand/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 品牌详情 ==========
-(void)requestCigar_brand_detailsPOST:YX_BLOCK{
    [HTTP_POST(@"/cigar/cigar_brand_details/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 品牌详情点赞收藏 ==========
-(void)requestCollect_cigarPOST:YX_BLOCK{
    [HTTP_POST(@"/cigar/collect_cigar/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

#pragma mark ========== 品牌是否关注 ==========
-(void)requestMy_concern_cigarPOST:YX_BLOCK{
    [HTTP_POST(@"/cigar/my_concern_cigar/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 发布晒图 ==========
-(void)requestFaBuImagePOST:YX_BLOCK{
    [HTTP_POST(@"/users/post/0/0/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========晒图列表==========
-(void)requestImageListGET:YX_BLOCK{
    NSString * url = @"/users/post/2/0/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}


#pragma mark ==========发布文章==========
-(void)requestEssayPOST:YX_BLOCK{
    [HTTP_POST(@"/users/essay/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========文章列表==========
-(void)requestEssayListGET:YX_BLOCK{
    NSString * url = @"/users/essay/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========详情列表==========
-(void)requestGetDetailListGET:YX_BLOCK{
    NSString * url = @"/users/post/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========点评请求==========
-(void)requestCigar_commentGET:YX_BLOCK{
    NSString * url = @"/cigar/cigar_comment/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

- (instancetype)init{
    self.advertisingArray = [[NSMutableArray alloc]init];
    self.informationArray = [[NSMutableArray alloc]init];
    
    return  self;
}
@end
