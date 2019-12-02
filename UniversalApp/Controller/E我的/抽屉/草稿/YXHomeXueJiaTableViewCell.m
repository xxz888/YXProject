//
//  YXHomeXueJiaTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaTableViewCell.h"

@implementation YXHomeXueJiaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.cellImageView, 3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
