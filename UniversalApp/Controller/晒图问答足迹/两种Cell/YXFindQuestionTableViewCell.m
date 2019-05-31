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
+(CGFloat)cellNewDetailNeedHeight:(NSDictionary *)dic{
    NSString * titleText = [[NSString stringWithFormat:@"%@%@",dic[@"question"],dic[@"index"]] UnicodeToUtf8];
    CGFloat height_size = [ShareManager inTextOutHeight:titleText lineSpace:9 fontSize:14];
    CGFloat height_QuestionTitle = [ShareManager inTextOutHeight:[dic[@"title"] UnicodeToUtf8] lineSpace:9 fontSize:14];
    CGFloat imageHeight = [dic[@"pic1"] length] <= 5 ? 0 : 100;
    CGFloat lastHeight =
    height_QuestionTitle +
    height_size +
    imageHeight;
    return lastHeight + 153 ;
}
+(CGFloat)cellMoreHeight:(NSDictionary *)dic{
    NSArray * commentArray =  dic[@"answer"];
    
    NSString * titleText = [[NSString stringWithFormat:@"%@%@",dic[@"question"],dic[@"index"]] UnicodeToUtf8];
    CGFloat height_size = [ShareManager inTextOutHeight:titleText lineSpace:9 fontSize:14];
    CGFloat height_QuestionTitle = [ShareManager inTextOutHeight:[dic[@"title"] UnicodeToUtf8] lineSpace:9 fontSize:14];
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
        plHeight = [ShareManager inTextZhiNanOutHeight:connectStr lineSpace:9 fontSize:13];
    }

    
    CGFloat lastHeight =
    (showPlAllLbl ? 25 : 0) +
    height_QuestionTitle +
    plHeight +
    height_size +
    imageHeight;
    return lastHeight + 183 ;
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

    
    
    //查看所有多少评论
    self.plAllHeight.constant = showPlAllLbl ? 25 : 0;
    NSString * allPlCountString = [NSString stringWithFormat:@"查看全部%@评论",comment_number];
    allPlCountString = self.plAllHeight.constant == 0 ? @"" : allPlCountString;
    [self.searchBtn setTitle:allPlCountString forState:UIControlStateNormal];
    

    self.plLbl.text = connectStr;
    
    //评论高度
    self.pl1Height.constant = [ShareManager inTextZhiNanOutHeight:self.plLbl.text lineSpace:9 fontSize:13];

    
    NSString * name1 = @"";
    NSString * name2 = @"";
    if ([connectStr contains:@"\n"]) {
        name1 = [[connectStr split:@"\n"][0] split:@":"][0];
        name2 = [[connectStr split:@"\n"][1] split:@":"][0];
        [self messageAction:self.plLbl changeString:name1 andMarkFondSize:14];
        [self messageAction:self.plLbl changeString:name2 andMarkFondSize:14];
    }else{
        name1 = [connectStr split:@":"][0];
        [self messageAction:self.plLbl changeString:name1 andMarkFondSize:14];
    }
    
    NSString * titleText = [[NSString stringWithFormat:@"%@%@",dic[@"question"],dic[@"index"]] UnicodeToUtf8];
    kWeakSelf(self);
    self.titleTagLbl2.userInteractionEnabled = YES;
    //文本点击回调
    self.titleTagLbl2.tapBlock = ^(NSString *string) {
        NSLog(@" -- %@ --",string);
        weakself.clickTagblock(string);
    };
    NSArray * indexArray = [dic[@"index"] split:@" "];
    NSMutableArray * modelArray = [NSMutableArray array];
    for (NSString * string in indexArray) {
        //设置需要点击的字符串，并配置此字符串的样式及位置
        IXAttributeModel    * model = [IXAttributeModel new];
        model.range = [titleText rangeOfString:string];
        model.string = string;
        model.attributeDic = @{NSForegroundColorAttributeName : [UIColor blueColor]};
        [modelArray addObject:model];
    }
    //label内容赋值
    [self.titleTagLbl2 setText:titleText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
               tapStringArray:modelArray];
    self.textHeight.constant = [self getLblHeight:dic];
    if (self.textHeight.constant < 30) {
        [ShareManager setLineSpace:0 withText:[self.titleTagLbl2.text UnicodeToUtf8] inLabel:self.titleTagLbl2 tag:dic[@"index"]];

    }else{
        [ShareManager setLineSpace:9 withText:[self.titleTagLbl2.text UnicodeToUtf8] inLabel:self.titleTagLbl2 tag:dic[@"index"]];
    }
    
    self.titleTagLbl1.text = [dic[@"title"] UnicodeToUtf8];
    [ShareManager setLineSpace:9 withText:[self.titleTagLbl1.text UnicodeToUtf8] inLabel:self.titleTagLbl1 tag:@""];
    self.questionTitleHeight.constant = [ShareManager inTextOutHeight:self.titleTagLbl1.text lineSpace:9 fontSize:14];
    
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

}
- (void)messageAction:(UILabel *)theLab changeString:(NSString *)change andMarkFondSize:(float)fontSize {
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    
    
    NSString *string1=tempStr;
    NSString *string2=change;
    
    NSArray *array=[string1 componentsSeparatedByString:string2];
    NSMutableArray *arrayOfLocation=[NSMutableArray new];
    int d=0;
    for (int i=0; i<array.count-1; i++) {
        NSString *string=array[i];
        NSNumber *number=[NSNumber numberWithInt:d+=string.length];
        d+=string2.length;
        [arrayOfLocation addObject:number];
    }
    for (int i=0; i<arrayOfLocation.count; i++) {
        NSRange  markRange  = NSMakeRange([arrayOfLocation[i] integerValue], change.length);
        [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiTC-Medium" size:fontSize] range:markRange];
        theLab.attributedText = strAtt;
    }

}


-(CGFloat)getLblHeight:(NSDictionary *)dic{
    NSString * titleText = [NSString stringWithFormat:@"%@%@",dic[@"question"],dic[@"index"]];
    return [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
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
