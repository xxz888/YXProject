//
//  YXMineAndFindBaseViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "YXFirstFindImageTableViewCell.h"
#import "Moment.h"
#import "YXMineImageDetailViewController.h"
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN


@interface YXMineAndFindBaseViewController : RootViewController
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (strong, nonatomic) UITableView *yxTableView;
@property (nonatomic,assign) CGFloat lastScrollViewOffsetY;
@property (nonatomic,assign) CGFloat totalKeybordHeight;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic,strong) NSDictionary * startDic;

#pragma mark ========== 足迹点赞 ==========
-(void)requestDianZan_ZuJI_Action:(NSIndexPath *)indexPath;
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZan_Image_Action:(NSIndexPath *)indexPath;
-(void)requestAction;
-(void)requestMine_AllList;
@property (nonatomic, strong) UILabel * nodataImg;

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
-(void)tableviewCon;
- (void)saveImage:(UMSocialPlatformType)umType;

@end

NS_ASSUME_NONNULL_END
