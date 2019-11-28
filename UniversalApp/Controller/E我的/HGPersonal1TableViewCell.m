//
//  HGPersonal1TableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "HGPersonal1TableViewCell.h"

@implementation HGPersonal1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellData:(NSDictionary *)dic type:(NSInteger)type{
    NSString * photo = @"";
    NSString * tag = @"";
    NSString * contentString = @"";
    NSString * collectString = @"";
    
    if (type == 2001) {
       NSDictionary * titleDic = dic[@"title"];
        photo = titleDic[@"photo"];
       tag= titleDic[@"name"];
       contentString = titleDic[@"intro"];
       collectString = NSIntegerToNSString([titleDic[@"collect_number"] integerValue]);
    }else{
        photo =dic[@"photo"] ;
        tag= dic[@"tag"];
        contentString = [NSIntegerToNSString([dic[@"post_number"] integerValue]) append:@"篇帖子"];
        collectString = NSIntegerToNSString([dic[@"collect_number"] integerValue]);
    }
    [self.titleImv sd_setImageWithURL:[NSURL URLWithString:[WP_TOOL_ShareManager addImgURL:photo]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.titleLbl.text = tag;
    self.contentLbl.text = contentString;
    self.collectLbl.text = [collectString append:@" 人收藏"];
    
    [self addShadowToView:self.yinyingView withColor:KBlackColor];

}
/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.2;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    theView.layer.cornerRadius = 5;
    
}
@end
