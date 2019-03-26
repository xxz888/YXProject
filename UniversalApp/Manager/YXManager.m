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
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}

#pragma mark ==========取消关注==========
-(void)requestLikesActionGET:YX_BLOCK{
    NSString * url = @"/users/likes/3/";
    [HTTP_GET([[url append:dic] append:@"/1/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 请求广告 ==========
-(void)requestGETAdvertising:YX_BLOCK{
    kWeakSelf(self);
    NSString * url = @"/pub/advertising/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
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
#pragma mark ========== 我收藏的雪茄列表 ==========
-(void)requestMyXueJia_CollectionListGet:YX_BLOCK{
    [HTTP_GET(@"/cigar/collect_cigar/") sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ========== 品牌是否关注 ==========
-(void)requestMy_concern_cigarPOST:YX_BLOCK{
    [HTTP_POST(@"/cigar/my_concern_cigar/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========我关注的雪茄品牌==========
-(void)requestGETMyGuanZhuList:YX_BLOCK{
    NSString * url = @"/cigar/my_concern_cigar/";
    [HTTP_GET(url)  sucess:^(id responseObject) {
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
-(void)requestGetDetailListPOST:YX_BLOCK{
    NSString * url = @"/users/post/1/1/1/";
    [HTTP_POST(url) Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========点评请求==========
-(void)requestCigar_commentGET:YX_BLOCK{
    NSString * url = @"/cigar/cigar_comment/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}


#pragma mark ==========雪茄五星的评价==========
-(void)requestCigar_commentPOST:YX_BLOCK{
    [HTTP_POST(@"/cigar/cigar_comment/0/0/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========雪茄文化配件列表==========
-(void)requestCigar_accessories_cultureGET:YX_BLOCK{
    NSString * url = @"/cigar/cigar_accessories_culture/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========雪茄配件列表==========
-(void)requestCigar_accessoriesGET:YX_BLOCK{
    NSString * url = @"/cigar/cigar_accessories/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========雪茄文化列表==========
-(void)requestCigar_cultureGET:YX_BLOCK{
    NSString * url = @"/cigar/cigar_culture/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========雪茄配件列表==========
-(void)requestCigar_accessories_CbrandGET:YX_BLOCK{
    NSString * url = @"/cigar/cigar_accessories_brand/";
    [HTTP_GET(url)  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========雪茄提问列表==========
-(void)requestQuestionGET:YX_BLOCK{
    NSString * url = @"/users/question/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========获取子评论列表==========
-(void)requestCigar_comment_childGET:YX_BLOCK{
    NSString * url = @"/cigar/cigar_comment_child/1/";
    [HTTP_GET([[url append:dic] append:@"/0/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========雪茄发布提问==========
-(void)requestFaBuQuestionPOST:YX_BLOCK{
    [HTTP_POST(@"/users/question/0/kw/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========点赞/取消点赞雪茄评论==========
-(void)requestPraise_cigaPr_commentPOST:YX_BLOCK{
    [HTTP_POST(@"/cigar/praise_cigar_comment/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========发布雪茄评论信息子评论==========
-(void)requestCigar_comment_childPOST:YX_BLOCK{
    [HTTP_POST(@"/cigar/cigar_comment_child/0/0/0/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}


#pragma mark ==========获取回答列表==========
-(void)requestAnswerListGET:YX_BLOCK{
    NSString * url = @"/users/answer/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========发布回答==========
-(void)requestFaBuHuiDaPOST:YX_BLOCK{
    [HTTP_POST(@"/users/answer/0/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

#pragma mark ==========获取子回答列表==========
-(void)requestAnswer_childListGET:YX_BLOCK{
    NSString * url = @"/users/answer_child/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========发布子回答==========
-(void)requestFaBuHuiDa_childPOST:YX_BLOCK{
    [HTTP_POST(@"/users/answer_child/0/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}


#pragma mark ========== 高尔夫品牌 ==========
-(void)requestGolf_brand:YX_BLOCK{
    NSString * url = @"/golf/golf_brand/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 关注/取消关注高尔夫品牌 ==========
-(void)requestGolf_brand_like:YX_BLOCK{
    NSString * url = @"/golf/golf_brand_like/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========获取高尔夫产品列表==========
-(void)requestGolf_productPOST:YX_BLOCK{
    [HTTP_POST(@"/golf/golf_product/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ========== 收藏/取消收藏高尔产品 ==========
-(void)requestGolf_product_collect:YX_BLOCK{
    NSString * url = @"/golf/golf_product_collect/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========获取高尔夫球场列表==========
-(void)requestGolf_coursePOST:YX_BLOCK{
    [HTTP_POST(@"/golf/golf_course/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}




#pragma mark ========== 获取晒图评论列表 ==========
-(void)requestPost_comment:YX_BLOCK{
    NSString * url = @"/users/post_comment/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========点赞/取消点赞晒图==========
-(void)requestPost_praisePOST:YX_BLOCK{
    [HTTP_POST(@"/users/post_praise/1/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========评论晒图==========
-(void)requestPost_commentPOST:YX_BLOCK{
    [HTTP_POST(@"/users/post_comment/0/0/0/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========点赞/取消点赞晒图评论==========
-(void)requestPost_comment_praisePOST:YX_BLOCK{
    [HTTP_POST(@"/users/post_comment_praise/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ========== 获取晒图评论子评论列表 ==========
-(void)requestPost_comment_child:YX_BLOCK{
    NSString * url = @"/users/post_comment_child/0/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========发布晒图评论子评论==========
-(void)requestpost_comment_childPOST:YX_BLOCK{
    [HTTP_POST(@"/users/post_comment_child/0/0/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

#pragma mark ==========点赞/取消点赞文章==========
-(void)requestPost_essay_praisePOST:YX_BLOCK{
    [HTTP_POST(@"/users/essay_praise/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}


#pragma mark ==========评论文章==========
-(void)requestPost_essay_commentPOST:YX_BLOCK{
    [HTTP_POST(@"/users/essay_comment/0/0/0/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ========== 获取文章评论列表 ==========
-(void)requestessay_comment:YX_BLOCK{
    NSString * url = @"/users/essay_comment/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========点赞/取消点赞文章评论==========
-(void)requestessay_comment_praisePOST:YX_BLOCK{
    [HTTP_POST(@"/users/essay_comment_praise/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ========== 获取晒图评论子评论列表 ==========
-(void)requestessay_comment_child:YX_BLOCK{
    NSString * url = @"/users/essay_comment_child/0/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========发布文章评论子评论==========
-(void)requestessay_comment_childPOST:YX_BLOCK{
    [HTTP_POST(@"/users/essay_comment_child/0/0/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}


#pragma mark ========== 根据用户id获取个人资料,彼此的关注状态 ==========
-(void)requestGetUserothers:YX_BLOCK{
    NSString * url = @"/users/others/1/";
    [HTTP_GET([[url append:dic] append:@"/0/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 获取发现页标签数据 ==========
-(void)requestGet_users_find:YX_BLOCK{
    NSString * url = @"/users/find/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 获取发现页标签数据全部接口 ==========
-(void)requestGet_users_find_tag:YX_BLOCK{
    NSString * url = @"/users/find_tag/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 根据用户id获取该用户的晒图 ==========
-(void)requestOtherImage:YX_BLOCK{
    NSString * url = @"/users/others/2/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 根据用户id获取该用户的文章 ==========
-(void)requestOtherEssay:YX_BLOCK{
    NSString * url = @"/users/others/3/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 根据用户id获取该用户的关注列表 ==========
-(void)requestOtherGuanZhu:YX_BLOCK{
    NSString * url = @"/users/others/4/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 根据用户id获取该用户的粉丝列表 ==========
-(void)requestOtherFenSi:YX_BLOCK{
    NSString * url = @"/users/others/4/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 我的点赞列表 ==========
-(void)requestMyDianZanList:YX_BLOCK{
    NSString * url = @"/users/post_praise/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========更新用户资料==========
-(void)requestUpdate_userPOST:YX_BLOCK{
    [HTTP_POST(@"/users/update_user/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

#pragma mark ========== 根据用户名搜索用户 ==========
-(void)requestFind_user:YX_BLOCK{
    NSString * url = @"/users/find_user/";
    [HTTP_POST(url)  Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========根据用户id获取个人资料,彼此的关注状态 ==========
-(void)requestGetFind_user_id:YX_BLOCK{
    NSString * url = @"/users/others/1/";
    [HTTP_GET([[url append:dic] append:@"/0/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========获取TAG标签列表 ==========
-(void)requestGetTagList:YX_BLOCK{
    NSString * url = @"/users/tag/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========获取TAG标签列表 ==========
-(void)requestGetTagList_Tag:YX_BLOCK{
    NSString * url = @"/users/tag/1/1/";
    [HTTP_POST(url)  Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 我的点评雪茄列表 ==========
-(void)requestGetMyDianPingList:YX_BLOCK{
    NSString * url = @"/cigar/cigar_comment/5/1/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}


#pragma mark ========== 我的页面全部接口 ==========
-(void)requestGetSersAllList:YX_BLOCK{
    NSString * url = @"/users/all/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 其他的全部 ==========
-(void)requestGetSers_Other_AllList:YX_BLOCK{
    NSString * url = @"/users/others/6/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========发布足迹 ==========
-(void)requestPost_track:YX_BLOCK{
    NSString * url = @"/users/track/1/1/1/";
    [HTTP_POST(url)  Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 获取我的足迹列表 ==========
-(void)requestGetMy_Track_list:YX_BLOCK{
    NSString * url = @"/users/track/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}



#pragma mark ========== 获取其他人足迹列表 ==========
-(void)requestGetOther_Track_list:YX_BLOCK{
    NSString * url = @"/users/others/7/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========点赞/取消点赞足迹 ==========
-(void)requestDianZanFoot:YX_BLOCK{
    NSString * url = @"/users/track_praise/";
    [HTTP_POST(url)  Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========评论足迹 ==========
-(void)requestPingLunFoot:YX_BLOCK{
    NSString * url = @"/users/track_comment/1/1/1/1/";
    [HTTP_POST(url)  Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========获取最新足迹评论列表 ==========
-(void)requestGetNewFootList:YX_BLOCK{
    NSString * url = @"/users/track_comment/1/1/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========获取最热足迹评论列表 ==========
-(void)requestGetHotFootList:YX_BLOCK{
    NSString * url = @"/users/track_comment/2/1/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========点赞/取消点赞足迹评论 ==========
-(void)requestDianZanFoot_PingLun:YX_BLOCK{
    NSString * url = @"/users/track_comment_praise/";
    [HTTP_POST(url)  Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========获取足迹评论子评论列表 ==========
-(void)requestGetFootPingLun_Child_List:YX_BLOCK{
    NSString * url = @"/users/track_comment_child/0/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========发布足迹评论子评论 ==========
-(void)requestFaBuFoot_child_PingLun:YX_BLOCK{
    NSString * url = @"/users/track_comment_child/0/0/0/";
    [HTTP_POST(url)  Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========搜索 ==========
-(void)requestSearchFind_all:YX_BLOCK{
    NSString * url = @"/users/find_all/";
    [HTTP_POST(url)  Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 热门关键字 ==========
-(void)requestGetFind_all:YX_BLOCK{
    NSString * url = @"/users/find_all/";
    [HTTP_GET(url) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}


#pragma mark ==========搜索雪茄品牌 ==========
-(void)requestSearchCigar_brand:YX_BLOCK{
    NSString * url = @"/cigar/cigar_brand/1/";
    [HTTP_POST(url)  Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 删除晒图 ==========
-(void)requestDel_ShaiTU:YX_BLOCK{
    NSString * url = @"/users/delete_post/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 删除问答 ==========
-(void)requestDel_WenDa:YX_BLOCK{
    NSString * url = @"/users/delete_question/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 删除足迹 ==========
-(void)requestDel_ZuJi:YX_BLOCK{
    NSString * url = @"/users/delete_track/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 点赞取消提问 ==========
-(void)requestPraise_question:YX_BLOCK{
    NSString * url = @"/users/praise_question/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 点赞取消回答 ==========
-(void)requestPraise_answer:YX_BLOCK{
    NSString * url = @"/users/praise_answer/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}



#pragma mark ========== 获取获取新消息数量 ==========
-(void)requestGETNewMessageNumber:YX_BLOCK{
    NSString * url = @"/users/new_message_number/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 获取新增粉丝列表 ==========
-(void)requestGETFansHistory:YX_BLOCK{
    NSString * url = @"/users/fans_history/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 获取新点赞信息 ==========
-(void)requestGETCommenHistory:YX_BLOCK{
    NSString * url = @"/users/comment_history/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 获取新评论历史记录 ==========
-(void)requestGETPraiseHistory:YX_BLOCK{
    NSString * url = @"/users/praise_history/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}


#pragma mark ========== 通过id获取足迹 ==========
-(void)requestget_track_by_id:YX_BLOCK{
    NSString * url = @"/users/get_track_by_id/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 通过id获取晒图 ==========
-(void)requestget_post_by_id:YX_BLOCK{
    NSString * url = @"/users/get_post_by_id/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 通过id获取提问 ==========
-(void)requestget_question_by_id:YX_BLOCK{
    NSString * url = @"/users/get_question_by_id/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 通过id获取雪茄 ==========
-(void)requestget_cigar_by_id:YX_BLOCK{
    NSString * url = @"/cigar/get_cigar_by_id/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}


#pragma mark ========== get_ip ==========
-(void)requestGetIP:YX_BLOCK{
    NSString * url = @"/users/get_ip/";
    [HTTP_GET(url) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 删除晒图评论子评论 ==========
-(void)requestDelChildPl_ShaiTu:YX_BLOCK{
    NSString * url = @"/users/post_comment_child/";
    [HTTP_GET([[url append:dic] append:@"/0/0/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 删除足迹评论子评论 ==========
-(void)requestDelChildPl_Zuji:YX_BLOCK{
    NSString * url = @"/users/track_comment_child/";
    [HTTP_GET([[url append:dic] append:@"/0/0/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 删除问答评论子评论 ==========
-(void)requestDelChildPl_WenDa:YX_BLOCK{
    NSString * url = @"/users/delete_answer_child/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 删除雪茄评论子评论 ==========
-(void)requestDelCigarPl_WenDa:YX_BLOCK{
    NSString * url = @"/cigar/cigar_comment_child/0/0/0/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}


#pragma mark ========== 第三方登录 ==========
-(void)requestPostThird_party:YX_BLOCK{
    NSString * url = @"/users/third_party/";
    [HTTP_POST(url) Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
    
}
#pragma mark ========== 第三方登录绑定手机号 ==========
-(void)requestPostBinding_party:YX_BLOCK{
    NSString * url = @"/users/binding_phone/";
    [HTTP_POST(url) Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ========== 更改手机号 ==========
-(void)requestChange_mobile:YX_BLOCK{
    NSString * url = @"/users/change_mobile/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 获取用户协议 ==========
-(void)requestAgreement:YX_BLOCK{
    NSString * url = @"/pub/agreement/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 绑定第三方 ==========
-(void)requestPostBinding_Accparty:YX_BLOCK{
    NSString * url = @"/users/bind_third_party/";
    [HTTP_POST(url) Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ========== 获取雪茄配件商品页标签 ==========
-(void)requestGetCigar_accessories_type:YX_BLOCK{
    NSString * url = @"/cigar/cigar_accessories_type/";
    [HTTP_GET(url) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

- (instancetype)init{
    self.advertisingArray = [[NSMutableArray alloc]init];
    self.informationArray = [[NSMutableArray alloc]init];
    self.cache1Dic = [[NSMutableDictionary alloc]init];
    self.cache1Array = [[NSMutableArray alloc]init];
    self.cache2Array = [[NSMutableArray alloc]init];
    self.isClear = NO;
    /*
    [self.informationArray addObject:@{@"author":@"kk",@"id":@"1",@"title":@"高级手卷雪茄行业延续强劲增长",@"date":@"1545896486",@"photo":@"http://www.cigaronline.cn/upload/image/20181215/20181215014853_111.jpg",@"type":@"1",@"details":@"进口优质手工雪茄继续保持强劲势头。 9月，美国雪茄协会报告的最新月份，进口量比2017年9月增长了21.3％。年初至今的进口量增长了11.1％，今年前9个月进口了2.637亿支手工雪茄 雪茄行业2018年的繁荣延续2017年强劲增长，当时手工雪茄出货量达到3.3亿支，是19年来最多的。雪茄行业已经连续第七年进口超过3亿支。尼加拉瓜再次领先，这个国家并没有放慢脚步。尽管该国出现了一些动荡，但尼加拉瓜9月份出口了1430万支优质雪茄，比2017年同期的1120万支高出27.7％。今年到目前为止，尼加拉瓜已向美国出口了1.267亿支雪茄。多米尼加雪茄的出货量也以惊人的速度增长23％，从2017年9月的910万支雪茄增加到1120万支。到2018年，该国已经出口了8640万支雪茄。洪都拉斯的出货量也有所上升，尽管只有6％，手工雪茄的数量从490万增加到520万。在2018年的前三个季度，洪都拉斯出口了4950万支优质手工雪茄。三大生产国 - 尼加拉瓜，多米尼加共和国和洪都拉斯 - 占优质手工雪茄出口的99％以上。还有三个月的报告需要考虑，所以现在还为时过早，但如果在今年最后一个季度保持11.1％的增长率，那么手工制造的雪茄进口量将达到3.66亿支。"}];
    
    [self.informationArray addObject:@{@"author":@"kk",@"id":@"2",@"title":@"古巴开放手机互联网网络，雪茄业亦收益",@"date":@"1545896486",@"photo":@"http://www.cigaronline.cn/upload/image/20181209/20181209030400_304.jpg",@"type":@"1",@"details":@"古巴国家电信局ETECSA已经为岛上的手机用户开通了互联网服务。今天早上8点开始进入3G网络，古巴当局表示将在接下来的几天内分阶段扩展到整个岛内。“互联网对人民来说是一个有用的工具，”古巴通讯部长豪尔赫·路易斯·佩尔多莫告诉记者，“必须向所有人提供。” 古巴人十年前才开始开放销售手机，此前劳尔·卡斯特罗接替了他生病的兄弟菲德尔，并将他们的买卖合法化，作为一系列改革经济现代化和支持私营部门创建的一部分。根据ETECSA的统计，在这个拥有1100万人口的国家，现在有大约530万个手机号码。 Perdomo表示，扩大互联网可用性将“鼓励经济，社会和文化发展”，并有助于创造就业和增长。到目前为止，大多数古巴人通过前往全国800个室外Wi-Fi热点之一访问互联网并使用从ETECSA购买的卡登录，允许一到五个小时的网络时间。本周互联网接入的扩展现在将允许手机用户购买流量，从600兆字节到大约7美元到4千兆字节到30美元不等。如果没有流量套餐，客户将向ETECSA支付大约10美元的1 GB数据。考虑到大多数古巴公民的工资，这两种选择都相对昂贵。据布鲁金斯学会（Brookings Institution）称，大多数古巴人每月收入约20美元，但接近60万古巴人是自雇人士，私营部门的工资也更高。古巴在互联网连接方面落后于其他国家，其政府因限制公众获取信息而受到批评。但自从前总统奥巴马和当时的古巴总统劳尔·卡斯特罗宣布四年前关系取得突破以来，互联网接入的速度已经大大提升。奥巴马在离职前对古巴的一项重要总统政策指令中表示，“增加互联网接入正在促进古巴人与更广阔世界的联系，并扩大古巴人民，特别是青年人交流信息和思想的能力。”作为政府实现商业正常化的一部分，奥巴马授权谷歌和其他美国公司直接与ETECSA合作，使古巴的互联网服务器现代化。谷歌高管陪同奥巴马总统于2016年3月对哈瓦那进行了历史性的访问。当古巴新任总统米格尔·迪亚兹 - 卡内尔于9月出席联合国大会时，谷歌高管在曼哈顿的公司总部与他和其他美国商界领袖举行会谈。 甚至在他升任总统之前，迪亚兹 - 卡内尔一直支持扩大岛上的互联网通信，这是古巴实现经济现代化的必要条件。 10月，他成为第一位开设Twitter账号的古巴总统。本周，迪亚兹 - 卡内尔在推特上称古巴将“继续推进其社会的计算机化。”业内人士预计，这一举措将大大提升古巴的国际形象，雪茄业作为古巴当地的支柱产业之一，得益于互联网，将继续扩大在整个雪茄行业的地位和知名度。"}];
    
    [self.informationArray addObject:@{@"author":@"kk",@"id":@"3",@"title":@"尼加拉瓜再受美制裁，雪茄生产商表示无影响",@"date":@"1545896486",@"photo":@"http://www.cigaronline.cn/upload/image/20181203/20181203071400_258.jpg",@"type":@"1",@"details":@"在中美洲国家发生数月的暴力和骚乱之后，特朗普总统签署了一份行政制裁命令，批准制裁尼加拉瓜副总统罗萨里奥·玛利亚·穆里略·德奥尔特加以及国家安全顾问内斯托·蒙卡达·刘。“奥尔特加政权的系统性拆解和民主制度的破坏和法治，它的滥用暴力和对平民的镇压手法，以及它的腐败导致尼加拉瓜经济的不稳定，”特朗普的制裁命令中写道“对美国的国家安全和外交政策构成了不寻常和特殊的威胁。“4月，当奥特加政府宣布彻底改变该国的社会保障体系，引发抗议活动和残酷镇压时，尼加拉瓜爆发了暴力事件。据各种新闻报道，有超过350人在暴力事件中丧生。制裁禁止穆里略，他是尼加拉瓜总统丹尼尔奥尔特加的妻子，蒙卡达与美国开展业务，并取消他们在这里拥有的任何资产。特朗普总统还呼吁在尼加拉瓜举行选举，“让尼加拉瓜人民在未来获得真正的投票权利。”此举似乎对来自世界领先的手工雪茄生产商云集的尼加拉瓜雪茄出货没有任何影响。 2017年，它向美国运送了1.48亿支雪茄，占当年运送的3.3亿支雪茄中有45％，比其他任何国家都多。今天到达的雪茄制造商们表示他们不认为制裁会对他们的业务产生任何影响。“我们现在没有看到任何问题，”洛基帕特尔说，他在尼加拉瓜的TaviCusa工厂生产了许多雪茄。虽然有一段时间早些时候路障和抗议活动导致运输出现问题，但他表示，业务已经正常运作一段时间了，因为烟草和雪茄的材料正在该国正常流通。尽管暴力事件发生，但2018年尼加拉瓜雪茄的出货量依然强劲。在2018年的前三个季度，出货量比2017年增长了近14％。 帕特尔说：“这事只是一次小风波，但我们希望他们不要向坏的放向发展。”"}];
     */
    return  self;
}
@end
