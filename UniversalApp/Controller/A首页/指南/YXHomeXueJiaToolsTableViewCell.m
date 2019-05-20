//
//  YXHomeXueJiaToolsTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXHomeXueJiaToolsTableViewCell.h"

@implementation YXHomeXueJiaToolsTableViewCell

/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,3);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    
    //    _imageView.layer.shadowOffset = CGSizeMake(5,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    
    
    //   theView.layer.masksToBounds = YES;
    theView.layer.cornerRadius = 5;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    
    [self addShadowToView:self.outsideView withColor:KBlackColor];
    
    
    self.titleImageView.layer.masksToBounds = YES;
    self.titleImageView.layer.cornerRadius = 5;
}
@end
