//
//  YXFirstFindImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXFirstFindImageTableViewCell.h"

@implementation YXFirstFindImageTableViewCell
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic{
    //计算detail高度
    NSString * titleText = [[NSString stringWithFormat:@"%@%@",dic[@"detail"],dic[@"tag"]] UnicodeToUtf8];
    CGFloat detailHeight = [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
    //计算图片高度
    CGFloat midViewHeight = (KScreenWidth-10);
    return 120 + detailHeight + midViewHeight;
}
-(void)setCellValue:(NSDictionary *)dic{
    //头像
    NSString * str1 = [(NSMutableString *)dic[@"photo"] replaceAll:@" " target:@"%20"];
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    //头名字
    self.titleLbl.text = dic[@"user_name"];
    //头时间
    self.timeLbl.text = [ShareManager updateTimeForRow:[dic[@"publish_time"] longLongValue]];
    //地点button
    [self.mapBtn setTitle:dic[@"publish_site"] forState:UIControlStateNormal];
    //detail
    NSString * titleText = [[NSString stringWithFormat:@"%@%@",dic[@"detail"],dic[@"tag"]] UnicodeToUtf8];
    
    
    NSArray * indexArray = [dic[@"tag"] split:@" "];
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
    [self.detailLbl setText:titleText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
               tapStringArray:modelArray];
      self.detailHeight.constant = [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
    [ShareManager setLineSpace:9 withText:self.detailLbl.text inLabel:self.detailLbl tag:dic[@"tag"]];
    
    
    //图片
    NSArray * urlList = dic[@"url_list"];
    self.countLbl.text = NSIntegerToNSString(urlList.count);
    if ([urlList count] >= 4) {
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
        self.onlyOneImv.hidden = NO;
        self.imgV1.hidden = self.imgV2.hidden = self.imgV3.hidden = self.imgV4.hidden = self.stackView.hidden = YES;
        NSString * string = [(NSMutableString *)urlList[0] replaceAll:@" " target:@"%20"];
        [self.onlyOneImv sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }
    
    if ([dic[@"publish_site"] isEqualToString:@""] || !dic[@"publish_site"] ) {
        self.nameCenter.constant = self.titleImageView.frame.origin.y;
    }else{
        self.nameCenter.constant = 0;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleImageView.layer.masksToBounds = YES;
    self.titleImageView.layer.cornerRadius = self.titleImageView.frame.size.width / 2.0;
    
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
- (IBAction)shareAction:(id)sender {
    self.shareblock(self);
}
@end
