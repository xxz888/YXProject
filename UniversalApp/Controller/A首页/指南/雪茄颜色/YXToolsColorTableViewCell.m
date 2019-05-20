//
//  YXToolsColorTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXToolsColorTableViewCell.h"

@implementation YXToolsColorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setCornerOnRight:50];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*设置右边圆角*/
- (void)setCornerOnRight:(CGFloat )cornerRadius{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.colorView.bounds
                                     byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.colorView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.colorView.layer.mask = maskLayer;
}
@end
