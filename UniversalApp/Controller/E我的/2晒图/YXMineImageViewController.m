//
//  YXMineImageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineImageViewController.h"
#import "YXMineEssayTableViewCell.h"
#import "YXMineImageDetailViewController.h"
#import "BKCustomSwitchBtn.h"
#import "YXMineImageCollectionViewCell.h"
@interface YXMineImageViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,BKCustomSwitchBtnDelegate>{
    NSInteger page ;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (strong,nonatomic)  UICollectionView * yxCollectionView;
@property (nonatomic, strong) BKCustomSwitchBtn *changeShowTypeBtn;//转换cell布局的Btn
@property (nonatomic, assign) GoodsListShowType goodsShowType;
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]
@end

@implementation YXMineImageViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = KWhiteColor;
    self.dataArray = [[NSMutableArray alloc]init];
    [self collectionViewCon];
    
    
    [self addCollectionViewRefreshView:self.yxCollectionView];
    user_id_BOOL ? [self requestOtherShaiTuList] : [self requestMineShaiTuList];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)headerRereshing{
    [super headerRereshing];
    user_id_BOOL ? [self requestOtherShaiTuList] : [self requestMineShaiTuList];
}
-(void)footerRereshing{
    [super footerRereshing];
    user_id_BOOL ? [self requestOtherShaiTuList] : [self requestMineShaiTuList];
}

-(void)collectionViewCon{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.yxCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-170-NavigationBarHeight - 64) collectionViewLayout:layout];
    self.yxCollectionView.backgroundColor = KWhiteColor;
    self.showType = signleLineShowDoubleGoods;
    [self.view addSubview:self.yxCollectionView];
    //更换展示商品列表的按钮
    _changeShowTypeBtn = [[BKCustomSwitchBtn alloc]initWithFrame:CGRectZero];
    _changeShowTypeBtn.hidden = NO;
    _changeShowTypeBtn.selected = YES;
    _changeShowTypeBtn.myDelegate = self;
    [_changeShowTypeBtn setDragEnable:YES];
    [_changeShowTypeBtn setAdsorbEnable:YES];
    _changeShowTypeBtn.frame = CGRectMake(KScreenWidth-30, 20, 30, 30);
    [_changeShowTypeBtn addTarget:self action:@selector(changeShowTypeHome:) forControlEvents:UIControlEventTouchUpInside];
    [_changeShowTypeBtn setBackgroundImage:[UIImage imageNamed:@"商品列表样式1"] forState:UIControlStateNormal];
    [_changeShowTypeBtn setBackgroundImage:[UIImage imageNamed:@"商品列表样式2"] forState:UIControlStateSelected];
    [self.view addSubview:_changeShowTypeBtn];
    
    
    self.yxCollectionView.dataSource = self;
    self.yxCollectionView.delegate = self;
    self.yxCollectionView.alwaysBounceVertical = YES;
    self.yxCollectionView.showsVerticalScrollIndicator = NO;
    self.yxCollectionView.showsHorizontalScrollIndicator = NO;
    [self.yxCollectionView registerNib:[UINib nibWithNibName:@"YXMineImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YXMineImageCollectionViewCell"];
    
}

#pragma mark ========== 我的界面晒图请求 ==========
-(void)requestMineShaiTuList{
    kWeakSelf(self);
    [YX_MANAGER requestGetDetailListPOST:@{@"type":@(2),@"page":NSIntegerToNSString(self.requestPage)} success:^(id object) {
        [weakself mineShaiTuRefreshAction:object];
        
    }];
}
#pragma mark ========== 其他用户的晒图请求 ==========
-(void)requestOtherShaiTuList{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",self.userId,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestOtherImage:par success:^(id object) {
        [weakself mineShaiTuRefreshAction:object];
    }];
}

#pragma mark ========== 界面刷新 ==========x
-(void)mineShaiTuRefreshAction:(id)object{
     self.dataArray = [self commonCollectionAction:object dataArray:self.dataArray];
    [self.yxCollectionView reloadData];
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZanAction:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        user_id_BOOL ? [weakself requestOtherShaiTuList] : [weakself requestMineShaiTuList];
    }];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    //    if (self.showType == singleLineShowOneGoods) {
    YXMineImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXMineImageCollectionViewCell" forIndexPath:indexPath];
    cell.essayTitleImageView.tag = indexPath.row;
    NSString * str1 = [(NSMutableString *)dic[@"photo1"] replaceAll:@" " target:@"%20"];
    [cell.midImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    
    cell.titleLbl.text = dic[@"describe"];
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    
    kWeakSelf(self);
    cell.block = ^(YXMineImageCollectionViewCell * cell) {
        NSIndexPath * indexPath = [weakself.yxCollectionView indexPathForCell:cell];
        [weakself requestDianZanAction:indexPath];
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    YX_MANAGER.isHaveIcon = NO;
    [self.navigationController pushViewController:VC animated:YES];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 250;
    if (self.showType == singleLineShowOneGoods) {
        return CGSizeMake(KScreenWidth, height + 100);
    } else {
        return CGSizeMake((KScreenWidth-10)/2.0-0.5, height);
    }
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.001f;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.001f;
}
#pragma mark - set方法
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.yxCollectionView reloadData];
}

-(void)setShowType:(GoodsListShowType)showType{
    _showType = showType;
    [self.yxCollectionView reloadData];
}

#pragma mark - 更改展示样式
-(void)changeShowTypeHome:(UIButton *)btn{
    
    if (btn.isSelected) {
        btn.selected = NO;
        // self.goodsShowType = singleLineShowOneGoods;
        self.showType =singleLineShowOneGoods;
        
    } else {
        btn.selected = YES;
        // self.goodsShowType = signleLineShowDoubleGoods;
        self.showType =signleLineShowDoubleGoods;
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
@end
