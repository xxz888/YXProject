//
//  YXHomeXueJiaWenHuaTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaWenHuaTableViewCell.h"

@implementation YXHomeXueJiaWenHuaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.wenhuaImageView.layer.masksToBounds = YES;
    self.wenhuaImageView.layer.cornerRadius = 3;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
