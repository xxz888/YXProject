//
//  YXDingZhiDetailTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiDetailTableViewCell.h"

@implementation YXDingZhiDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [ShareManager fiveStarView:5 view:self.starView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)zanAction:(id)sender {
    
}
- (IBAction)talkAction:(id)sender {
    
}
@end
