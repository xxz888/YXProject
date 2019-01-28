//
//  YXMineImageViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "YXMineImageCollectionViewCell.h"
typedef NS_ENUM(NSUInteger,GoodsListShowType){
    singleLineShowOneGoods,
    signleLineShowDoubleGoods,
};
@interface YXMineImageViewController : RootViewController
@property (nonatomic,assign) BOOL whereCome;//YES 为我的界面进来的
@property (nonatomic,copy) NSString * userId;//我的界面 下边 如果是other，要传id请求，晒图和文章
@property (nonatomic,assign)GoodsListShowType  showType; //商品列表展现方式
@end
