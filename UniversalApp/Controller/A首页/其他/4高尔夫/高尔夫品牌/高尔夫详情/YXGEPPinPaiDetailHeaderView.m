//
//  YXGEPPinPaiDetailHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/18.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXGEPPinPaiDetailHeaderView.h"
#import "ZXSegmentHeaderView.h"
#import "ZXSegmentHeaderModel.h"

#define TYPE_QIU_JU @"球具"
#define TYPE_QIU_DAO_MU_GAN @"球道木杆"
#define TYPE_TIE_GAN @"铁杆"
#define TYPE_WA_QI_GAN @"挖起杆"
#define TYPE_TUI_GAN @"推杆"
#define TYPE_GAO_ER_FU @"高尔夫"

@implementation YXGEPPinPaiDetailHeaderView


- (void)drawRect:(CGRect)rect {
    kWeakSelf(self);
    ZXSegmentHeaderModel* model = [[ZXSegmentHeaderModel alloc] init];
    model.names = @[TYPE_QIU_JU,TYPE_QIU_DAO_MU_GAN,TYPE_TIE_GAN,TYPE_WA_QI_GAN,TYPE_TUI_GAN,TYPE_GAO_ER_FU];
    model.indexs = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    ZXSegmentHeaderView* headerView = [[ZXSegmentHeaderView alloc] initWithModel:model
                                                               withContainerView:self.smallView
                                                                withDefaultIndex:0
                                                                  withTitleColor:[UIColor grayColor]
                                                          withTitleSelectedColor:YXRGBAColor(88, 88, 88)
                                                                 withSliderColor:YXRGBAColor(88, 88, 88)
                                                                       withBlock:^(NSUInteger index) {
//    if (self.segmentDelegate && [self.segmentDelegate respondsToSelector:@selector(clickSegmentAction:)]) {
//        [self.segmentDelegate clickSegmentAction:index];
//        }
     }
                                                              withMaxDisplayItem:6
                                                                  withItemHeight:40
                                                                    withFontSize:18];
    headerView.frame = CGRectMake(0, 0, KScreenWidth, 40);
    self.smallView.backgroundColor = [UIColor grayColor];
    [self.smallView addSubview:headerView];
}

- (IBAction)section1GuanZhuAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickGuanZhuAction:)]) {
        [self.delegate clickGuanZhuAction:self.section1GuanZhuBtn];
    }
}
@end
