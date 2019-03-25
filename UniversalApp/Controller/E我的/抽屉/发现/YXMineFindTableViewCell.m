//
//  YXMineFindTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineFindTableViewCell.h"

@implementation YXMineFindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.guanzhuBtn, 13, 1, A_COlOR);
    self.titleImv.layer.masksToBounds = YES;
    self.titleImv.layer.cornerRadius = self.titleImv.frame.size.width / 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)guanzhuAction:(id)sender {
}

- (IBAction)delAction:(id)sender {
}
@end
