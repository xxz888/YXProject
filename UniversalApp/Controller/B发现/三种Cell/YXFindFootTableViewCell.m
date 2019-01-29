//
//  YXFindFootTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindFootTableViewCell.h"

@implementation YXFindFootTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleImageView.layer.masksToBounds = YES;
    self.titleImageView.layer.cornerRadius = self.titleImageView.frame.size.width / 2.0;
    self.addPlImageView.layer.masksToBounds = YES;
    self.addPlImageView.layer.cornerRadius = self.addPlImageView.frame.size.width / 2.0;
    ViewRadius(self.midImageView, 3);
    //图片这种类型的view默认是没有点击事件的，所以要把用户交互的属性打开
    self.titleImageView.userInteractionEnabled = YES;
    //添加点击手势
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    //点击几次后触发事件响应，默认为：1
    click.numberOfTapsRequired = 1;
    [self.titleImageView addGestureRecognizer:click];
}
-(void)clickAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    self.clickImageBlock(tag);
}

-(void)setCellValue:(NSDictionary *)dic{
    
 
    
    
    NSString * titleText = [NSString stringWithFormat:@"%@%@",dic[@"content"],dic[@"index"]];
    self.titleTagtextView.text = titleText;
    [ShareManager inTextViewOutDifColorView:self.titleTagtextView tag:dic[@"index"]];
    
    
    [self.midImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"pic1"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"user_photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.titleLbl.text = dic[@"user_name"];
    self.timeLbl.text = [ShareManager timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@""];
    
    [self.mapBtn setTitle:dic[@"publish_site"] forState:UIControlStateNormal];
    self.pl1NameLbl.text = dic[@"max_hot_comment"][@"user_name"];
    self.pl1ContentLbl.text = dic[@"max_hot_comment"][@"comment"] ;
    
     NSArray * commentArray = dic[@"comment_list"];
     if (commentArray.count > 0) {
     self.pl1NameLbl.text = commentArray[0][@"user_name"];
     self.pl1ContentLbl.text = commentArray[0][@"comment"];
     }else if (commentArray.count > 1){
     self.pl2NameLbl.text = commentArray[0][@"user_name"];
     self.pl2ContentLbl.text = commentArray[0][@"comment"];
     }
    
    [self.addPlImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"user_photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
}
@end
