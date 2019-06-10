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
@property (nonatomic,assign) BOOL isClear;
@property(nonatomic,strong)NSMutableArray * advertisingArray;
@property(nonatomic,strong)NSMutableArray * informationArray;
@property(nonatomic,strong)NSMutableDictionary * cache1Dic;
@property(nonatomic,strong)NSMutableArray * cache1Array;
@property(nonatomic,strong)NSMutableArray * cache2Array;
@property (nonatomic,assign) BOOL moreBool;

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
#pragma mark ==========我关注的雪茄品牌==========
-(void)requestGETMyGuanZhuList:YX_BLOCK;
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
#pragma mark ========== 根据用户id获取个人资料,彼此的关注状态 ==========
-(void)requestGetUserothers:YX_BLOCK;

#pragma mark ========== 根据用户id获取该用户的晒图 ==========
-(void)requestOtherImage:YX_BLOCK;
#pragma mark ========== 根据用户id获取该用户的文章 ==========
-(void)requestOtherEssay:YX_BLOCK;
#pragma mark ========== 根据用户id获取该用户的粉丝列表 ==========
-(void)requestOtherFenSi:YX_BLOCK;
#pragma mark ========== 根据用户id获取该用户的关注列表 ==========
-(void)requestOtherGuanZhu:YX_BLOCK;


#pragma mark ========== 我的点赞列表 ==========
-(void)requestMyDianZanList:YX_BLOCK;


#pragma mark ==========更新用户资料==========
-(void)requestUpdate_userPOST:YX_BLOCK;
#pragma mark ========== 根据用户名搜索用户 ==========
-(void)requestFind_user:YX_BLOCK;
#pragma mark ==========根据用户id获取个人资料,彼此的关注状态 ==========
-(void)requestGetFind_user_id:YX_BLOCK;
#pragma mark ==========获取TAG标签列表 ==========
-(void)requestGetTagList:YX_BLOCK;
#pragma mark ==========获取TAG标签列表 ==========
-(void)requestGetTagList_Tag:YX_BLOCK;
#pragma mark ========== 我的点评雪茄列表 ==========
-(void)requestGetMyDianPingList:YX_BLOCK;
#pragma mark ========== 我收藏的雪茄列表 ==========
-(void)requestMyXueJia_CollectionListGet:YX_BLOCK;


#pragma mark ========== 我的页面全部接口 ==========
-(void)requestGetSersAllList:YX_BLOCK;
#pragma mark ========== 其他的全部 ==========
-(void)requestGetSers_Other_AllList:YX_BLOCK;
#pragma mark ==========发布足迹 ==========
-(void)requestPost_track:YX_BLOCK;
#pragma mark ========== 获取我的足迹列表 ==========
-(void)requestGetMy_Track_list:YX_BLOCK;



#pragma mark ==========点赞/取消点赞足迹 ==========
-(void)requestDianZanFoot:YX_BLOCK;
#pragma mark ==========评论足迹 ==========
-(void)requestPingLunFoot:YX_BLOCK;
#pragma mark ==========获取最新足迹评论列表 ==========
-(void)requestGetHotFootList:YX_BLOCK;
#pragma mark ==========获取最新足迹评论列表 ==========
-(void)requestGetNewFootList:YX_BLOCK;
#pragma mark ==========获取足迹评论子评论列表 ==========
-(void)requestGetFootPingLun_Child_List:YX_BLOCK;
#pragma mark ==========发布足迹评论子评论 ==========
-(void)requestFaBuFoot_child_PingLun:YX_BLOCK;
#pragma mark ==========点赞/取消点赞足迹评论 ==========
-(void)requestDianZanFoot_PingLun:YX_BLOCK;
#pragma mark ========== 获取其他人足迹列表 ==========
-(void)requestGetOther_Track_list:YX_BLOCK;
#pragma mark ==========搜索 ==========
-(void)requestSearchFind_all:YX_BLOCK;
#pragma mark ========== 热门关键字 ==========
-(void)requestGetFind_all:YX_BLOCK;
#pragma mark ==========搜索雪茄品牌 ==========
-(void)requestSearchCigar_brand:YX_BLOCK;
#pragma mark ========== 点赞取消提问 ==========
-(void)requestPraise_question:YX_BLOCK;
#pragma mark ========== 点赞取消回答 ==========
-(void)requestPraise_answer:YX_BLOCK;
#pragma mark ========== 删除足迹 ==========
-(void)requestDel_ZuJi:YX_BLOCK;
#pragma mark ========== 删除问答 ==========
-(void)requestDel_WenDa:YX_BLOCK;
#pragma mark ========== 删除晒图 ==========
-(void)requestDel_ShaiTU:YX_BLOCK;

#pragma mark ========== 获取获取新消息数量 ==========
-(void)requestGETNewMessageNumber:YX_BLOCK;
#pragma mark ========== 获取新点赞信息 ==========
-(void)requestGETCommenHistory:YX_BLOCK;
#pragma mark ========== 获取新增粉丝列表 ==========
-(void)requestGETFansHistory:YX_BLOCK;
#pragma mark ========== 获取新评论历史记录 ==========
-(void)requestGETPraiseHistory:YX_BLOCK;

#pragma mark ========== 通过id获取足迹 ==========
-(void)requestget_track_by_id:YX_BLOCK;
#pragma mark ========== 通过id获取晒图 ==========
-(void)requestget_post_by_id:YX_BLOCK;
#pragma mark ========== 通过id获取提问 ==========
-(void)requestget_question_by_id:YX_BLOCK;
#pragma mark ========== 通过id获取雪茄 ==========
-(void)requestget_cigar_by_id:YX_BLOCK;
#pragma mark ========== get_ip ==========
-(void)requestGetIP:YX_BLOCK;

#pragma mark ========== 删除晒图评论子评论 ==========
-(void)requestDelChildPl_ShaiTu:YX_BLOCK;
#pragma mark ========== 删除足迹评论子评论 ==========
-(void)requestDelChildPl_Zuji:YX_BLOCK;
#pragma mark ========== 删除问答评论子评论 ==========
-(void)requestDelChildPl_WenDa:YX_BLOCK;
#pragma mark ========== 删除雪茄评论子评论 ==========
-(void)requestDelCigarPl_WenDa:YX_BLOCK;

#pragma mark ========== 第三方登录 ==========
-(void)requestPostThird_party:YX_BLOCK;
#pragma mark ========== 第三方登录绑定手机号 ==========
-(void)requestPostBinding_party:YX_BLOCK;
#pragma mark ========== 更改手机号 ==========
-(void)requestChange_mobile:YX_BLOCK;
#pragma mark ========== 获取用户协议 ==========
-(void)requestAgreement:YX_BLOCK;
#pragma mark ========== 绑定第三方 ==========
-(void)requestPostBinding_Accparty:YX_BLOCK;
#pragma mark ========== 获取雪茄配件商品页标签 ==========
-(void)requestGetCigar_accessories_type:YX_BLOCK;


#pragma mark ========== 获取雪茄文化评论列表 ==========
-(void)requestGetCigar_culture_comment:YX_BLOCK;
#pragma mark ========== 评论雪茄文化 ==========
-(void)requestPostCigar_culture_comment:YX_BLOCK;
#pragma mark ========== 点赞/取消点赞雪茄文化 ==========
-(void)requestGetCigar_culture_praise:YX_BLOCK;
#pragma mark ========== 删除雪茄文化评论 ==========
-(void)requestGetDelCigar_culture_comment:YX_BLOCK;
#pragma mark ==========点赞/取消点赞雪茄文化评论 ==========
-(void)requestDianZanCigar_culture_comment_praise:YX_BLOCK;
#pragma mark ==========获取雪茄文化评论子评论列表 ==========
-(void)requestGetCigar_culture_comment_child:YX_BLOCK;
#pragma mark ==========发布雪茄文化评论子评论 ==========
-(void)requestFaBuCigar_culture_comment_child:YX_BLOCK;
#pragma mark ==========获取雪茄文化评论子评论列表 ==========
-(void)requestGetCigar_culture_comment_child:YX_BLOCK;
#pragma mark ==========删除雪茄文化评论子评论 ==========
-(void)requestDelGetCigar_culture_comment_child:YX_BLOCK;

#pragma mark ==========产地列表 ==========
-(void)requestGetCigar_brand_site:YX_BLOCK;



#pragma mark ========== 获取雪茄配件点评信息 ==========
-(void)requestCigar_accessories_commentGet:YX_BLOCK;
#pragma mark ==========发布/修改雪茄配件点评==========
-(void)requestCigar_accessories_commentPOST:YX_BLOCK;
#pragma mark ==========点赞/取消点赞雪茄配件评论信息==========
-(void)requestPraise_cigar_accessories_commentPOST:YX_BLOCK;
#pragma mark ==========发布雪茄配件评论信息子评论==========
-(void)requestCigar_accessories_comment_childPOST:YX_BLOCK;
#pragma mark ========== 删除雪茄配件评论信息子评论 ==========
-(void)requestCigar_accessories_comment_child:YX_BLOCK;
#pragma mark ========== 获取子评论列表 ==========
-(void)requestCigar_accessories_comment_childGet:YX_BLOCK;



#pragma mark ========== 删除足迹评论 ==========
-(void)requestDelFatherPl_Zuji:YX_BLOCK;
#pragma mark ========== 删除问答评论 ==========
-(void)requestDelFatherPl_WenDa:YX_BLOCK;
#pragma mark ========== 删除晒图评论 ==========
-(void)requestDelFatherPl_ShaiTu:YX_BLOCK;
#pragma mark ========== 编辑晒图 ==========
-(void)requestEditFaBuImagePOST:YX_BLOCK;
@end
