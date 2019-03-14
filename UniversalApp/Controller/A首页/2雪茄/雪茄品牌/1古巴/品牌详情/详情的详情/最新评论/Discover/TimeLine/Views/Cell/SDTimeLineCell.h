//
//  SDTimeLineCell.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import <UIKit/UIKit.h>
#import "SDTimeLineCellCommentView.h"
#import "SDTimeLineCellModel.h"
#import "UIView+SDAutoLayout.h"


#import "SDWeiXinPhotoContainerView.h"

#import "SDTimeLineCellOperationMenu.h"
#import "LEETheme.h"
#import "XHStarRateView.h"
#import "MMImageListView.h"
@protocol SDTimeLineCellDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell;
-(void)showMoreComment:(UITableViewCell *)cell;
@end

@class SDTimeLineCellModel;

@interface SDTimeLineCell : UITableViewCell
@property (nonatomic,strong)  SDTimeLineCellCommentView * commentView;



@property (nonatomic, weak) id<SDTimeLineCellDelegate> delegate;

@property (nonatomic, strong) SDTimeLineCellModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow, SDTimeLineCell *cell);
@property (nonatomic, copy) void (^didLongClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow, SDTimeLineCell *cell);
@property (nonatomic, strong) UIButton * zanButton;
@property (nonatomic, strong) UILabel * zanCountLable;


@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong)  UILabel *contentLabel;
@property (nonatomic)  SDWeiXinPhotoContainerView *picContainerView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong)  UIButton *moreButton;
@property (nonatomic, strong)  UIButton *operationButton;
@property (nonatomic)  SDTimeLineCellOperationMenu *operationMenu;
@property (nonatomic, strong)  UIButton * showMoreCommentBtn;
@property (nonatomic, strong)  UIButton *huiFuButton;
@property (nonatomic, strong)  UIView * starView;

@end
