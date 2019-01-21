//
//  YXHomeGolfScoreTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeGolfScoreTableViewCell.h"

@implementation YXHomeGolfScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.statusLbl, 3, 1, KRedColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
