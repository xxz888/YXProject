//
//  YXDingZhi1TableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhi1TableViewCell.h"

@implementation YXDingZhi1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [ShareManager fiveStarView:2 view:self.starView];
    self.starView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
