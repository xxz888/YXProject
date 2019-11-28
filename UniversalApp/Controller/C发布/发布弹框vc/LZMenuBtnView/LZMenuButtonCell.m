//
//  LZMenuButtonCell.m
//  Case
//
//  Created by 栗子 on 2018/6/13.
//  Copyright © 2018年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import "LZMenuButtonCell.h"

@implementation LZMenuButtonCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
//    self.iconIV.layer.cornerRadius = 45/2;
//    self.iconIV.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.transform = CGAffineTransformMakeRotation(-M_PI);
}
- (void)setFrame:(CGRect)frame{
//    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
