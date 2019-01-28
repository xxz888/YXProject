//
//  YXMineAllImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineAllImageTableViewCell.h"

@implementation YXMineAllImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    ViewRadius(self.midImageView, 3);
    
}

- (IBAction)likeBtnAction:(id)sender {
    self.block(self);
}

@end
