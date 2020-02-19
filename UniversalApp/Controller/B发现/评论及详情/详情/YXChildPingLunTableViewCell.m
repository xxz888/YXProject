//
//  YXChildPingLunTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/23.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXChildPingLunTableViewCell.h"
@interface YXChildPingLunTableViewCell()
@property(nonatomic,strong)NSDictionary * cellDataDic;
@end
@implementation YXChildPingLunTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return  self;
}
-(void)setup{
}
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic{
    CGFloat plDetailHeight =   [YXChildPingLunTableViewCell getPlDetailHeight:dic];
    return 16 + 36 + 10 + plDetailHeight  + 16 + 0.5;
}
+(CGFloat)getPlDetailHeight:(NSDictionary *)dic{
    CGFloat height =
    [ShareManager inAllContentOutHeight:dic[@"comment"] contentWidth:KScreenWidth-87 lineSpace:9 font:SYSTEMFONT(14)];
    return height;
}
-(void)setCellShopData:(NSDictionary *)dic{

    NSString * photo = dic[@"user_info"][@"photo"];
    NSString * update_time = dic[@"publish_time"];
    
     [self.plTitleImv sd_setImageWithURL:[NSURL URLWithString:[WP_TOOL_ShareManager addImgURL:photo]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.plUserName.text = dic[@"user_info"][@"username"];
    self.plTime.text = [ShareManager updateTimeForRow:[update_time longLongValue]];
    //F蓝色已点赞 F灰色未点赞
    [self.plZan setImage:[dic[@"is_praise"] integerValue] == 0 ? IMAGE_NAMED(@"F灰色未点赞") : IMAGE_NAMED(@"F蓝色已点赞") forState:0];
    //评论的内容
    self.plDetail.text = dic[@"comment"];
    self.plDetailHeight.constant = [YXChildPingLunTableViewCell getPlDetailHeight:dic];
    //评论的tableview
    [ShareManager setAllContentAttributed:9 inLabel:self.plDetail font:SYSTEMFONT(14)];
}
-(void)setCellData:(NSDictionary *)dic{
    self.cellDataDic =[NSDictionary dictionaryWithDictionary:dic];
    NSString * photo = dic[@"photo"] ? dic[@"photo"] : dic[@"user_photo"];
    NSString * update_time = dic[@"update_time"] ? dic[@"update_time"] : dic[@"publish_time"];

    
     [self.plTitleImv sd_setImageWithURL:[NSURL URLWithString:[WP_TOOL_ShareManager addImgURL:photo]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.plUserName.text = dic[@"user_name"];
    self.plTime.text = [ShareManager updateTimeForRow:[update_time longLongValue]];
    //F蓝色已点赞 F灰色未点赞
    [self.plZan setImage:[dic[@"is_praise"] integerValue] == 0 ? IMAGE_NAMED(@"F灰色未点赞") : IMAGE_NAMED(@"F蓝色已点赞") forState:0];
    //评论的内容
    self.plDetail.text = dic[@"comment"];
    self.plDetailHeight.constant = [YXChildPingLunTableViewCell getPlDetailHeight:dic];
    //评论的tableview
    [ShareManager setAllContentAttributed:9 inLabel:self.plDetail font:SYSTEMFONT(14)];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitleImvAction:)];
    self.plTitleImv.userInteractionEnabled = YES;
//    [self.plTitleImv addGestureRecognizer:aTapGR];
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    longPressGesture.minimumPressDuration=1.0f;//设置长按 时间
//    [self addGestureRecognizer:longPressGesture];
}
-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        self.pressLongChildCellBlock(self.cellDataDic);
    }
}

-(void)tapTitleImvAction:(id)tap{
    self.tagTitleImvCellBlock(kGetString(self.cellDataDic[@"user_id"]));
}
- (IBAction)plZanAction:(UIButton *)btn{
    self.zanBlock(self.tag);
}
@end
