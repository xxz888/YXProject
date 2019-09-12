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
    [HTTP_GET([[@"/pub/get_user_collect/" append:dic] append:@"/"]) sucess:^(id responseObject) {
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
    [HTTP_POST(@"/users/post/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 编辑晒图 ==========
-(void)requestEditFaBuImagePOST:YX_BLOCK{
    [HTTP_POST(@"/users/update_post/") Parameters:dic sucess:^(id responseObject) {
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
    NSString * url = @"/users/post/?type=";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
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
    NSString * url = @"/users/others/5/";
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
#pragma mark ==========根据用户id获取个人资料,彼此的关注状态 ==========
-(void)requestGetFind_My_user_Info:YX_BLOCK{
    NSString * url = @"/users/personal_data/";
    [HTTP_GET([[url append:dic] append:@""])  sucess:^(id responseObject) {
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


#pragma mark ========== 删除晒图评论 ==========
-(void)requestDelFatherPl_ShaiTu:YX_BLOCK{
    NSString * url = @"/users/post_comment/0/";
    [HTTP_GET([[url append:dic] append:@"/0/0/"]) sucess:^(id responseObject) {
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
#pragma mark ========== 删除问答评论 ==========
-(void)requestDelFatherPl_WenDa:YX_BLOCK{
    NSString * url = @"/users/delete_answer/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 删除足迹评论 ==========
-(void)requestDelFatherPl_Zuji:YX_BLOCK{
    NSString * url = @"/users/track_comment/0/";
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
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 获取雪茄文化评论列表 ==========
-(void)requestGetCigar_culture_comment:YX_BLOCK{
    NSString * url = @"/cigar/cigar_culture_comment/1/0/";
    [HTTP_GET([url append:dic]) sucess:^(id responseObject){
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 评论雪茄文化 ==========
-(void)requestPostCigar_culture_comment:YX_BLOCK{
    NSString * url = @"/cigar/cigar_culture_comment/0/0/0/0/";
    [HTTP_POST(url) Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

#pragma mark ========== 点赞/取消点赞雪茄文化 ==========
-(void)requestGetCigar_culture_praise:YX_BLOCK{
    NSString * url = @"/cigar/cigar_culture_praise/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}


#pragma mark ========== 删除雪茄文化评论 ==========
-(void)requestGetDelCigar_culture_comment:YX_BLOCK{
    NSString * url = @"/cigar/cigar_culture_comment/0/";
    [HTTP_GET([[url append:dic] append:@"/0/0/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========点赞/取消点赞雪茄文化评论 ==========
-(void)requestDianZanCigar_culture_comment_praise:YX_BLOCK{
    NSString * url = @"/cigar/cigar_culture_comment_praise/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========获取雪茄文化评论子评论列表 ==========
-(void)requestGetCigar_culture_comment_child:YX_BLOCK{
    NSString * url = @"/cigar/cigar_culture_comment_child/0/";
    [HTTP_GET([[url append:dic] append:@"/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========删除雪茄文化评论子评论 ==========
-(void)requestDelGetCigar_culture_comment_child:YX_BLOCK{
    NSString * url = @"/cigar/cigar_culture_comment_child/";
    [HTTP_GET([[url append:dic] append:@"/0/0/"])  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========发布雪茄文化评论子评论 ==========
-(void)requestFaBuCigar_culture_comment_child:YX_BLOCK{
    NSString * url = @"/cigar/cigar_culture_comment_child/0/0/0/";
    [HTTP_POST(url)  Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ==========产地列表 ==========
-(void)requestGetCigar_brand_site:YX_BLOCK{
    NSString * url = @"/cigar/cigar_brand_site/";
    [HTTP_GET(url)  sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}


#pragma mark ========== 获取雪茄配件点评信息 ==========
-(void)requestCigar_accessories_commentGet:YX_BLOCK{
    NSString * url = @"/cigar/cigar_accessories_comment/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ==========发布/修改雪茄配件点评==========
-(void)requestCigar_accessories_commentPOST:YX_BLOCK{
    [HTTP_POST(@"/cigar/cigar_accessories_comment/0/0/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

#pragma mark ==========点赞/取消点赞雪茄配件评论信息==========
-(void)requestPraise_cigar_accessories_commentPOST:YX_BLOCK{
    [HTTP_POST(@"/cigar/praise_cigar_accessories_comment/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}
#pragma mark ==========发布雪茄配件评论信息子评论==========
-(void)requestCigar_accessories_comment_childPOST:YX_BLOCK{
    [HTTP_POST(@"/cigar/cigar_accessories_comment_child/0/0/0/0/") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

#pragma mark ========== 删除雪茄配件评论信息子评论 ==========
-(void)requestCigar_accessories_comment_child:YX_BLOCK{
    NSString * url = @"/cigar/cigar_accessories_comment_child/0/0/0/";
    [HTTP_GET([[url append:dic] append:@"/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 获取子评论列表 ==========
-(void)requestCigar_accessories_comment_childGet:YX_BLOCK{
    NSString * url = @"/cigar/cigar_accessories_comment_child/1/";
    [HTTP_GET([[url append:dic] append:@"/0/"]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}




#pragma mark ========== 公共接口:评论 ==========
-(void)requestPubFaBuPingLunComment:YX_BLOCK{
    NSString * url = @"/pub/public_comment/";
    [HTTP_POST(url) Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

#pragma mark ========== 公共接口：删除评论 ==========
-(void)requestPubSearchAndDelComment:YX_BLOCK{
    NSString * url = @"/pub/public_comment/?";
    [HTTP_GET([url append:dic]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 公共接口：点赞 ==========
-(void)requestPubDianZanComment:YX_BLOCK{
    NSString * url = @"/pub/public_comment_praise/?comment_id=";
    [HTTP_GET([url append:dic]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 公共接口：获取XX评论子评论列表 ==========
-(void)requestPubSearchChildPingLunListComment:YX_BLOCK{
    NSString * url = @"/pub/public_comment_child/?";
    [HTTP_GET([url append:dic]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 公共接口：获取XX评论子评论列表 ==========
-(void)requestPubSearchAndDelChildComment:YX_BLOCK{
    NSString * url = @"/pub/public_comment_child/?child_id=";
    [HTTP_GET([url append:dic]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}
#pragma mark ========== 发布子评论 ==========
-(void)requestPubFaBuChildPingLunComment:YX_BLOCK{
    NSString * url = @"/pub/public_comment_child/";
    [HTTP_POST(url) Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}


#pragma mark ========== 签到 ==========
-(void)requestUsersSign_in_Action:YX_BLOCK{
    NSString * url = @"/users/sign_in/";
    [HTTP_GET([url append:dic]) sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {}];
}

#pragma mark ========== 签到记录 ==========
-(void)requestUsersSign_in_List:YX_BLOCK{
    NSString * url = @"/users/sign_in/";
    [HTTP_POST(url) Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) { }];
}

#pragma mark ========== 获取积分历史记录 ==========
-(void)requestUsersIntegral_history_list:YX_BLOCK{
    NSString * url = @"/users/integral_history/?type=";
    [HTTP_GET([url append:dic]) sucess:^(id responseObject) {
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
    self.moreBool = NO;
    return  self;
}
@end
