//
//  YXHomeCountryViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/4/1.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeCountryViewController : RootViewController
-(void)requestCigar_brand:(NSString *)type;
@property (strong, nonatomic) UITableView *yxTableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * hotDataArray;

@property (nonatomic,strong) NSMutableArray * dataArrayTag;
@property (nonatomic,strong) NSMutableArray * indexArray;
//第二步 根据第一步获取到的 拼音首字母 对汉字进行排序
-(NSMutableArray *)userSorting:(NSMutableArray *)modelArr;
//九宫格
- (void)createMiddleCollection;
@property (nonatomic,assign) BOOL whereCome;//yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
@property (nonatomic,strong) NSString * cigar_id;

@end

NS_ASSUME_NONNULL_END
