//
//  YXMineImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineImageTableViewCell.h"

@implementation YXMineImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewRadius(self.mineImageView, 3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeAction:(id)sender{
    self.block(self);
}


@end
