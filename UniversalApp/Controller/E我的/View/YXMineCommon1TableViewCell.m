//
//  YXMineCommon1TableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineCommon1TableViewCell.h"

@implementation YXMineCommon1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.common1GuanzhuBtn, 5, 1,[UIColor darkGrayColor]);
    [self.common1ImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.common1ImageView.layer.masksToBounds = YES;
    self.common1ImageView.layer.cornerRadius = self.common1ImageView.frame.size.width / 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)common1GuanZhuAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBtnAction:tag:)]) {
        [self.delegate clickBtnAction:self.common1GuanzhuBtn.tag tag:self.tag];
    }
}
@end
