//
//  YXMineShouHuoTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineShouHuoTableViewCell.h"

@implementation YXMineShouHuoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.morenBtn setImage:[UIImage imageNamed:@"shouhuo_unSel"] forState:UIControlStateNormal];
    [self.morenBtn setImage:[UIImage imageNamed:@"shouhuo_sel"] forState:UIControlStateSelected];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)morenAction:(UIButton *)sender {
    //如果点击的那个是默认的,就不做任何操作
    if ([self.dic[@"default"] integerValue] == 1) {
        return;
    }
    self.morenBtn.selected = !self.morenBtn.selected;
    self.morenbtnblock(sender.tag);
}

- (IBAction)editAction:(UIButton *)sender {
    self.btnblock(sender.tag);
}
@end
