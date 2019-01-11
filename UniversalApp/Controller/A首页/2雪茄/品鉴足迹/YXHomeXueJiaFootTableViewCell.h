//
//  YXHomeXueJiaFootTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeXueJiaFootTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *footImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *footTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *footPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *footTimeLbl;
@property (weak, nonatomic) IBOutlet UIView *footStarView;

@end

NS_ASSUME_NONNULL_END
