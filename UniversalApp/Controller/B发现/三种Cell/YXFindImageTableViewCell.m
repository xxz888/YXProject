//
//  YXFindImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindImageTableViewCell.h"
#import "XHWebImageAutoSize.h"
#import "UIImageView+WebCache.h"
@implementation YXFindImageTableViewCell
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSArray * plArray = dic[@"comment_list"];
    NSString * url = whereCome ? dic[@"pic1"]:dic[@"photo1"];
    CGFloat imageHeight = [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:0];
    NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    CGFloat height_size = [ShareManager inTextFieldOutDifColorView:[titleText UnicodeToUtf8]];
    CGFloat lastHeight =
    (plArray.count >= 1 ? 25 : 0) +
    (plArray.count >= 2 ? 25 : 0) +
    (plArray.count >= 2 ? 25 : 0) +
    (whereCome ? 30 : 0) +
    height_size +
    imageHeight;
    return lastHeight + 180;
}

-(CGFloat)getImageViewSize:(NSString *)imgUrl{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    UIImage *showimage = [UIImage imageWithData:data];
    CGFloat scale = showimage.size.height/showimage.size.width;
    return KScreenWidth * scale;
}
- (IBAction)searchAllPlBtnAction:(id)sender{
    self.jumpDetailVCBlock(self);
}
-(void)setCellValue:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    [self cellValueDic:dic searchBtn:self.searchBtn pl1NameLbl:self.pl1NameLbl pl2NameLbl:self.pl2NameLbl pl1ContentLbl:self.pl1ContentLbl pl2ContentLbl:self.pl2ContentLbl titleImageView:self.titleImageView addPlImageView:self.addPlImageView talkCount:self.talkCount titleLbl:self.titleLbl timeLbl:self.timeLbl mapBtn:self.mapBtn likeBtn:self.likeBtn];
    
    
    self.pl1Height.constant = [self getPl1HeightPlArray:dic];
    self.pl2Height.constant = [self getPl2HeightPlArray:dic];
    self.plAllHeight.constant = [self getPlAllHeightPlArray:dic];
    self.titleTagLblHeight.constant = [self getLblHeight:dic whereCome:whereCome];
    self.titleTagtextViewHeight.constant = [self getTitleTagtextViewHeight:dic whereCome:whereCome];
    self.imvHeight.constant = [self getImvHeight:dic whereCome:whereCome];

    
    if ([self.mapBtn.titleLabel.text isEqualToString:@""] || !self.mapBtn.titleLabel.text) {
        self.nameCenter.constant = self.titleImageView.frame.origin.y;
    }

    
    
    
    
    NSString * titleText = [[NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"index"]] UnicodeToUtf8];
    self.titleTagLbl.text = titleText;
    NSString * zuji = [NSString stringWithFormat:@"来自足迹·%@ %@",dic[@"cigar_info"][@"brand_name"],dic[@"cigar_info"][@"cigar_name"]];
    self.titleTagtextView.text = zuji;
    [ShareManager setLineSpace:9 withText:self.titleTagLbl.text inLabel:self.titleTagLbl tag:dic[@"index"]];
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

-(CGFloat)getPl1HeightPlArray:(NSDictionary *)dic{
    NSArray * plArray = dic[@"comment_list"];
    return plArray.count >= 1 ? 25 : 0;
}
-(CGFloat)getPl2HeightPlArray:(NSDictionary *)dic{
    NSArray * plArray = dic[@"comment_list"];
    return plArray.count >= 2 ? 25 : 0;
}
-(CGFloat)getPlAllHeightPlArray:(NSDictionary *)dic{
    NSArray * plArray = dic[@"comment_list"];
    return plArray.count >= 2 ? 25 : 0;
}



-(CGFloat)getTitleTagtextViewHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    return whereCome ? 30 : 0;
}
-(CGFloat)getImvHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSString * url =  whereCome ? dic[@"pic1"]:dic[@"photo1"];
    return    [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:0];
}
-(CGFloat)getLblHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    CGFloat height_size = [ShareManager inTextFieldOutDifColorView:[titleText UnicodeToUtf8]];
    return height_size;
}


@end
