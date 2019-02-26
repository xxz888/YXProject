//
//  YXFindQuestionTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindQuestionTableViewCell.h"
#import "XHWebImageAutoSize.h"
@implementation YXFindQuestionTableViewCell
+(CGFloat)cellMoreHeight:(NSDictionary *)dic{
    NSArray * plArray =  dic[@"answer"];
    CGFloat height_size = [ShareManager inTextFieldOutDifColorView:[dic[@"question"] UnicodeToUtf8]];
    CGFloat imageHeight = [dic[@"pic1"] length] <= 5 ? 0 : 100;
    CGFloat lastHeight =
    (plArray.count >= 1 ? 25 : 0) +
    (plArray.count >= 2 ? 25 : 0) +
    (plArray.count >= 2 ? 25 : 0) +
    height_size +
    imageHeight;
    return lastHeight + 215 ;
}
- (IBAction)openAction:(id)sender{
    //将当前对象的isShowMoreText属性设为相反值
    self.dataDic[@"isShowMoreText"] = [self.dataDic[@"isShowMoreText"] isEqualToString:@"1"] ? @"0" : @"1";
    if (self.showMoreTextBlock){
        self.showMoreTextBlock(self,self.dataDic);
    }
}
-(void)setCellValue:(NSDictionary *)dic{
    [self cellValueDic:dic searchBtn:self.searchBtn pl1NameLbl:self.pl1NameLbl pl2NameLbl:self.pl2NameLbl pl1ContentLbl:self.pl1ContentLbl pl2ContentLbl:self.pl2ContentLbl titleImageView:self.titleImageView addPlImageView:self.addPlImageView talkCount:self.talkCount titleLbl:self.titleLbl timeLbl:self.timeLbl mapBtn:self.mapBtn likeBtn:self.likeBtn zanCount:self.zanCount];
    
    self.pl1Height.constant = [self getPl1HeightPlArray:dic];
    self.pl2Height.constant = [self getPl2HeightPlArray:dic];
    self.plAllHeight.constant = [self getPlAllHeightPlArray:dic];
    self.textHeight.constant = [self getLblHeight:dic];
    self.titleTagLbl1.text = [dic[@"title"] UnicodeToUtf8];
    self.titleTagLbl2.text = [dic[@"question"] UnicodeToUtf8];
    
    
    NSString * str1 = [(NSMutableString *)dic[@"pic1"] replaceAll:@" " target:@"%20"];
    NSString * str2 = [(NSMutableString *)dic[@"pic2"] replaceAll:@" " target:@"%20"];
    NSString * str3 = [(NSMutableString *)dic[@"pic3"] replaceAll:@" " target:@"%20"];
    
    
    if (str1.length <= 0) {
        self.midImageView1.image = [UIImage imageNamed:@""];
    }else{
        [self.midImageView1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }
    if (str2.length <= 0) {
        self.midImageView2.image = [UIImage imageNamed:@""];
    }else{
        [self.midImageView2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }
    if (str3.length <= 0) {
        self.midImageView3.image = [UIImage imageNamed:@""];
    }else{
        [self.midImageView3 sd_setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }
    if (str1.length<=0 && str2.length<=0 && str3.length<=0) {
        self.imvHeight.constant = 0;
    }
    if ([self.mapBtn.titleLabel.text isEqualToString:@""] || !self.mapBtn.titleLabel.text) {
        self.nameCenter.constant = self.titleImageView.frame.origin.y;
    }
    [ShareManager setLineSpace:9 withText:[self.titleTagLbl2.text UnicodeToUtf8] inLabel:self.titleTagLbl2 tag:@""];

}

-(CGFloat)getPl1HeightPlArray:(NSDictionary *)dic{
    NSArray * plArray =  dic[@"answer"];
    return plArray.count >= 1 ? 25 : 0;
}
-(CGFloat)getPl2HeightPlArray:(NSDictionary *)dic{
    NSArray * plArray =  dic[@"answer"];
    return plArray.count >= 2 ? 25 : 0;
}
-(CGFloat)getPlAllHeightPlArray:(NSDictionary *)dic{
    NSArray * plArray =  dic[@"answer"];
    return plArray.count >= 2 ? 25 : 0;
}
-(CGFloat)getLblHeight:(NSDictionary *)dic{
    NSString * titleText = dic[@"question"];
    CGFloat height_size = [ShareManager inTextFieldOutDifColorView:[titleText UnicodeToUtf8]];
    return height_size;
}
- (IBAction)likeBtnAction:(id)sender {
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    if (self.zanblock1) {
        self.zanblock1(self);
    }
}
- (IBAction)searchAllPlBtnAction:(id)sender{
    self.jumpDetail1VCBlock(self);
}
- (IBAction)shareAction:(id)sender{
    self.shareQuestionblock(self);
}
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
@end
