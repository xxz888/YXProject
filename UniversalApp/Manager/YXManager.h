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
@end
