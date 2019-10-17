//
//  YXFindSearchTagViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/4/2.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "YXMineImageCollectionViewCell.h"
#import "HGBaseViewController.h"
#import "YXMineImageViewController.h"
#import "YXMineAndFindBaseViewController.h"

//typedef NS_ENUM(NSUInteger,GoodsListShowType){
//    singleLineShowOneGoods,
//    signleLineShowDoubleGoods,
//};
@interface YXFindSearchTagDetailViewController : YXMineAndFindBaseViewController
@property (nonatomic,assign) BOOL whereCome;//YES 为我的界面进来的
@property (nonatomic,copy) NSString * userId;//我的界面 下边 如果是other，要传id请求，晒图和文章
@property (nonatomic,assign)GoodsListShowType  showType; //商品列表展现方式
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString *key;
@property (nonatomic, assign) GoodsListShowType goodsShowType;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) BOOL isEnlarge;
@property (nonatomic,strong) NSDictionary * startDic;
@end
