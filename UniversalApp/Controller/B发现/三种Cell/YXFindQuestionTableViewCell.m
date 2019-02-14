//
//  YXFindQuestionTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindQuestionTableViewCell.h"

@implementation YXFindQuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addPlImageView.layer.masksToBounds = YES;
    self.addPlImageView.layer.cornerRadius = self.addPlImageView.frame.size.width / 2.0;
    self.titleImageView.layer.masksToBounds = YES;
    self.titleImageView.layer.cornerRadius = self.titleImageView.frame.size.width / 2.0;
    
    ViewRadius(self.midImageView1, 3);
    ViewRadius(self.midImageView2, 3);
    ViewRadius(self.midImageView3, 3);

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellValue:(NSDictionary *)dic{
    
    self.titleTagLbl1.text = dic[@"title"];
    self.titleTagLbl2.text = dic[@"question"];
    NSString * str1 = [(NSMutableString *)dic[@"pic1"] replaceAll:@" " target:@"%20"];
    NSString * str2 = [(NSMutableString *)dic[@"pic2"] replaceAll:@" " target:@"%20"];
    NSString * str3 = [(NSMutableString *)dic[@"pic3"] replaceAll:@" " target:@"%20"];

    [self.midImageView1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.midImageView2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.midImageView3 sd_setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        
    NSArray * commentArray = dic[@"answer"];
    if (commentArray.count > 0) {
        self.pl1NameLbl.text = [commentArray[0][@"user_name"]  append:@":"];
        self.pl2NameLbl.text = commentArray[0][@"answer"];
    }else if (commentArray.count > 1){
        self.pl1ContentLbl.text = [commentArray[1][@"user_name"]  append:@":"];
        self.pl2ContentLbl.text = commentArray[1][@"answer"];
    }
    
    
    
    NSString * allString = [NSString stringWithFormat:@"查看全部%@条评论",kGetString(dic[@"comment_number"])];
    if ([allString isEqualToString:@"查看全部(null)条评论"] || [allString isEqualToString:@"查看全部0条评论"]) {
        allString = @"查看全部评论";
    }
    [self.searchBtn setTitle:allString forState:UIControlStateNormal];
    
    
    
    
    
    
    
    
    NSString * str4 = [(NSMutableString *)dic[@"user_photo"] replaceAll:@" " target:@"%20"];
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:str4] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.titleLbl.text = dic[@"user_name"];
    self.timeLbl.text = [ShareManager updateTimeForRow:[dic[@"publish_time"] longLongValue]];
    [self.mapBtn setTitle:dic[@"publish_site"] forState:UIControlStateNormal];
  
    
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [self.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
     
    NSString * str5 = [(NSMutableString *)dic[@"photo1"] replaceAll:@" " target:@"%20"];
    [self.addPlImageView sd_setImageWithURL:[NSURL URLWithString:str5] placeholderImage:[UIImage imageNamed:@"img_moren"]];
}


- (IBAction)likeBtnAction:(id)sender {
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    if (self.zanblock) {
        self.zanblock(self);

    }
}

- (IBAction)searchAllPlBtnAction:(id)sender{
    self.jumpDetail1VCBlock(self);
}
@end
