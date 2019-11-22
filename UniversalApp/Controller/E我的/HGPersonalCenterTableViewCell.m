//
//  HGPersonalCenterTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/18.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "HGPersonalCenterTableViewCell.h"
#define cellSpace 6
#define cellVideoHeight 180
@implementation HGPersonalCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

  
}
//计算cell总高度
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic{
    //文字高度
    CGFloat  contentTextHeight = [HGPersonalCenterTableViewCell jisuanContentHeight:dic];
    //标签高度
    CGFloat tagViewHeight = [HGPersonalCenterTableViewCell cellTagViewHeight:dic];
    //中间高度
    CGFloat midViewHeight = [HGPersonalCenterTableViewCell cellAllImageHeight:dic];
    //如果没有标签，
    CGFloat tagViewToTopSpaceHeight = [HGPersonalCenterTableViewCell cellTagViewToTopSpaceHeight:dic];
    
    return 63 + contentTextHeight + tagViewHeight + midViewHeight + tagViewToTopSpaceHeight;
}
//计算标签离上部的距离
+(CGFloat)cellTagViewToTopSpaceHeight:(NSDictionary *)dic{
    return 10;//[dic[@"tag"] length] < 2 ? 0 : 10;
}

//计算文字高度
+(CGFloat)jisuanContentHeight:(NSDictionary *)dic{
    NSString * contentText = @"";
    if ([dic[@"obj"] integerValue] == 1) {
        contentText = dic[@"detail"];
        return [ShareManager inAllContentOutHeight:contentText contentWidth:KScreenWidth-90 lineSpace:cellSpace font:SYSTEMFONT(16)];
    }else{
        contentText = [@"占位" append: dic[@"title"]];
        return [ShareManager inAllContentOutHeight:contentText contentWidth:KScreenWidth-90 lineSpace:cellSpace font:BOLDSYSTEMFONT(18)];
    }

}
//计算标签高度
+(CGFloat)cellTagViewHeight:(NSDictionary *)dic{
    if ([dic[@"tag_list"] count] == 0) {return 0;}
    if ([dic[@"tag_list"][0] length] ==0) { return 0;}
    CBGroupAndStreamView * cb = [[CBGroupAndStreamView alloc] init];
    cb.hidden = YES;cb.frame = CGRectMake(0, 0, KScreenWidth-90, 0);
    cb.isSingle = YES;cb.radius = 4;cb.butHeight = 30;cb.font = [UIFont systemFontOfSize:12];
    cb.titleTextFont = [UIFont systemFontOfSize:12];
    NSMutableArray * contentArr = [[NSMutableArray alloc]init];
    for (NSString * str in dic[@"tag_list"]) {[contentArr addObject:[@"#" append:str]];}
    [cb setContentView:@[contentArr] titleArr:@[@""]];
    return  cb.allViewHeight;
}
//计算图片高度
+(CGFloat)cellAllImageHeight:(NSDictionary *)dic{
    CGFloat midViewHeight = 0;
    NSArray * urlList = dic[@"url_list"];
    if ([dic[@"obj"] integerValue] == 1) {
        if ([kGetString(urlList[0]) containsString:@"mp4"]) {
            midViewHeight = cellVideoHeight;
        }else{
          CGFloat oneH =  (KScreenWidth - 90 - 10 ) / 2 ;
          if (urlList.count == 1 || urlList.count == 2) {
              midViewHeight = oneH;
          }else{
              midViewHeight = oneH * 2 + 10;
          }
        }
    }else{
        midViewHeight = cellVideoHeight;
    }
    return midViewHeight;
}
- (IBAction)fenxiangAction:(UIButton *)sender {
    self.clickDetailblock(sender.tag,self.tag);
}

- (IBAction)pinglunAction:(UIButton * )sender {
    self.clickDetailblock(sender.tag,self.tag);
}

- (IBAction)dianzanAction:(UIButton *)sender {
    self.clickDetailblock(sender.tag,self.tag);
}
-(void)setCellData:(NSDictionary *)dic{
//标签
       if ([dic[@"tag"] length] > 2) {
           [self addNewTags:dic];
           self.cellTagViewToTopSpaceHeight.constant = 10;
       }else{
           [self.cellTagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
           self.cellTagViewHeight.constant = 0 ;
           self.cellTagViewToTopSpaceHeight.constant = 10;
       }
//中间midview高度
    self.cellMidViewHeight.constant = [HGPersonalCenterTableViewCell cellAllImageHeight:dic];
    self.cellContentLblHeight.constant = [HGPersonalCenterTableViewCell jisuanContentHeight:dic];
//图片
       if ([dic[@"obj"] integerValue] == 1) {
           self.cellContentLbl.text = [NSString stringWithFormat:@"%@",dic[@"detail"]];
           NSArray * urlList = dic[@"url_list"];
           //这里判断晒图是图还是视频
           if ([kGetString(urlList[0]) containsString:@"mp4"]) {
               self.picContainerView.frame = CGRectMake(0, 0, 0,0);
               [self.picContainerView removeFromSuperview];
               self.coverImv.hidden = self.playImv.hidden = NO;
               self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
               self.coverImv.tag = self.tag;
               self.coverImv.userInteractionEnabled = YES;
               [self.coverImv addGestureRecognizer:self.tap];
               NSString * string = [(NSMutableString *)dic[@"cover"] replaceAll:@" " target:@"%20"];
               [self.coverImv sd_setImageWithURL:[NSURL URLWithString:[WP_TOOL_ShareManager addImgURL:string]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
           }else{
                 [self.picContainerView removeFromSuperview];
                 self.coverImv.hidden = self.playImv.hidden = YES;
                 self.picContainerView = [SDWeiXinPhotoContainerView new];
                 self.picContainerView.sdWidth = KScreenWidth - 90 - 10 ;
                 self.picContainerView.frame = CGRectMake(0, 0, self.cellMidView.qmui_width,
                                                        self.cellMidView.qmui_height);
                 self.picContainerView.rowCount = 2;
                 [self.cellMidView addSubview:self.picContainerView];
                 NSMutableArray * newUrlList = [[NSMutableArray alloc]init];
                 if (urlList.count > 4) {
                    [newUrlList addObject:urlList[0]];
                    [newUrlList addObject:urlList[1]];
                    [newUrlList addObject:urlList[2]];
                    [newUrlList addObject:urlList[3]];
                 }else{
                     [newUrlList addObjectsFromArray:urlList];
                 }
                 self.picContainerView.picPathStringsArray = newUrlList;
           }
           //下边这句话不能删除，改变样式的
           [ShareManager setAllContentAttributed:cellSpace inLabel:self.cellContentLbl font:SYSTEMFONT(16)];
           if ([dic[@"detail"] isEqualToString:@""]) {self.cellContentLblHeight.constant = 0;}
       }else{
//文章
           self.picContainerView.frame = CGRectMake(0, 0, 0,0);
           [self.picContainerView removeFromSuperview];
           self.coverImv.hidden = NO;
           self.playImv.hidden = YES;
           NSString * string = [(NSMutableString *)dic[@"cover"] replaceAll:@" " target:@"%20"];
           [self.coverImv sd_setImageWithURL:[NSURL URLWithString:[WP_TOOL_ShareManager addImgURL:string]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
           self.cellMidView.userInteractionEnabled = NO;
           self.cellMidViewHeight.constant = cellVideoHeight;
           
          [ShareManager setAllContentAttributed:cellSpace inLabel:self.cellContentLbl font:BOLDSYSTEMFONT(18)];
           self.cellContentLbl.font =  BOLDSYSTEMFONT(18);
           self.cellContentLbl.textColor = kRGBA(176, 151, 99, 1);
          self.cellContentLbl.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
          NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self.cellContentLbl.text];
          NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
          attchImage.image = [UIImage imageNamed:@"faxianshu"];
          attchImage.bounds = CGRectMake(0, -2, 20, 16);
          NSMutableAttributedString * attriStr1 = [[NSMutableAttributedString alloc] initWithString:@"  "];
          NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
          [attriStr insertAttributedString:stringImage atIndex:0];
          [attriStr insertAttributedString:attriStr1 atIndex:1];
          self.cellContentLbl.attributedText = attriStr;
       
       
 
       
        }
    
    
    
    
    
//    self.cellContentLbl.textAlignment = NSTextAlignmentJustified;

    
    //年月日
          NSArray * riqiArray = [[self timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@"YYYY-MM:dd"] split:@":"];
          if (riqiArray.count > 0) {self.cellRiQiLbl.text = riqiArray[0];}
          if (riqiArray.count > 1) {self.cellDayLbl.text  = riqiArray[1];}
    //赞和评论 评论数量
           NSString * talkNum =  kGetString(dic[@"comment_number"]);
           NSString * praisNum = kGetString(dic[@"praise_number"]);
           self.cellPingLunLbl.text = talkNum;
           self.cellDianzanLbl.text = praisNum;
           if ([talkNum isEqualToString:@"0"] || [talkNum isEqualToString:@"(null)"]) {self.cellPingLunLbl.text = @"";}
           if ([praisNum isEqualToString:@"0"] || [praisNum isEqualToString:@"(null)"]) { self.cellDianzanLbl.text = @"";}
    //赞数和评论数
           BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
           UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
           [self.zanBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
}
-(void)addNewTags:(NSDictionary *)dic{
    [self.cellTagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.cellTagViewHeight.constant = [HGPersonalCenterTableViewCell cellTagViewHeight:dic];
    _cbGroupAndStreamView = [[CBGroupAndStreamView alloc] initWithFrame:
                             CGRectMake(-10, 0,KScreenWidth-90, self.cellTagViewHeight.constant)];
    [self.cellTagView addSubview:_cbGroupAndStreamView];
    NSMutableArray * contentArr = [[NSMutableArray alloc]init];
    for (NSString * str in dic[@"tag_list"]) {
        [contentArr addObject:[@"#" append:str]];
    }
    _cbGroupAndStreamView.backgroundColor = KClearColor;
    _cbGroupAndStreamView.isSingle = YES;
    _cbGroupAndStreamView.radius = 4;
    _cbGroupAndStreamView.butHeight = 32;
    _cbGroupAndStreamView.font = [UIFont systemFontOfSize:14];
    _cbGroupAndStreamView.titleTextFont = [UIFont systemFontOfSize:14];
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
-(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;

}
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    self.playBlock(tapGesture);
}
@end
