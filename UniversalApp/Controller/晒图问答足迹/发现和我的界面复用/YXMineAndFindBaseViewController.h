//
//  YXMineAndFindBaseViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "YXFindImageTableViewCell.h"
#import "YXFindQuestionTableViewCell.h"
#import "YXMineFootDetailViewController.h"
#import "Moment.h"
#import "HXEasyCustomShareView.h"
#import "YXMineImageDetailViewController.h"
#import "YXHomeXueJiaQuestionDetailViewController.h"
#import "Comment.h"
#import "YXMineViewController.h"
NS_ASSUME_NONNULL_BEGIN


@interface YXMineAndFindBaseViewController : RootViewController
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (strong, nonatomic) UITableView *yxTableView;


#pragma mark ========== 足迹点赞 ==========
-(void)requestDianZan_ZuJI_Action:(NSIndexPath *)indexPath;
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZan_Image_Action:(NSIndexPath *)indexPath;
-(void)requestAction;
-(void)requestMine_AllList;



@end

NS_ASSUME_NONNULL_END
