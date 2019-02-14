//
//  YXFindImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindImageTableViewCell.h"

@implementation YXFindImageTableViewCell
+(CGFloat)cellMoreHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    /*
     whereCome = NO 为晒图  YES为足迹
     */
    NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    
    //展开后得高度(计算出文本内容的高度+固定控件的高度)
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [titleText boundingRectWithSize:CGSizeMake(KScreenWidth - 20 - 30, 100000) options:option attributes:attribute context:nil].size;
 
    return size.height + (whereCome ? 710:680) - 30;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    /*
     whereCome = NO 为晒图  YES为足迹
     */
    NSString * titleText = [NSString stringWithFormat:@"%@%@",self.whereCome ? self.dataDic[@"content"]:self.dataDic[@"describe"],self.dataDic[@"index"]];
    self.titleTagLbl.text = titleText;
    [ShareManager inTextFieldOutDifColorView:self.titleTagLbl tag:self.dataDic[@"index"]];
    
    if ([self.dataDic[@"isShowMoreText"] isEqualToString:@"1"]){
        ///计算文本高度
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
        CGSize size = [titleText boundingRectWithSize:CGSizeMake(KScreenWidth - 20 - 30, 100000) options:option attributes:attribute context:nil].size;
        self.titleTagLblHeight.constant = size.height + 10;
        [self.openBtn setTitle:@"收起" forState:UIControlStateNormal];
    }
    else{
        [self.openBtn setTitle:@"展开" forState:UIControlStateNormal];
        self.titleTagLblHeight.constant = 30;
    }
}
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
    NSString * str = [(NSMutableString *) (whereCome ? dic[@"pic1"]:dic[@"photo1"]) replaceAll:@" " target:@"%20"];
    [self.midImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
 


    
    
    
    
    
    
    
    
    
    NSString * str1 = [(NSMutableString *)dic[@"photo"] replaceAll:@" " target:@"%20"];
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.titleLbl.text = dic[@"user_name"];
    self.timeLbl.text = [ShareManager updateTimeForRow:[dic[@"publish_time"] longLongValue]];
    
    /*
     whereCome = NO 为晒图  YES为足迹
    */
    NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    self.titleTagLbl.text = titleText;
    [ShareManager inTextFieldOutDifColorView:self.titleTagLbl tag:dic[@"index"]];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [titleText boundingRectWithSize:CGSizeMake(KScreenWidth - 20 - 30, 100000) options:option attributes:attribute context:nil].size;
//    self.openBtn.hidden = size.width < KScreenWidth - 20 - 30;
    if (whereCome) {
        //足迹界面要 足迹这一行
        self.titleTagtextViewHeight.constant = 30;
        self.titleTagtextView.text = [@"来自足迹·" append:dic[@"publish_site"]];
        self.titleTagtextView.textColor = KBlackColor;
    }else{
        //晒图界面 不要这一行
        self.titleTagtextViewHeight.constant = 0;
    }

    [self.mapBtn setTitle:dic[@"publish_site"] forState:UIControlStateNormal];
    
    NSArray * commentArray = dic[@"comment_list"];
    if (commentArray.count > 0) {
        self.pl1NameLbl.text = [commentArray[0][@"user_name"] append:@":"];
        self.pl2NameLbl.text = commentArray[0][@"comment"];
    }
    if (commentArray.count > 1){
        self.pl1ContentLbl.text = [commentArray[1][@"user_name"] append:@":"];
        self.pl2ContentLbl.text = commentArray[1][@"comment"];
    }
    
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [self.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
 
    UserInfo *userInfo = curUser;
    NSString * str2 = [(NSMutableString *)userInfo.photo replaceAll:@" " target:@"%20"];
    [self.addPlImageView sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.talkCount.text = kGetString(dic[@"comment_number"]);
    
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

- (IBAction)openAction:(id)sender{
    //将当前对象的isShowMoreText属性设为相反值
    self.dataDic[@"isShowMoreText"] = [self.dataDic[@"isShowMoreText"] isEqualToString:@"1"] ? @"0" : @"1";
    if (self.showMoreTextBlock){
        self.showMoreTextBlock(self,self.dataDic);
    }
}
@end
