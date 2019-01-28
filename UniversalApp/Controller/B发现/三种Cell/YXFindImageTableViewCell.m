//
//  YXFindImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindImageTableViewCell.h"

@implementation YXFindImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = KRedColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
