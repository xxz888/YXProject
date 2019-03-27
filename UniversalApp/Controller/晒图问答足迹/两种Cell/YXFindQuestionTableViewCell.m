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
    NSArray * commentArray =  dic[@"answer"];
    CGFloat height_size = [ShareManager inTextOutHeight:[dic[@"question"] UnicodeToUtf8] lineSpace:9 fontSize:14];
    CGFloat imageHeight = [dic[@"pic1"] length] <= 5 ? 0 : 100;
    
    
    CGFloat plHeight = 0;
    BOOL showPlAllLbl = NO;

    if (dic[@"plHeight"]) {
        plHeight = [dic[@"plHeight"] floatValue];
    }else{
        NSString * connectStr = @"";
        NSString * comment_number = @"";
        if (dic[@"answer"]) {
            commentArray = dic[@"answer"];
            if (commentArray && commentArray.count>=1) {
                NSString * str1 = [[commentArray[0][@"user_name"] UnicodeToUtf8] append:@":"];
                NSString * str2= [commentArray[0][@"answer"] UnicodeToUtf8];
                if (commentArray.count == 1) {
                    connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@",str1,str2]];
                }else{
                    connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@\n",str1,str2]];
                }
            }
            if (commentArray && commentArray.count>=2) {
                NSString * str1 = [[commentArray[1][@"user_name"] UnicodeToUtf8] append:@":"];
                NSString * str2= [commentArray[1][@"answer"] UnicodeToUtf8];
                connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@",str1,str2]];
            }
            if ([dic[@"comment_number"] integerValue] > commentArray.count) {
                showPlAllLbl = YES;
            }
            comment_number = kGetString(dic[@"comment_number"]);
        }
        plHeight = [ShareManager inTextOutHeight:connectStr lineSpace:9 fontSize:14];
    }

    
    CGFloat lastHeight =
    (showPlAllLbl ? 25 : 0) +
    plHeight +
    height_size +
    imageHeight;
    return lastHeight + 200 ;
}
- (IBAction)openAction:(id)sender{
    //将当前对象的isShowMoreText属性设为相反值
    self.dataDic[@"isShowMoreText"] = [self.dataDic[@"isShowMoreText"] isEqualToString:@"1"] ? @"0" : @"1";
    if (self.showMoreTextBlock){
        self.showMoreTextBlock(self,self.dataDic);
    }
}
-(void)setCellValue:(NSDictionary *)dic{
    [self cellValueDic:dic searchBtn:self.searchBtn pl1NameLbl:self.pl1NameLbl pl2NameLbl:self.pl2NameLbl pl1ContentLbl:self.pl1ContentLbl pl2ContentLbl:self.pl2ContentLbl titleImageView:self.titleImageView addPlImageView:self.addPlImageView talkCount:self.talkCount titleLbl:self.titleLbl timeLbl:self.timeLbl mapBtn:self.mapBtn likeBtn:self.likeBtn zanCount:self.zanCount plLbl:self.plLbl];
    
    
    
    
    NSArray * commentArray;
    NSString * connectStr = @"";
    NSString * comment_number = @"";
    BOOL showPlAllLbl = NO;
    if (dic[@"plContent"]) {
        connectStr = dic[@"plContent"];
    }else{
        if (dic[@"answer"]) {
            commentArray = dic[@"answer"];
            if (commentArray && commentArray.count>=1) {
                NSString * str1 = [[commentArray[0][@"user_name"] UnicodeToUtf8] append:@":"];
                NSString * str2= [commentArray[0][@"answer"] UnicodeToUtf8];
                if (commentArray.count == 1) {
                    connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@",str1,str2]];
                }else{
                    connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@\n",str1,str2]];
                }
            }
            if (commentArray && commentArray.count>=2) {
                NSString * str1 = [[commentArray[1][@"user_name"] UnicodeToUtf8] append:@":"];
                NSString * str2= [commentArray[1][@"answer"] UnicodeToUtf8];
                connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@",str1,str2]];
            }
            
            if ([dic[@"comment_number"] integerValue] > commentArray.count) {
                showPlAllLbl = YES;
            }
            comment_number = kGetString(dic[@"comment_number"]);
        }
    }
    self.plLbl.text = connectStr;
 
    //评论高度
    self.pl1Height.constant = [ShareManager inTextOutHeight:self.plLbl.text lineSpace:9 fontSize:14];
    if ([connectStr contains:@"\n"]) {
        [ShareManager setLineSpace:9 withText:self.plLbl.text inLabel:self.plLbl tag:dic[@"index"]];
    }
    //查看所有多少评论
    self.plAllHeight.constant = showPlAllLbl ? 25 : 0;
    NSString * allPlCountString = [NSString stringWithFormat:@"查看全部%@评论",comment_number];
    allPlCountString = self.plAllHeight.constant == 0 ? @"" : allPlCountString;
    [self.searchBtn setTitle:allPlCountString forState:UIControlStateNormal];
    
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
    if (str1.length<=5 && str2.length<=5 && str3.length<=5) {
        self.imvHeight.constant = 0;
    }else{
        self.imvHeight.constant = 100;
    }
    
    if ([dic[@"publish_site"] isEqualToString:@""] || !dic[@"publish_site"] ) {
        self.nameCenter.constant = self.titleImageView.frame.origin.y;
    }else{
        self.nameCenter.constant = 0;
    }
    [ShareManager setLineSpace:9 withText:[self.titleTagLbl2.text UnicodeToUtf8] inLabel:self.titleTagLbl2 tag:@""];

}

-(CGFloat)getLblHeight:(NSDictionary *)dic{
    NSString * titleText = dic[@"question"];
    CGFloat height_size = [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
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


- (IBAction)addPlAction:(id)sender {
    self.addPlActionblock(self);
}


@end
