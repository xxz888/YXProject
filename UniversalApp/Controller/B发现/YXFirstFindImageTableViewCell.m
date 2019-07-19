//
//  YXFirstFindImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXFirstFindImageTableViewCell.h"
#import "UIImage+ImgSize.h"

@interface YXFirstFindImageTableViewCell()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) UITapGestureRecognizer *tap;

@end

@implementation YXFirstFindImageTableViewCell

+(CGFloat)cellDefaultHeight:(NSDictionary *)dic{
    NSString * titleText = @"";
    //计算图片高度
    CGFloat midViewHeight = 0;
    CGFloat detailHeight = 0;

    //计算detail高度
    if([dic[@"obj"] integerValue] == 1){
        titleText = [[NSString stringWithFormat:@"%@%@",dic[@"detail"],dic[@"tag"]] UnicodeToUtf8];
        midViewHeight = KScreenWidth-20;

        //这里判断晒图是图还是视频
            if ([kGetString(dic[@"url_list"][0]) containsString:@"mp4"]) {
            midViewHeight = 220;
        }
        if ([dic[@"detail"] isEqualToString:@""] && [dic[@"tag"] isEqualToString:@""]) {
            detailHeight = 0;
        }else{
            detailHeight = [ShareManager inTextOutHeight:titleText lineSpace:9 fontSize:15];
            
        }
        
    }else{
        titleText = [[NSString stringWithFormat:@"%@%@",dic[@"title"],dic[@"tag"]] UnicodeToUtf8];
        midViewHeight = 220;
        if ([dic[@"title"] isEqualToString:@""] && [dic[@"tag"] isEqualToString:@""]) {
            detailHeight = 0;
        }else{
            detailHeight = [ShareManager inTextOutHeight:titleText lineSpace:9 fontSize:15];
            
        }
    }

   
    return 125 + detailHeight + midViewHeight;
}
-(void)setCellValue:(NSDictionary *)dic{
    kWeakSelf(self);
    //头像
    NSString * str1 = [(NSMutableString *)dic[@"photo"] replaceAll:@" " target:@"%20"];
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
    //头名字
    self.titleLbl.text = dic[@"user_name"];
    //头时间
    self.timeLbl.text = [ShareManager updateTimeForRow:[dic[@"publish_time"] longLongValue]];
    //地点button
    [self.mapBtn setTitle:dic[@"publish_site"] forState:UIControlStateNormal];
    //detail
    NSString * titleText = @"";
    if ([dic[@"obj"] integerValue] == 1) {
        titleText = [[NSString stringWithFormat:@"%@%@",dic[@"detail"],dic[@"tag"]] UnicodeToUtf8];
    }else{
        titleText = [[NSString stringWithFormat:@"%@%@",dic[@"title"],dic[@"tag"]] UnicodeToUtf8];
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
    
    
    
    NSArray * indexArray = [dic[@"tag"] split:@" "];
    NSMutableArray * modelArray = [NSMutableArray array];
    for (NSString * string in indexArray) {
        //设置需要点击的字符串，并配置此字符串的样式及位置
        IXAttributeModel    * model = [IXAttributeModel new];
        model.range = [titleText rangeOfString:string];
        model.string = string;
        model.attributeDic = @{NSForegroundColorAttributeName : YXRGBAColor(10, 96, 254),
                               NSFontAttributeName:[UIFont fontWithName:@"苹方-简" size:15]};
        [modelArray addObject:model];
    }
    //文本点击回调
    self.detailLbl.tapBlock = ^(NSString *string) {
        weakself.clickTagblock(string);
    };
    //label内容赋值
    [self.detailLbl setText:titleText
                 attributes:@{NSForegroundColorAttributeName : YXRGBAColor(10, 96, 254),
                              NSFontAttributeName:[UIFont fontWithName:@"苹方-简" size:15],}
               tapStringArray:modelArray];

    //图片
    if ([dic[@"obj"] integerValue] == 1) {
        NSArray * urlList = dic[@"url_list"];
        self.countLbl.text = NSIntegerToNSString(urlList.count);
        //如果只是图片，并且为4张
        if ([urlList count] >= 4) {
            self.midViewHeight.constant = kScreenWidth - 20;;
            self.onlyOneImv.hidden = YES;
            self.imgV1.hidden = self.imgV2.hidden = self.imgV3.hidden = self.imgV4.hidden = self.stackView.hidden = NO;
            NSString * string1 = [(NSMutableString *)urlList[0] replaceAll:@" " target:@"%20"];
            [self.imgV1 sd_setImageWithURL:[NSURL URLWithString:string1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
            NSString * string2 = [(NSMutableString *)urlList[1] replaceAll:@" " target:@"%20"];
            [self.imgV2 sd_setImageWithURL:[NSURL URLWithString:string2] placeholderImage:[UIImage imageNamed:@"img_moren"]];
            NSString * string3 = [(NSMutableString *)urlList[2] replaceAll:@" " target:@"%20"];
            [self.imgV3 sd_setImageWithURL:[NSURL URLWithString:string3] placeholderImage:[UIImage imageNamed:@"img_moren"]];
            NSString * string4 = [(NSMutableString *)urlList[3] replaceAll:@" " target:@"%20"];
            [self.imgV4 sd_setImageWithURL:[NSURL URLWithString:string4] placeholderImage:[UIImage imageNamed:@"img_moren"]];
            
  
            
        }else{
        //如果只是图片，并且在4张以下
            self.imgV1.hidden = self.imgV2.hidden = self.imgV3.hidden = self.imgV4.hidden = self.stackView.hidden = YES;
            self.onlyOneImv.hidden = NO;
            //这里判断晒图是图还是视频
            if ([kGetString(urlList[0]) containsString:@"mp4"]) {
                //给视频的imageveiew添加手势，这个方法一定要写晒图所有方法后边的，不能移动顺序
                self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
                self.onlyOneImv.tag = self.tag;
                [self.onlyOneImv addGestureRecognizer:self.tap];
                NSString * string = [(NSMutableString *)dic[@"cover"] replaceAll:@" " target:@"%20"];
                [self.onlyOneImv sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"img_moren"]];
                //如果是图片，为1张图片，有可能是晒图，有可能视频
                self.midViewHeight.constant = 220;
                //处理view隐藏
                self.playImV.hidden = NO;
            }else{
                NSString * string = [(NSMutableString *)urlList[0] replaceAll:@" " target:@"%20"];
                [self.onlyOneImv sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"img_moren"]];
                //如果是图片，为1张图片
                self.midViewHeight.constant = kScreenWidth - 20;
                //处理view隐藏
                self.playImV.hidden = YES;
                [self.onlyOneImv removeGestureRecognizer:self.tap];
            }
        }
        self.detailLbl.font =  [UIFont fontWithName:@"苹方-简" size:15];
        //下边这句话不能删除，改变样式的
        [ShareManager setLineSpace:9 inLabel:self.detailLbl size:15];
        [ShareManager inTextViewOutDifColorView:self.detailLbl tag:dic[@"tag"]];
        self.detailHeight.constant = [ShareManager inTextOutHeight:self.detailLbl.text  lineSpace:9 fontSize:15];
        if ([dic[@"detail"] isEqualToString:@""] && [dic[@"tag"] isEqualToString:@""]) {
            self.detailHeight.constant = 0;
        }
    }else{
    //文章
        self.midViewHeight.constant = 220;
        self.onlyOneImv.hidden = NO;
        self.imgV1.hidden = self.imgV2.hidden = self.imgV3.hidden = self.imgV4.hidden = self.stackView.hidden = self.playImV.hidden =YES;
        NSString * string = [(NSMutableString *)dic[@"cover"] replaceAll:@" " target:@"%20"];
        [self.onlyOneImv sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        [self.onlyOneImv removeGestureRecognizer:self.tap];
        //下边这句话不能删除，改变样式的
        [ShareManager setLineSpace:9 inLabel:self.detailLbl size:17];
        [ShareManager inTextViewOutDifColorView:self.detailLbl tag:dic[@"tag"]];
        self.detailLbl.font =  [UIFont fontWithName:@"Helvetica-Bold" size:17];
        self.detailHeight.constant = [ShareManager inTextOutHeight:self.detailLbl.text  lineSpace:9 fontSize:17];
        
        if ([dic[@"title"] isEqualToString:@""] && [dic[@"tag"] isEqualToString:@""]) {
            self.detailHeight.constant = 0;
        }
    }
    
    
    
   
    [self.detailLbl setOrgVerticalTextAlignment:OrgHLVerticalTextAlignmentMiddle];

    if ([dic[@"publish_site"] isEqualToString:@""] || !dic[@"publish_site"] ) {
        self.nameCenter.constant = self.titleImageView.frame.origin.y;
    }else{
        self.nameCenter.constant = 0;
    }
}
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    self.playBlock(tapGesture);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleImageView.layer.masksToBounds = YES;
    self.titleImageView.layer.cornerRadius = self.titleImageView.frame.size.width / 2.0;
    
    ViewRadius(self.rightCountLbl, 5);

    
    ViewRadius(self.imgV1, 5);
    ViewRadius(self.imgV2, 5);
    ViewRadius(self.imgV3, 5);
    ViewRadius(self.imgV4, 5);

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

    //添加轮播图
- (void)setUpSycleScrollView:(NSArray *)photoArray height:(CGFloat)height{
    self.onlyOneImv.hidden = self.imgV1.hidden = self.imgV2.hidden = self.imgV3.hidden = self.imgV4.hidden = self.stackView.hidden = YES;
    
    self.rightCountLbl.hidden = self.midLunBoView.hidden = NO;
    [_cycleScrollView3 removeFromSuperview];
    _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth-20, 0) shouldInfiniteLoop:NO imageNamesGroup:@[]];
    _cycleScrollView3.delegate = self;
//    [self.midLunBoView addSubview:_cycleScrollView3];
    [self.midLunBoView insertSubview:_cycleScrollView3 belowSubview:self.rightCountLbl];
    self.rightCountLbl.hidden = height == 0 ;
    _tatolCount = photoArray.count;
    _cycleScrollView3.frame = CGRectMake(0, 0, kScreenWidth-20, height);
    _cycleScrollView3.delegate = self;
//    _cycleScrollView3.bannerImageViewContentMode = 1;
    _cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
    _cycleScrollView3.currentPageDotColor =  SEGMENT_COLOR;
    _cycleScrollView3.showPageControl = YES;
    _cycleScrollView3.autoScrollTimeInterval = 10000;
    _cycleScrollView3.pageDotColor = YXRGBAColor(239, 239, 239);
    _cycleScrollView3.backgroundColor = KWhiteColor;
    
    
    self.rightCountLbl.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
    self.rightCountLbl.textColor = KWhiteColor;
}
    
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.rightCountLbl.text = [NSString stringWithFormat:@"%ld/%ld",index+1,(long)_tatolCount];
    
}



@end
