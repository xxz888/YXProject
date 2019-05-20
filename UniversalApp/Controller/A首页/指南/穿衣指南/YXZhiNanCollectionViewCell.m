//
//  YXZhiNanCollectionViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/17.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNanCollectionViewCell.h"

@implementation YXZhiNanCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collImageView.layer.masksToBounds = YES;
    self.collImageView.layer.cornerRadius = self.collImageView.frame.size.width / 2.0;
    
}

@end
