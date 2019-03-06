//
//  YXMessageThreeDetailViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMessageThreeDetailViewCell.h"

@implementation YXMessageThreeDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleImg.layer.masksToBounds = YES;
    self.titleImg.layer.cornerRadius = self.titleImg.frame.size.width / 2.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
