//
//  YXHomeViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>

#import "YXHomeTuiJianViewController.h"
#import "YXHomeXueJiaViewController.h"
#import "YXHomeMeiJiuViewController.h"
#import "YXHomeGaoErFuViewController.h"
@interface YXHomeViewController ()<UINavigationControllerDelegate>{
    YXHomeTuiJianViewController * TuiJianVC;
    YXHomeXueJiaViewController * XueJiaVC;
    YXHomeMeiJiuViewController * MeiJiuVC;
    YXHomeGaoErFuViewController * GaoErFuVC;
}
@property (nonatomic,weak) ZXSegmentController* segmentController;

@end

@implementation YXHomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];

    if (!TuiJianVC) {
        TuiJianVC = [[YXHomeTuiJianViewController alloc]init];
    }
    
    
    if (!XueJiaVC) {
        XueJiaVC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaViewController"];
    }
    
    if (!MeiJiuVC) {
        MeiJiuVC = [[YXHomeMeiJiuViewController alloc]init];
    }
    
    if (!GaoErFuVC) {
        GaoErFuVC = [[YXHomeGaoErFuViewController alloc]init];
    }

    
    NSArray* names = @[@"推荐",@"雪茄",@"美酒",@"高尔夫"];
    NSArray* controllers = @[XueJiaVC,XueJiaVC,XueJiaVC,XueJiaVC];
    
    
    /*
     *   controllers长度和names长度必须一致，否则将会导致cash
     *   segmentController在一个屏幕里最多显示6个按钮，如果超过6个，将会自动开启滚动功能，如果不足6个，按钮宽度=父view宽度/x  (x=按钮个数)
     */
    ZXSegmentController* segmentController = [[ZXSegmentController alloc] initWithControllers:controllers
                                                                               withTitleNames:names
                                                                             withDefaultIndex:1
                                                                               withTitleColor:[UIColor grayColor]
                                                                       withTitleSelectedColor:YXRGBAColor(88, 88, 88)
                                                                              withSliderColor:YXRGBAColor(88, 88, 88)];
    [self addChildViewController:(_segmentController = segmentController)];
    [self.view addSubview:segmentController.view];
    [segmentController didMoveToParentViewController:self];
    [self createAutolayout];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [segmentController scrollToIndex:1 animated:YES];
    });
}
- (void)createAutolayout{
    /*
     高度自由化的布局，可以根据需求，把segmentController布局成你需要的样子.(面对不同的场景，设置不同的top距离)
     */
    [_segmentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
