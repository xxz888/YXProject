//
//  YXSecondHeadCollectionViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2020/1/16.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import "YXSecondHeadCollectionViewCell.h"

@implementation YXSecondHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.tagImageView, 3);
}

@end
