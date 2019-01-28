//
//  YXMineImageCollectionViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/27.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineImageCollectionViewCell.h"

@implementation YXMineImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.essayTitleImageView.layer.masksToBounds = YES;
    self.essayTitleImageView.layer.cornerRadius = self.essayTitleImageView.frame.size.width / 2.0;
    
    ViewRadius(self.midImageView, 3);
    
}

@end
