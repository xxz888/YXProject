//
//  YXFindImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindImageTableViewCell.h"

@implementation YXFindImageTableViewCell

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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)searchAllPlBtnAction:(id)sender{
    self.jumpDetailVCBlock(self);
}



-(void)setCellValue:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSString * str = [(NSMutableString *)dic[@"photo1"] replaceAll:@" " target:@"%20"];

    [self.midImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
 


    
    
    
    
    
    
    
    
    
    NSString * str1 = [(NSMutableString *)dic[@"photo"] replaceAll:@" " target:@"%20"];
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.titleLbl.text = dic[@"user_name"];
    self.timeLbl.text = [ShareManager updateTimeForRow:[dic[@"publish_time"] longLongValue]];
    
    /*
     whereCome = NO
                如果是图片 titleTagLbl 为 名字  titleTagtextView 为内容
                如果是图片 titleTagLbl 为 内容  titleTagtextView 为来自足迹
    */
    NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    if (whereCome) {
        self.titleTagLbl.text = titleText;
        self.titleTagtextView.text = [@"来自足迹·" append:dic[@"publish_site"]];
        [ShareManager inTextFieldOutDifColorView:self.titleTagLbl tag:dic[@"index"]];
        self.titleTagtextView.textColor = KBlackColor;
    }else{
        self.titleTagLbl.text = dic[@"user_name"];
        self.titleTagtextView.text = titleText;
        [ShareManager inTextViewOutDifColorView:self.titleTagtextView tag:dic[@"index"]];
    }

    [self.mapBtn setTitle:dic[@"publish_site"] forState:UIControlStateNormal];
    
    NSArray * commentArray = dic[@"comment_list"];
    if (commentArray.count > 0) {
        self.pl1NameLbl.text = [commentArray[0][@"user_name"] append:@":"];
        self.pl2NameLbl.text = commentArray[0][@"comment"];
    }else if (commentArray.count > 1){
        self.pl1ContentLbl.text = [commentArray[0][@"user_name"] append:@":"];
        self.pl2ContentLbl.text = commentArray[0][@"comment"];
    }
    
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [self.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    NSString * str2 = [(NSMutableString *)dic[@"photo1"] replaceAll:@" " target:@"%20"];
    [self.addPlImageView sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"img_moren"]];
}


- (IBAction)likeBtnAction:(id)sender {
    
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    self.zanblock(self);
}
- (IBAction)shareAction:(id)sender {
    self.shareblock(self);
}
@end
