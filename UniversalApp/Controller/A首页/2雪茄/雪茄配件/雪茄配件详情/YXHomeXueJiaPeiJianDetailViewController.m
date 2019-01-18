//
//  YXHomeXueJiaPeiJianDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPeiJianDetailViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>
#import "YXHomeXueJiaPeiJianDetailTuiJianViewController.h"
@interface YXHomeXueJiaPeiJianDetailViewController (){
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC1;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC2;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC3;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC4;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC5;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC6;

}

@end

@implementation YXHomeXueJiaPeiJianDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.startDic[@"brand_name"];

    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    VC1 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC1.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC1.segIndex = @"1";
    
    VC2 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC2.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC2.segIndex = @"2";

    VC3 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC3.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC3.segIndex = @"3";

    VC4 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC4.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC4.segIndex = @"4";

    VC5 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC5.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC5.segIndex = @"5";

    VC6 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC6.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC4.segIndex = @"6";

    NSArray* names = @[@"推荐",@"雪茄剪",@"打火机",@"保湿盒",@"雪茄盒",@"烟灰缸"];
    NSArray* controllers = @[VC1,VC2,VC3,VC4,VC5,VC6];
    
    
    /*
     *   controllers长度和names长度必须一致，否则将会导致cash
     *   segmentController在一个屏幕里最多显示6个按钮，如果超过6个，将会自动开启滚动功能，如果不足6个，按钮宽度=父view宽度/x  (x=按钮个数)
     */
    ZXSegmentController* segmentController = [[ZXSegmentController alloc] initWithControllers:controllers
                                                                               withTitleNames:names
                                                                             withDefaultIndex:0
                                                                               withTitleColor:[UIColor grayColor]
                                                                       withTitleSelectedColor:YXRGBAColor(88, 88, 88)
                                                                         withSliderColor:YXRGBAColor(88, 88, 88)];
    [self addChildViewController:(self.segmentController = segmentController)];
    [self.view addSubview:segmentController.view];
    [segmentController didMoveToParentViewController:self];
    [self createAutolayout];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [segmentController scrollToIndex:1 animated:YES];
//    });
}
- (void)createAutolayout{
    /*
     高度自由化的布局，可以根据需求，把segmentController布局成你需要的样子.(面对不同的场景，设置不同的top距离)
     */
    [self.segmentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

@end
