//
//  YXManager.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessdBlockType)();
typedef void(^FailBlockType)();
typedef void(^SuccessdBlockTypeParameter)(id object);

#define YX_BLOCK (id)dic success:(SuccessdBlockTypeParameter)successBlock

@interface YXManager : NSObject
+ (instancetype)sharedInstance;

@property(nonatomic,strong)NSMutableArray * advertisingArray;
@property(nonatomic,strong)NSMutableArray * informationArray;

@property(nonatomic)BOOL isHaveIcon;
#pragma mark ========== GET请求模版 ==========
-(void)requestGET:AD_BLOCK paramters:(NSString *)paramters;
#pragma mark ========== POST请求模版 ==========
-(void)requestPOST:AD_BLOCK;
#pragma mark ==========我的关注==========
-(void)requestLikesGET:YX_BLOCK;
#pragma mark ==========登录==========
-(void)requestLoginPOST:YX_BLOCK;
#pragma mark ==========登录验证码==========
-(void)requestSmscodeGET:YX_BLOCK;
#pragma mark ========== 请求广告 ==========
-(void)requestGETAdvertising:YX_BLOCK;
#pragma mark ========== 请求新闻 ==========
-(void)requestGETInformation:YX_BLOCK;
#pragma mark ========== 请求品牌 ==========
-(void)requestCigar_brand:YX_BLOCK;
#pragma mark ========== 品牌详情 ==========
-(void)requestCigar_brand_detailsPOST:YX_BLOCK;
#pragma mark ========== 品牌详情点赞收藏 ==========
-(void)requestCollect_cigarPOST:YX_BLOCK;
#pragma mark ========== 品牌是否关注 ==========
-(void)requestMy_concern_cigarPOST:YX_BLOCK;
#pragma mark ========== 发布晒图 ==========
-(void)requestFaBuImagePOST:YX_BLOCK;
#pragma mark ==========晒图列表==========
-(void)requestImageListGET:YX_BLOCK;
#pragma mark ==========请求七牛tocken==========
-(void)requestQiniu_tokenGET:YX_BLOCK;
#pragma mark ==========发布文章==========
-(void)requestEssayPOST:YX_BLOCK;
#pragma mark ==========文章列表==========
-(void)requestEssayListGET:YX_BLOCK;
#pragma mark ==========取消关注==========
-(void)requestLikesActionGET:YX_BLOCK;
#pragma mark ==========详情列表==========
-(void)requestGetDetailListPOST:YX_BLOCK;
#pragma mark ==========点评请求==========
-(void)requestCigar_commentGET:YX_BLOCK;
#pragma mark ==========雪茄五星的评价==========
-(void)requestCigar_commentPOST:YX_BLOCK;
#pragma mark ==========雪茄文化列表==========
-(void)requestCigar_accessories_cultureGET:YX_BLOCK;
#pragma mark ==========雪茄配件列表==========
-(void)requestCigar_accessoriesGET:YX_BLOCK;
#pragma mark ==========雪茄提问列表==========
-(void)requestQuestionGET:YX_BLOCK;
#pragma mark ==========雪茄发布提问==========
-(void)requestFaBuQuestionPOST:YX_BLOCK;
#pragma mark ==========点赞/取消点赞文章评论==========
-(void)requestEssay_comment_praisePOST:YX_BLOCK;
#pragma mark ==========发布文章评论子评论==========
-(void)requestEssay_comment_childPOST:YX_BLOCK;
#pragma mark ==========点赞/取消点赞雪茄评论==========
-(void)requestPraise_cigaPr_commentPOST:YX_BLOCK;
#pragma mark ==========发布雪茄评论信息子评论==========
-(void)requestCigar_comment_childPOST:YX_BLOCK;
#pragma mark ==========获取子评论列表==========
-(void)requestCigar_comment_childGET:YX_BLOCK;
#pragma mark ==========雪茄文化列表==========
-(void)requestCigar_cultureGET:YX_BLOCK;
#pragma mark ==========雪茄配件列表==========
-(void)requestCigar_accessories_CbrandGET:YX_BLOCK;
#pragma mark ==========获取回答列表==========
-(void)requestAnswerListGET:YX_BLOCK;
#pragma mark ==========发布回答==========
-(void)requestFaBuHuiDaPOST:YX_BLOCK;
#pragma mark ==========获取子回答列表==========
-(void)requestAnswer_childListGET:YX_BLOCK;
#pragma mark ==========发布子回答==========
-(void)requestFaBuHuiDa_childPOST:YX_BLOCK;

#pragma mark ========== 高尔夫品牌 ==========
-(void)requestGolf_brand:YX_BLOCK;
#pragma mark ========== 关注/取消关注高尔夫品牌 ==========
-(void)requestGolf_brand_like:YX_BLOCK;
#pragma mark ==========获取高尔夫产品列表==========
-(void)requestGolf_productPOST:YX_BLOCK;
#pragma mark ========== 收藏/取消收藏高尔产品 ==========
-(void)requestGolf_product_collect:YX_BLOCK;
#pragma mark ==========获取高尔夫球场列表==========
-(void)requestGolf_coursePOST:YX_BLOCK;



#pragma mark ========== 获取晒图评论列表 ==========
-(void)requestPost_comment:YX_BLOCK;
#pragma mark ==========点赞/取消点赞晒图==========
-(void)requestPost_praisePOST:YX_BLOCK;
#pragma mark ==========评论晒图==========
-(void)requestPost_commentPOST:YX_BLOCK;
#pragma mark ==========点赞/取消点赞晒图评论==========
-(void)requestPost_comment_praisePOST:YX_BLOCK;
#pragma mark ========== 获取晒图评论子评论列表 ==========
-(void)requestPost_comment_child:YX_BLOCK;
#pragma mark ==========发布晒图评论子评论==========
-(void)requestpost_comment_childPOST:YX_BLOCK;


#pragma mark ==========点赞/取消点赞文章==========
-(void)requestPost_essay_praisePOST:YX_BLOCK;
#pragma mark ==========评论文章==========
-(void)requestPost_essay_commentPOST:YX_BLOCK;
#pragma mark ========== 获取文章评论列表 ==========
-(void)requestessay_comment:YX_BLOCK;
#pragma mark ==========点赞/取消点赞文章评论==========
-(void)requestessay_comment_praisePOST:YX_BLOCK;
#pragma mark ========== 获取晒图评论子评论列表 ==========
-(void)requestessay_comment_child:YX_BLOCK;
#pragma mark ==========发布文章评论子评论==========
-(void)requestessay_comment_childPOST:YX_BLOCK;




#pragma mark ========== 获取发现页标签数据 ==========
-(void)requestGet_users_find_tag:YX_BLOCK;
#pragma mark ========== 获取发现页标签数据全部接口 ==========
-(void)requestGet_users_find:YX_BLOCK;
@end
