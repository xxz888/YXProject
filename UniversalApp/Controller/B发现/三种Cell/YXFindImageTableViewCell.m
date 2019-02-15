//
//  YXFindImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindImageTableViewCell.h"
/*
 whereCome = NO 为晒图  YES为足迹
 */
@implementation YXFindImageTableViewCell
+(CGFloat)cellMoreHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    CGSize size = [YXMineAndFindBaseTableViewCell cellAutoHeight:titleText];
    return size.height + (whereCome ? 710:680) - 30;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSString * titleText = [NSString stringWithFormat:@"%@%@",self.whereCome ? self.dataDic[@"content"]:self.dataDic[@"describe"],self.dataDic[@"index"]];
    self.titleTagLbl.text = titleText;
    [ShareManager inTextFieldOutDifColorView:self.titleTagLbl tag:self.dataDic[@"index"]];
    [self openAndCloseAction:self.dataDic openBtn:self.openBtn layout:self.titleTagLblHeight text:titleText];
}
- (IBAction)searchAllPlBtnAction:(id)sender{
    self.jumpDetailVCBlock(self);
}
-(void)setCellValue:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    [self cellValueDic:dic searchBtn:self.searchBtn pl1NameLbl:self.pl1NameLbl pl2NameLbl:self.pl2NameLbl pl1ContentLbl:self.pl1ContentLbl pl2ContentLbl:self.pl2ContentLbl titleImageView:self.titleImageView addPlImageView:self.addPlImageView talkCount:self.talkCount titleLbl:self.titleLbl timeLbl:self.timeLbl mapBtn:self.mapBtn likeBtn:self.likeBtn];
    
    NSString * str = [(NSMutableString *) (whereCome ? dic[@"pic1"]:dic[@"photo1"]) replaceAll:@" " target:@"%20"];
    [self.midImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    self.titleTagLbl.text = titleText;
    [ShareManager inTextFieldOutDifColorView:self.titleTagLbl tag:dic[@"index"]];
    if (whereCome) {
        //足迹界面要 足迹这一行
        self.titleTagtextViewHeight.constant = 30;
        NSString * zuji = [NSString stringWithFormat:@"来自足迹·%@ %@",dic[@"cigar_info"][@"brand_name"],dic[@"cigar_info"][@"cigar_name"]];
        self.titleTagtextView.text = zuji;
    }else{
        //晒图界面 不要这一行
        self.titleTagtextViewHeight.constant = 0;
    }
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
@end
