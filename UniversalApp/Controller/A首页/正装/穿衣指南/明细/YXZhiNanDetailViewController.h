//
//  YXZhiNanDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SaveCurrentIndexBlock)(NSInteger);
@interface YXZhiNanDetailViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (nonatomic,assign) BOOL whereCome;//NO为正常进入，yes为收藏进入
@property (weak, nonatomic) IBOutlet UIImageView *collImgView;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *pinglunView;

@property (nonatomic,assign)NSInteger selectItemIndex;


@property (nonatomic,copy)SaveCurrentIndexBlock savecurrentindexblock;
@property (nonatomic,assign)NSInteger savecurrentindex;//记录index


@property (nonatomic,assign)NSInteger selectCellIndex;
@property (nonatomic,strong)NSArray * selectCellArray;


@property (nonatomic,strong)NSString * firstSelectId;
@end

NS_ASSUME_NONNULL_END
