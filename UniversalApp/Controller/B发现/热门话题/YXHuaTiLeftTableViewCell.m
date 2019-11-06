//
//  YXHuaTiLeftTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/6.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXHuaTiLeftTableViewCell.h"

@implementation YXHuaTiLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ViewRadius(self.titleLbl, self.titleLbl.frame.size.width/7.5);
    self.titleLbl.font = SYSTEMFONT(14.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
