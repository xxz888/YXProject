//
//  YXHomeXueJiaPeiJianDetailTuiJianViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPeiJianDetailTuiJianViewController.h"
#import "BKCustomSwitchBtn.h"
#import "ClassifyCollection.h"
#import "YXHomeXueJiaPeiJianLastDetailViewController.h"

#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenWidth ScreenBounds.size.width
#define ScreenHeight ScreenBounds.size.height
@interface YXHomeXueJiaPeiJianDetailTuiJianViewController ()<BKCustomSwitchBtnDelegate>
@property (nonatomic, strong) BKCustomSwitchBtn *changeShowTypeBtn;//转换cell布局的Btn
@property (nonatomic, assign) GoodsListShowType goodsShowType;
@property (nonatomic, strong) ClassifyCollection *collectionView;

@end

@implementation YXHomeXueJiaPeiJianDetailTuiJianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestCollection:self.segIndex];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)requestCollection:(NSString *)type{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@/%@",type,@"1",self.startDic[@"brand_name"]];
    [YX_MANAGER requestCigar_accessoriesGET:par success:^(id object) {
        weakself.collectionView.dataArray = [NSArray arrayWithArray:object];
        [weakself.collectionView reloadData];
    }];
}
- (void)createUI{
    self.goodsShowType = signleLineShowDoubleGoods;
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[ClassifyCollection alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout1];
    //self.collectionView.myDelegate = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.showType = self.goodsShowType;
    
    
    //更换展示商品列表的按钮
    _changeShowTypeBtn = [[BKCustomSwitchBtn alloc]initWithFrame:CGRectZero];
    _changeShowTypeBtn.hidden = NO;
    _changeShowTypeBtn.selected = YES;
    _changeShowTypeBtn.myDelegate = self;
    [_changeShowTypeBtn setDragEnable:YES];
    [_changeShowTypeBtn setAdsorbEnable:YES];
    _changeShowTypeBtn.frame = CGRectMake(300, 200 + 5, 30, 30);
    [_changeShowTypeBtn addTarget:self action:@selector(changeShowTypeHome:) forControlEvents:UIControlEventTouchUpInside];
    [_changeShowTypeBtn setBackgroundImage:[UIImage imageNamed:@"商品列表样式1"] forState:UIControlStateNormal];
    [_changeShowTypeBtn setBackgroundImage:[UIImage imageNamed:@"商品列表样式2"] forState:UIControlStateSelected];
    [self.view addSubview:_changeShowTypeBtn];
    
    kWeakSelf(self);
    self.collectionView.block = ^(NSInteger index) {
        YXHomeXueJiaPeiJianLastDetailViewController * VC = [[YXHomeXueJiaPeiJianLastDetailViewController alloc]init];
        VC.dic = weakself.collectionView.dataArray[index];
        [weakself.navigationController pushViewController:VC animated:YES];
    };
}
#pragma mark - 更改展示样式
-(void)changeShowTypeHome:(UIButton *)btn{
    
    if (btn.isSelected) {
        btn.selected = NO;
        // self.goodsShowType = singleLineShowOneGoods;
        self.collectionView.showType =singleLineShowOneGoods;
        
    } else {
        btn.selected = YES;
        // self.goodsShowType = signleLineShowDoubleGoods;
        self.collectionView.showType =signleLineShowDoubleGoods;
    }
}
#pragma mark - 禁止切换btn位置在搜索条件栏上
-(void)btnCurrentLocationOrignalY:(CGFloat)orignalY begainPoint:(CGPoint)point{
    //
    //    if (self.backScrollView.frame.origin.y > orignalY) {
    //        [UIView animateWithDuration:0.2 animations:^{
    //            self.changeShowTypeBtn.frame = CGRectMake(ScreenWidth-40, self.backScrollView.frame.origin.y + 5, 30, 30);
    //        }];
    //    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
