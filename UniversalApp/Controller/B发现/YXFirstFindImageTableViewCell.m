//
//  YXFirstFindImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXFirstFindImageTableViewCell.h"
#import "UIImage+ImgSize.h"
#import "SDWeiXinPhotoContainerView.h"
#import "CBGroupAndStreamView.h"

@interface YXFirstFindImageTableViewCell()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (strong, nonatomic) SDWeiXinPhotoContainerView *picContainerView;
@property (strong, nonatomic) CBGroupAndStreamView * cbGroupAndStreamView;

@end

@implementation YXFirstFindImageTableViewCell

+(CGFloat)cellDefaultHeight:(NSDictionary *)dic{
    NSString * titleText = @"";
    //计算图片高度
    CGFloat midViewHeight = 0;
    CGFloat detailHeight = 0;
    NSArray * urlList = dic[@"url_list"];

    //计算detail高度
    if([dic[@"obj"] integerValue] == 1){
        titleText = [NSString stringWithFormat:@"%@",dic[@"detail"]];
        midViewHeight = KScreenWidth-20;
        if ([dic[@"detail"] isEqualToString:@""]) {
                     detailHeight = 0;
                 }else{
                     detailHeight = [ShareManager inTextOutHeight:titleText lineSpace:9 fontSize:15];
                 }
        //这里判断晒图是图还是视频
        if ([kGetString(dic[@"url_list"][0]) containsString:@"mp4"]) {
            midViewHeight = 220;
        }else{
         
            midViewHeight = [YXFirstFindImageTableViewCell inArrayCountOutHeight:urlList.count];
        }
     
        
    }else{
        titleText = [NSString stringWithFormat:@"%@",dic[@"title"]];
        midViewHeight = 220;
        if ([dic[@"title"] isEqualToString:@""]) {
            detailHeight = 0;
        }else{
            detailHeight = [ShareManager inTextBlodOutHeight:titleText lineSpace:9 fontSize:18];
            
        }
    }

   
    return 128 + detailHeight + midViewHeight + [YXFirstFindImageTableViewCell allViewHeight:dic];
}
+(CGFloat)allViewHeight:(NSDictionary *)dic{
    if ([dic[@"tag_list"] count] == 0) {
        return 0;
    }
    if ([dic[@"tag_list"][0] length] ==0) {
        return 0;
    }
    CBGroupAndStreamView * cb = [[CBGroupAndStreamView alloc] init];
    cb.hidden = YES;
    cb.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    cb.isSingle = YES;
    cb.radius = 4;
    cb.butHeight = 30;
    cb.font = [UIFont systemFontOfSize:12];
    cb.titleTextFont = [UIFont systemFontOfSize:12];
    [kAppWindow addSubview:cb];
    NSMutableArray * contentArr = [[NSMutableArray alloc]init];
      for (NSString * str in dic[@"tag_list"]) {
          [contentArr addObject:[@"#" append:str]];
      }
    [cb setContentView:@[contentArr] titleArr:@[@""]];
    return  cb.allViewHeight;
}
+(CGFloat)inArrayCountOutHeight:(NSInteger)count{
    CGFloat h = 0;
    if (count == 1) {
        h = 200;
    }else{
        
        CGFloat oneH =  (KScreenWidth - 30 )/ 3 ;
        if (count > 3 && count <= 6) {
            h = oneH * 2;
        }else if (count > 6){
            h = oneH * 3 + 10;
        }else{
            h = oneH;
        }
    }
    return h;
}
-(void)setup{
    self.picContainerView = [SDWeiXinPhotoContainerView new];
    [self.midView addSubview:self.picContainerView];
}
-(void)setCellValue:(NSDictionary *)dic{
    kWeakSelf(self);
    //头像
    NSString * str1 = [(NSMutableString *)dic[@"photo"] replaceAll:@" " target:@"%20"];
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:str1]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
    //头名字
    self.titleLbl.text = dic[@"user_name"];
    //头时间
    self.timeLbl.text = [ShareManager updateTimeForRow:[dic[@"publish_time"] longLongValue]];
    //地点button
    [self.mapBtn setTitle:dic[@"publish_site"] forState:UIControlStateNormal];
    //detail
    NSString * titleText = @"";
    if ([dic[@"obj"] integerValue] == 1) {
        titleText = [NSString stringWithFormat:@"%@",dic[@"detail"]];
    }else{
        titleText = [NSString stringWithFormat:@"%@",dic[@"title"]];
    }
    //赞和评论
    NSString * talkNum =  kGetString(dic[@"comment_number"]);
    NSString * praisNum = kGetString(dic[@"praise_number"]);
    //评论数量
    self.talkCount.text = talkNum;
    self.zanCount.text = praisNum;
    
    if ([talkNum isEqualToString:@"0"] || [talkNum isEqualToString:@"(null)"]) {
        self.talkCount.text = @"";
    }
    if ([praisNum isEqualToString:@"0"] || [praisNum isEqualToString:@"(null)"]) {
        self.zanCount.text = @"";
    }
    
    //赞
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [self.zanBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    if ([dic[@"tag_list"] count] != 0 && [dic[@"tag_list"][0] length]!=0) {
          [self addNewTags:dic];
    }else{
        [self.tagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.tagViewHeight.constant = 0 ;
    }
    self.detailLbl.text = titleText;
    //图片
    if ([dic[@"obj"] integerValue] == 1) {
        NSArray * urlList = dic[@"url_list"];
        //如果只是图片，并且为4张
            //这里判断晒图是图还是视频
            if ([kGetString(urlList[0]) containsString:@"mp4"]) {
                self.onlyOneImv.hidden = NO;
                self.picContainerView.hidden = YES;

                //给视频的imageveiew添加手势，这个方法一定要写晒图所有方法后边的，不能移动顺序
                self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
                self.onlyOneImv.tag = self.tag;
                self.onlyOneImv.userInteractionEnabled = YES;

                [self.onlyOneImv addGestureRecognizer:self.tap];

                NSString * string = [(NSMutableString *)dic[@"cover"] replaceAll:@" " target:@"%20"];
                [self.onlyOneImv sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"img_moren"]];
                //如果是图片，为1张图片，有可能是晒图，有可能视频
                self.midViewHeight.constant = 220;
                //处理view隐藏
                self.playImV.hidden = NO;

            }else{
                self.onlyOneImv.hidden = YES;
                self.picContainerView.hidden = NO;
                self.midViewHeight.constant = [YXFirstFindImageTableViewCell inArrayCountOutHeight:urlList.count];
                self.picContainerView.picPathStringsArray = dic[@"url_list"];
                //处理view隐藏
                self.playImV.hidden = YES;
            }
        //下边这句话不能删除，改变样式的
        [ShareManager setLineSpace:9 inLabel:self.detailLbl size:15];
        self.detailHeight.constant = [ShareManager inTextOutHeight:self.detailLbl.text  lineSpace:9 fontSize:15];
        if ([dic[@"detail"] isEqualToString:@""]) {self.detailHeight.constant = 0;}
    }else{
    //文章
        self.midViewHeight.constant = 220;
        self.onlyOneImv.hidden = NO;
        self.playImV.hidden =YES;
        self.picContainerView.hidden = YES;
        NSString * string = [(NSMutableString *)dic[@"cover"] replaceAll:@" " target:@"%20"];
        if (![string contains:IMG_URI]) {
            string = [IMG_URI append:string];
        }
        [self.onlyOneImv sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        self.onlyOneImv.userInteractionEnabled = NO;
        //下边这句话不能删除，改变样式的
        
        
 
        
        
        [ShareManager setLineSpace:9 inLabel:self.detailLbl size:18];
        self.detailLbl.font =  [UIFont fontWithName:@"Helvetica-Bold" size:18];
        self.detailHeight.constant = [ShareManager inTextBlodOutHeight:self.detailLbl.text  lineSpace:9 fontSize:18];
        
         NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self.detailLbl.text];
         NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
         attchImage.image = [UIImage imageNamed:@"faxianshu"];
         attchImage.bounds = CGRectMake(0, -2, 20, 16);
         NSMutableAttributedString * attriStr1 = [[NSMutableAttributedString alloc] initWithString:@"  "];

         NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
         [attriStr insertAttributedString:stringImage atIndex:0];
         [attriStr insertAttributedString:attriStr1 atIndex:1];

         self.detailLbl.attributedText = attriStr;
        
        if ([dic[@"title"] isEqualToString:@""]) {
            self.detailHeight.constant = 0;
        }
    }
    if ([dic[@"publish_site"] isEqualToString:@""] || !dic[@"publish_site"] ) {
        self.nameCenter.constant = self.titleImageView.frame.origin.y;
    }else{
        self.nameCenter.constant = 0;
    }
}
-(void)addNewTags:(NSDictionary *)dic{
    [self.tagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.tagViewHeight.constant = [YXFirstFindImageTableViewCell allViewHeight:dic];
    _cbGroupAndStreamView = [[CBGroupAndStreamView alloc] initWithFrame:CGRectMake(0, 0,self.tagView.qmui_width, [YXFirstFindImageTableViewCell allViewHeight:dic])];
    [self.tagView addSubview:_cbGroupAndStreamView];
    NSMutableArray * contentArr = [[NSMutableArray alloc]init];
    for (NSString * str in dic[@"tag_list"]) {
        [contentArr addObject:[@"#" append:str]];
    }
    _cbGroupAndStreamView.backgroundColor = KClearColor;
    _cbGroupAndStreamView.isSingle = YES;
    _cbGroupAndStreamView.radius = 4;
    _cbGroupAndStreamView.butHeight = 28;
    _cbGroupAndStreamView.font = [UIFont systemFontOfSize:12];
    _cbGroupAndStreamView.titleTextFont = [UIFont systemFontOfSize:12];
    _cbGroupAndStreamView.scroller.backgroundColor = KClearColor;
    _cbGroupAndStreamView.scroller.scrollEnabled = NO;
    _cbGroupAndStreamView.contentNorColor  = SEGMENT_COLOR;
    _cbGroupAndStreamView.contentSelColor = SEGMENT_COLOR;
    _cbGroupAndStreamView.backClolor = kRGBA(245, 245, 245, 1);
    [_cbGroupAndStreamView setContentView:@[contentArr] titleArr:@[@""]];
    kWeakSelf(self);
    _cbGroupAndStreamView.cb_selectCurrentValueBlock = ^(NSString *value, NSInteger index, NSInteger groupId) {
        weakself.clickTagblock(value);
    };
}
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    self.playBlock(tapGesture);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleImageView.layer.masksToBounds = YES;
    self.titleImageView.layer.cornerRadius = self.titleImageView.frame.size.width / 2.0;
    

    [self setup];

    ViewRadius(self.onlyOneImv, 5);

    //图片这种类型的view默认是没有点击事件的，所以要把用户交互的属性打开
    self.titleImageView.userInteractionEnabled = YES;
    //添加点击手势
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    //点击几次后触发事件响应，默认为：1
    click.numberOfTapsRequired = 1;
    [self.titleImageView addGestureRecognizer:click];
    
    self.detailTextLabel.adjustsFontSizeToFitWidth=YES;
}

-(void)clickAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    self.clickImageBlock(tag);
}
- (IBAction)shareAction:(id)sender {
    self.shareblock(self.tag);
}
- (IBAction)zanTalkAction:(UIButton *)sender {
    self.clickDetailblock(sender.tag,self.tag);
}




- (IBAction)guanzhuAction:(id)sender {
    self.guanZhublock();
}
@end
