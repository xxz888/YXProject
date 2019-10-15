//
//  YXFindSearchTagDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/4/2.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchTagDetailViewController.h"
#import "YXMineEssayTableViewCell.h"
#import "YXMineImageDetailViewController.h"
#import "BKCustomSwitchBtn.h"
#import "YXMineImageCollectionViewCell.h"
#import "XHWebImageAutoSize.h"
#import "YXFindSearchTagHeaderView.h"
#import "YXHomeXueJiaQuestionDetailViewController.h"
#import "YXMineFootDetailViewController.h"
#import "YXFirstFindImageTableViewCell.h"
@interface YXFindSearchTagDetailViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,BKCustomSwitchBtnDelegate>{
    NSInteger page ;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (strong,nonatomic)  UICollectionView * yxCollectionView;
@property (nonatomic, strong) BKCustomSwitchBtn *changeShowTypeBtn;//转换cell布局的Btn
@property (nonatomic, strong) YXFindSearchTagHeaderView * headerView;

@end

@implementation YXFindSearchTagDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = KWhiteColor;
    self.dataArray = [[NSMutableArray alloc]init];
    self.title = self.key;
    [self collectionViewCon];
    [self addCollectionViewRefreshView:self.yxCollectionView];
    [self requestAction];
}
-(void)requestAction{
    kWeakSelf(self);
    [YX_MANAGER requestSearchFind_all:@{@"key":self.key,@"page":NSIntegerToNSString(self.requestPage),@"type":self.type,@"key_unicode":[self.key utf8ToUnicode]} success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxCollectionView reloadData];
        [weakself.yxCollectionView.mj_header endRefreshing];
        [weakself.yxCollectionView.mj_footer endRefreshing];

    }];
}
-(YXFindSearchTagHeaderView *)headerView{
    if (!_headerView) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXFindSearchTagHeaderView" owner:self options:nil];
        _headerView = [nib objectAtIndex:0];
        _headerView.frame = CGRectMake(0, 0, KScreenWidth, 150);
        _headerView.titleImageView.layer.masksToBounds = YES;
        _headerView.titleImageView.layer.cornerRadius = _headerView.titleImageView.frame.size.width / 2.0;
    }
    _headerView.lbl1.text = kGetString(self.startDic[@"tag"]);
    _headerView.lbl2.text = [kGetString(self.startDic[@"count_tag"]) append:@"篇帖子"];
    
    NSString * photo = [self.startDic[@"photo"] contains:@"http://photo.thegdlife.com/"] ? [self.startDic[@"photo"] replaceAll:@"http://photo.thegdlife.com/" target:IMG_URI] : self.startDic[@"photo"] ;
    [_headerView.titleImageView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    kWeakSelf(self);
    _headerView.block = ^(NSInteger segmentIndex) {
        weakself.type = segmentIndex == 0 ? @"3" : @"4";
        [weakself requestAction];
    };
    return _headerView;
}

-(void)headerRereshing{
    [super headerRereshing];
    [self requestAction];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestAction];
}

-(void)collectionViewCon{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize =CGSizeMake(KScreenWidth,150);//头视图大小

    CGFloat heightKK = AxcAE_IsiPhoneX ? 212 : 155;
    CGFloat height =  (AxcAE_IsiPhoneX ? - 64 : -54) ;
    CGRect frame = CGRectMake(0, 0, KScreenWidth,KScreenHeight-kTopHeight);
    self.yxCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    self.yxCollectionView.backgroundColor = KWhiteColor;
    self.showType = signleLineShowDoubleGoods;
    [self.view addSubview:self.yxCollectionView];
    //更换展示商品列表的按钮
    _changeShowTypeBtn = [[BKCustomSwitchBtn alloc]initWithFrame:CGRectZero];
    _changeShowTypeBtn.hidden = YES;
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
    [self.yxCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    [header addSubview:[self headerView]];
    return header;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(KScreenWidth, 150);
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
        [self requestAction];
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
    YXMineImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXMineImageCollectionViewCell" forIndexPath:indexPath];
    cell.essayTitleImageView.tag = indexPath.row;
    
    if ([self.dataArray[indexPath.row][@"url_list"] count] > 0) {
        NSString * str1 = [(NSMutableString *)self.dataArray[indexPath.row][@"url_list"][0] replaceAll:@" " target:@"%20"];
        [cell.midImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }

    cell.titleLbl.text = [dic[@"detail"] UnicodeToUtf8];
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];

    
    
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:dic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    NSString * praisNum = kGetString(dic[@"praise_number"]);
    cell.zanLbl.text = praisNum;
    cell.userLbl.text = dic[@"user_name"];
    kWeakSelf(self);
    cell.block = ^(YXMineImageCollectionViewCell * cell) {
        NSIndexPath * indexPath = [weakself.yxCollectionView indexPathForCell:cell];
        [weakself requestDianZanAction:indexPath];
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    if (tag == 1) {//晒图
        YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
        CGFloat h = [YXFirstFindImageTableViewCell cellDefaultHeight:dic];
        VC.headerViewHeight = h;
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:VC animated:YES];
    }
}



-(Moment *)setTestInfo:(NSDictionary *)dic{
    NSMutableArray *commentList = nil;
    Moment *moment = [[Moment alloc] init];
    moment.praiseNameList = nil;
    moment.userName = dic[@"user_name"];
    moment.text = dic[@"title"];
    moment.detailText = dic[@"question"];
    moment.time = dic[@"publish_date"] ? [dic[@"publish_date"] longLongValue] : [dic[@"publish_time"] longLongValue];
    moment.singleWidth = (KScreenWidth-30)/3;
    moment.singleHeight = 100;
    moment.location = @"";
    moment.isPraise = NO;
    moment.photo =dic[@"user_photo"];
    moment.startId = dic[@"id"];
    NSMutableArray * imgArr = [NSMutableArray array];
    if ([dic[@"pic1"] length] >= 5) {
        [imgArr addObject:dic[@"pic1"]];
    }
    if ([dic[@"pic2"] length] >= 5) {
        [imgArr addObject:dic[@"pic2"]];
    }
    if ([dic[@"pic3"] length] >= 5) {
        [imgArr addObject:dic[@"pic3"]];
    }
    moment.imageListArray = [NSMutableArray arrayWithArray:imgArr];
    moment.fileCount = imgArr.count;
    
    commentList = [[NSMutableArray alloc] init];
    int num = (int)[dic[@"answer"] count];
    for (int j = 0; j < num; j ++) {
        Comment *comment = [[Comment alloc] init];
        comment.userName = dic[@"answer"][j][@"user_name"];
        comment.text =  dic[@"answer"][j][@"answer"];
        comment.time = 1487649503;
        comment.pk = j;
        [commentList addObject:comment];
    }
    [moment setValue:commentList forKey:@"commentList"];
    return moment;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 280;
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
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
