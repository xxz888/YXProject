//
//  YXDingZhiTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/11.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiTableViewCell.h"

@implementation YXDingZhiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [ShareManager fiveStarView:2 view:self.starView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
