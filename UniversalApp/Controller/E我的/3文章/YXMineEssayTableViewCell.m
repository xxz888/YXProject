//
//  YXMineEssayTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineEssayTableViewCell.h"

@implementation YXMineEssayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.essayTitleImageView.layer.masksToBounds = YES;
    self.essayTitleImageView.layer.cornerRadius = self.essayTitleImageView.frame.size.width / 2.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
