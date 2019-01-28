//
//  YXMineEssayTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineEssayTableViewCell.h"

@implementation YXMineEssayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.essayTitleImageView.layer.masksToBounds = YES;
    self.essayTitleImageView.layer.cornerRadius = self.essayTitleImageView.frame.size.width / 2.0;
    
    ViewRadius(self.midImageView, 3);
    ViewRadius(self.midTwoImageVIew, 3);

    
    //图片这种类型的view默认是没有点击事件的，所以要把用户交互的属性打开
    self.essayTitleImageView.userInteractionEnabled = YES;
    
    //添加点击手势
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    
    //点击几次后触发事件响应，默认为：1
    click.numberOfTapsRequired = 1;

    
    [self.essayTitleImageView addGestureRecognizer:click];

}
-(void)clickAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    self.clickImageBlock(tag);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeAction:(id)sender{
    self.block(self);
}


@end
