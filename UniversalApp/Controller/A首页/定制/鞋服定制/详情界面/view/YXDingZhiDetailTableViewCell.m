//
//  YXDingZhiDetailTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiDetailTableViewCell.h"
#import "SDWeiXinPhotoContainerView.h"

#define cellSpace 9
@interface YXDingZhiDetailTableViewCell()
@property (strong, nonatomic) SDWeiXinPhotoContainerView *picContainerView;
@end
@implementation YXDingZhiDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic{
    CGFloat detailHeight = [YXDingZhiDetailTableViewCell jisuanContentHeight:dic];
    CGFloat imgHeight = [YXDingZhiDetailTableViewCell jisuanImageHeight:dic];
    CGFloat imgToTopHeight = imgHeight == 0 ? 0 : 16;
    CGFloat gudingHeight = 15 + 36 + 10 + detailHeight + imgToTopHeight + imgHeight + 13 +  15 + 14 ;
    return  gudingHeight;
}
//计算文字高度
+(CGFloat)jisuanContentHeight:(NSDictionary *)dic{
    NSString * contentText = dic[@"comment"];
    return [ShareManager inAllContentOutHeight:contentText contentWidth:KScreenWidth-32 lineSpace:cellSpace font:SYSTEMFONT(15)];
}
//计算图片高度
+(CGFloat)jisuanImageHeight:(NSDictionary *)dic{
    return [dic[@"photo_list"] stringValue].length == 0 ? 0 : (KScreenWidth-32-5)/3;
}
-(void)setCellData:(NSDictionary *)dic{
    self.cellContent.text = dic[@"comment"];
    [ShareManager setAllContentAttributed:cellSpace inLabel:self.cellContent font:SYSTEMFONT(15)];
    self.contentDetailHeight.constant = [YXDingZhiDetailTableViewCell jisuanContentHeight:dic];
    
    //如果图片数组为0，那么图片view的高度和top高度都为0

    if ([dic[@"photo_list"] stringValue].length == 0) {
        self.picContainerView.frame = CGRectMake(0, 0, 0,0);
        [self.picContainerView removeFromSuperview];
        
        
        self.cellMiddleViewToTopHeight.constant = self.cellMiddleViewHeight.constant = 0;
    }else{
        NSArray * photoList = [dic[@"photo_list"] split:@","];
        NSMutableArray * urlPhotoList = [NSMutableArray array];
        for (NSString * urlString in photoList) {
            [urlPhotoList addObject:[IMG_URI append:urlString]];
        }
        
        [self.cellMiddleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.starView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        
        self.cellMiddleViewToTopHeight.constant = 16;
        self.cellMiddleViewHeight.constant = [YXDingZhiDetailTableViewCell jisuanImageHeight:dic];
        self.picContainerView = [SDWeiXinPhotoContainerView new];
        self.picContainerView.frame = CGRectMake(0, 0, KScreenWidth - 32,[YXDingZhiDetailTableViewCell jisuanImageHeight:dic]);
        self.picContainerView.picPathStringsArray = urlPhotoList;
        [self.cellMiddleView addSubview:self.picContainerView];
    }
    //头图片
    NSString * url = [IMG_URI append:dic[@"user_info"][@"photo"]];
    [self.cellImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    //名称
    self.cellTitle.text = dic[@"user_info"][@"username"];
    //时间
    self.cellTime.text = [ShareManager updateTimeForRow:[dic[@"publish_time"] longLongValue]];
    //评分
    [self.starView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [ShareManager fiveStarView:[dic[@"grade"] qmui_CGFloatValue] view:self.starView];
    //赞
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? [UIImage imageNamed:@"F蓝色已点赞"] : [UIImage imageNamed:@"F灰色未点赞"];
    [self.zanBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)zanAction:(id)sender {
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    self.zanblock(self.zanBtn.tag);
}
- (IBAction)talkAction:(id)sender {
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    self.talkblock(self.zanBtn.tag);
}
@end
