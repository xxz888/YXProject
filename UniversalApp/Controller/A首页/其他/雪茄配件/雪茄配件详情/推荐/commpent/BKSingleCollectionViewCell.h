//
//  BKSingleCollectionViewCell.h
//  bestkeep
//
//  Created by utouu_mhm on 16/11/14.
//  Copyright © 2016年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BKManyClassfiyKindsModel.h"
#import "masonry.h"
#import "UIImageView+WebCache.h"
//#import "BKClassifyCommon.h"
#import "BKStrikeLabel.h"
@interface BKSingleCollectionViewCell : UICollectionViewCell

//@property (nonatomic,strong) BKManyClassfiySecondModel *singleGoodsModel;

@property (nonatomic,strong) UIImageView *goodsImgeView;

@property (nonatomic,strong) UILabel *goodsNameLabel;
@property (nonatomic,strong) UILabel *goodsPriceLabel;
@property (nonatomic,strong) BKStrikeLabel *goodsMarketPriceLabel;
@property (nonatomic,strong) UIImageView *CrossBorderAmoyImgView;//跨境淘
@property (nonatomic,strong) UIImageView *willSaleImgV;//即将上线
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *bgView;
@end
