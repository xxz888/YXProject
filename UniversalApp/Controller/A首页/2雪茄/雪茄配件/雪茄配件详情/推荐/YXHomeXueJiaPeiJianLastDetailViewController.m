//
//  YXHomeXueJiaPeiJianLastDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPeiJianLastDetailViewController.h"
#import "SDCycleScrollView.h"
#import "QMUITextView.h"

@interface YXHomeXueJiaPeiJianLastDetailViewController ()<SDCycleScrollViewDelegate>
@property(nonatomic, strong) QMUITextView * qmuiTextView;
@property(nonatomic, strong) QMUITextView * spxxqmuiTextView;

@end

@implementation YXHomeXueJiaPeiJianLastDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.dic[@"name"];
    
    [self setUpSycleScrollView:[NSArray arrayWithArray:self.dic[@"photo_list"]]];
    
    [self shangpinxinxi];
    [self goumaixuzhi];
    
    self.priceLbl.text = [kGet2fDouble([self.dic[@"price"] doubleValue]) concate:@"¥ "];
    self.titleLbl.text = self.dic[@"name"];
    
}
-(void)shangpinxinxi{
    self.shangpinxinxiLbl.numberOfLines = 0;
    self.shangpinxinxiLbl.lineBreakMode = UILineBreakModeWordWrap;
    NSString *str = [self.dic[@"info"] stringByReplacingOccurrencesOfString: @"\\n" withString:@"\n"];

    self.shangpinxinxiLbl.text = str ;
//    self.spxxqmuiTextView = [[QMUITextView alloc] init];
//    self.spxxqmuiTextView.frame = CGRectMake(0, 0, self.shangpinxinxiView.frame.size.width, self.shangpinxinxiView.frame.size.height);
//    self.spxxqmuiTextView.backgroundColor =KWhiteColor;
//    self.spxxqmuiTextView.font = UIFontMake(13);
//    self.spxxqmuiTextView.text = self.dic[@"info"];
//    //    self.qmuiTextView.textContainerInset = UIEdgeInsetsMake(16, 12, 16, 12);
//
//    self.spxxqmuiTextView.text = [NSString stringWithFormat:@"%@",[self.dic[@"info"] stringByReplacingOccurrencesOfString:@"\n" withString:@" \r\n"]];
////    self.spxxqmuiTextView.text.numberOfLines = 0;//自动换行
//    self.spxxqmuiTextView.layer.cornerRadius = 8;
//    self.spxxqmuiTextView.clipsToBounds = YES;
//    [self.spxxqmuiTextView becomeFirstResponder];
//    [self.shangpinxinxiView addSubview:self.spxxqmuiTextView];
//    self.spxxqmuiTextView.userInteractionEnabled = NO;
}
-(void)goumaixuzhi{
    self.goumaixuzhiLbl.numberOfLines = 0;
    self.goumaixuzhiLbl.lineBreakMode = UILineBreakModeWordWrap;
    NSString *str = [self.dic[@"notice"] stringByReplacingOccurrencesOfString: @"\\n" withString:@"\n"];

        self.goumaixuzhiLbl.text = str ;
//    self.qmuiTextView = [[QMUITextView alloc] init];
//    self.qmuiTextView.frame = CGRectMake(0, 0, self.goumaixuzhiView.frame.size.width, self.goumaixuzhiView.frame.size.height);
//    self.qmuiTextView.backgroundColor =KWhiteColor;
//    self.qmuiTextView.font = UIFontMake(13);
//    self.qmuiTextView.text = self.dic[@"notice"];
//    //    self.qmuiTextView.textContainerInset = UIEdgeInsetsMake(16, 12, 16, 12);
//    self.qmuiTextView.layer.cornerRadius = 8;
//    self.qmuiTextView.clipsToBounds = YES;
//    [self.qmuiTextView becomeFirstResponder];
//    [self.goumaixuzhiView addSubview:self.qmuiTextView];
//    self.qmuiTextView.userInteractionEnabled = NO;
    
}
//添加轮播图
- (void)setUpSycleScrollView:(NSArray *)imageArray{
    
    NSMutableArray * photoArray = [NSMutableArray array];
    NSMutableArray * titleArray = [NSMutableArray array];
    
    for (NSDictionary * dic in imageArray) {
        [photoArray addObject:dic[@"photo"]];
    }
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.titleView.frame.size.height, self.titleView.frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    cycleScrollView3.centerX = self.titleView.centerX;
    cycleScrollView3.bannerImageViewContentMode =  3;
    cycleScrollView3.showPageControl = NO;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.autoScrollTimeInterval = 4;
    cycleScrollView3.titlesGroup = titleArray;
    cycleScrollView3.backgroundColor = KWhiteColor;
    cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
    [self.titleView addSubview:cycleScrollView3];
}
- (IBAction)addCarShopAction:(id)sender {
    //[QMUITips showInfo:SHOW_FUTURE_DEV inView:self.view hideAfterDelay:1];

}
- (IBAction)buyAction:(id)sender {
    //[QMUITips showInfo:SHOW_FUTURE_DEV inView:self.view hideAfterDelay:1];

}

@end
