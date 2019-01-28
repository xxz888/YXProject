//
//  YXFindViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindViewController.h"
#import "PYSearchViewController.h"
#import "PYSearch.h"
#import "PYTempViewController.h"
#import "YXMineEssayTableViewCell.h"
#import "YXMineEssayDetailViewController.h"
#import "YXMineImageDetailViewController.h"
#import "YXMineViewController.h"
#import "YXMineImageCollectionViewCell.h"
#import "YXMineImageCollectionView.h"
#import "BKCustomSwitchBtn.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]
#define ChildView_Frame CGRectMake(5, 104, KScreenWidth-10, kScreenHeight-170-49-104)
@interface YXFindViewController ()<PYSearchViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,BKCustomSwitchBtnDelegate>{
    NSInteger page ;
    CBSegmentView * sliderSegmentView;
}

@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * heightArray;
@property(nonatomic,strong)NSString * type;

@property (nonatomic, strong) BKCustomSwitchBtn *changeShowTypeBtn;//转换cell布局的Btn
@property (nonatomic, assign) GoodsListShowType goodsShowType;
@property (nonatomic, strong) YXMineImageCollectionView * yxCollectionView;

@end

@implementation YXFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //搜索栏
    [self setNavSearchView];
    //滑动条
    
    [self.view addSubview: [self headerView]];
    //tableview
    [self collectionViewCon];
    [self tableviewCon];
    self.yxTableView.hidden = YES;

    [self setViewData];



}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)collectionViewCon{
    
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc]init];
    self.yxCollectionView = [[YXMineImageCollectionView alloc]initWithFrame:ChildView_Frame collectionViewLayout:layout1];
    //self.yxCollectionView.myDelegate = self;
    [self.view addSubview:self.yxCollectionView];
    self.yxCollectionView.showType = self.whereCome ? signleLineShowDoubleGoods : singleLineShowOneGoods;
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
    self.yxCollectionView.indexPathBlock = ^(NSIndexPath * indexPath) {
        NSDictionary * dic = weakself.dataArray[indexPath.row];
        YX_MANAGER.isHaveIcon = NO;
        YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [weakself.navigationController pushViewController:VC animated:YES];
    };
}
#pragma mark - 更改展示样式
-(void)changeShowTypeHome:(UIButton *)btn{
    
    if (btn.isSelected) {
        btn.selected = NO;
        // self.goodsShowType = singleLineShowOneGoods;
        self.yxCollectionView.showType =singleLineShowOneGoods;
        
    } else {
        btn.selected = YES;
        // self.goodsShowType = signleLineShowDoubleGoods;
        self.yxCollectionView.showType =signleLineShowDoubleGoods;
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
-(void)setViewData{
    /*
     如果是发现界面，直接请求发现界面的数据
     如果是我的界面，要分为两种
     1、如果是我自己的界面，请求一种
     2、如果是别人的界面，在请求一种
     现在的情况是，进入这个界面，默认请求晒图展示
     */
    if (self.whereCome) {
        [sliderSegmentView setTitleArray:@[@"晒图",@"文章"] withStyle:CBSegmentStyleSlider];
        user_id_BOOL ? [self requestOtherShaiTuList] : [self requestMineShaiTuList];
    }else{
        [self requestFindTag];
    }
}
-(void)tableviewCon{
    self.yxTableView = [[UITableView alloc]initWithFrame:ChildView_Frame style:0];
    [self.view addSubview:self.yxTableView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;

//    self.yxTableView.tableHeaderView = [self headerView];
    page = 1;
    _type = @"1";
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineEssayTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineEssayTableViewCell"];
}
-(UIView *)headerView{
    kWeakSelf(self);
    sliderSegmentView = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 40)];
    sliderSegmentView.titleChooseReturn = ^(NSInteger x) {
        weakself.type = NSIntegerToNSString(x+1);
        /*
         如果是发现界面，直接请求发现界面的数据
         如果是我的界面，要分为两种
                      1、如果是我自己的界面，请求一种
                      2、如果是别人的界面，在请求一种
         */
        if (weakself.whereCome) {
            if (user_id_BOOL) {
                if ([weakself.type integerValue] == 1) {
                    [weakself showShaiTuView];
                    [weakself requestOtherShaiTuList];
                }else if ([weakself.type integerValue] == 2){
                    [weakself showWenZhangView];
                    [weakself requestOtherWenZhangList];
                }
            }else{
                if ([weakself.type integerValue] == 1) {
                    [weakself showShaiTuView];
                    [weakself requestMineShaiTuList];
                }else if ([weakself.type integerValue] == 2){
                    [weakself showWenZhangView];
                    [weakself requestMineWenZhangList];
                }
            }
        }else{
            [weakself requestFind];
        }
    };
    return sliderSegmentView;
}
-(void)showShaiTuView{
    self.yxTableView.hidden = YES;
    self.yxCollectionView.hidden = NO;
}
-(void)showWenZhangView{
    self.yxTableView.hidden = NO;
    self.yxCollectionView.hidden = YES;
}
#pragma mark ========== 先请求tag列表,获取发现页标签数据 ==========
-(void)requestFindTag{
    kWeakSelf(self);
    NSMutableArray * array = [[NSMutableArray alloc]init];
    [YX_MANAGER requestGet_users_find_tag:@"" success:^(id object) {
        for (NSDictionary * dic in object) {
            [array addObject:dic[@"type"]];
        }
       [sliderSegmentView setTitleArray:array withStyle:CBSegmentStyleSlider];
       [weakself requestFind];
    }];
}
#pragma mark ========== 在请求具体tag下的请求,获取发现页标签数据全部接口 ==========
-(void)requestFind{
    kWeakSelf(self);
    NSString * parString =[NSString stringWithFormat:@"%@/%@",self.type,@"1"];
    [YX_MANAGER requestGet_users_find:parString success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}
#pragma mark ========== 我的界面晒图请求 ==========
-(void)requestMineShaiTuList{
    kWeakSelf(self);
    NSString * pageString = NSIntegerToNSString(page) ;
    id object = UserDefaultsGET(@"a2");
    self.yxCollectionView.dataArray = [NSArray arrayWithArray:object];
    self.yxCollectionView.whereCome = self.whereCome;
    [weakself mineShaiTuCommonAction:object];
    [YX_MANAGER requestGetDetailListPOST:@{@"type":@(2),@"tag":@"0",@"page":@(1)} success:^(id object) {
        UserDefaultsSET(object, @"a2");

        [weakself mineShaiTuCommonAction:object];
    }];
    id object1 = UserDefaultsGET(@"a1");
    
    [YX_MANAGER requestGetSersAllList:@"1" success:^(id object) {
        UserDefaultsSET(object, @"a1");
    }];
}
#pragma mark ========== 我的界面文章请求 ==========
-(void)requestMineWenZhangList{
    kWeakSelf(self);
    id object = UserDefaultsGET(@"a3");
    [weakself mineWenZhangCommonAction:object];

    NSString * pageString = NSIntegerToNSString(page) ;
    [YX_MANAGER requestEssayListGET:pageString success:^(id object) {
        [weakself mineWenZhangCommonAction:object];
        UserDefaultsSET(object, @"a3");

    }];
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZanAction:(YXMineEssayTableViewCell *)cell{
    NSIndexPath * indexPath = [self.yxTableView indexPathForCell:cell];
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        [weakself requestFind];
    }];
}

#pragma mark ========== 其他用户的晒图请求 ==========
-(void)requestOtherShaiTuList{
    kWeakSelf(self);
    [YX_MANAGER requestOtherImage:[self.userId append:@"/1"] success:^(id object) {
        [weakself mineShaiTuCommonAction:object];
    }];
}
#pragma mark ========== 其他用户的文章请求 ==========
-(void)requestOtherWenZhangList{
    kWeakSelf(self);
    [YX_MANAGER requestOtherEssay:[self.userId append:@"/1"] success:^(id object) {
        [weakself mineWenZhangCommonAction:object];
    }];
}
-(void)mineShaiTuCommonAction:(id)object{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:object];
    [self.yxCollectionView reloadData];
}
-(void)mineWenZhangCommonAction:(id)object{
    [self.dataArray removeAllObjects];
    [self.heightArray removeAllObjects];
    [self.dataArray addObjectsFromArray:object];
    for (NSDictionary * dic in object) {
        CGFloat height = [self getHTMLHeightByStr:dic[@"essay"]];
        [self.heightArray addObject:@(height/2.2)];
    }
    [self.yxTableView reloadData];
}
#pragma mark ========== tableview代理方法 ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.whereCome ? 335-60 : 335;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineEssayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineEssayTableViewCell" forIndexPath:indexPath];
    cell.topViewConstraint.constant =  self.whereCome ? 0 : 60;
    cell.topView.hidden = self.whereCome;
    cell.essayTitleImageView.tag = indexPath.row;
    [self customWenZhangCell:cell indexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    YX_MANAGER.isHaveIcon = NO;
    YXMineEssayDetailViewController * VC = [[YXMineEssayDetailViewController alloc]init];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:VC animated:YES];
    
    
    //1(晒图数据)2(文章数据)
//    switch (self.whereCome ?  [self.type integerValue] : [dic[@"obj"] integerValue]) {
//        case 1:{
//
//        }
//            break;
//        case 2:{
//
//        }
//            break;
//        default:
//            break;
//    }
}
#pragma mark ========== 文章tableview ==========
-(void)customWenZhangCell:(YXMineEssayTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    kWeakSelf(self);
    cell.block = ^(YXMineEssayTableViewCell * cell) {
        [weakself requestDianZanAction:cell];
    };
    cell.clickImageBlock = ^(NSInteger tag) {
        UIStoryboard * stroryBoard5 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
        YXMineViewController * mineVC = [stroryBoard5 instantiateViewControllerWithIdentifier:@"YXMineViewController"];
        mineVC.userId = kGetString(weakself.dataArray[tag][@"user_id"]);
        mineVC.whereCome = YES;
        [weakself.navigationController pushViewController:mineVC animated:YES];
    };
    
    [cell.essayTitleImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.essayNameLbl.text = dic[@"user_name"];
    cell.essayTimeLbl.text = [ShareManager timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@""];
    cell.mineImageLbl.text = dic[@"title"];
    cell.mineTimeLbl.text = dic[@"title"];
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    
    [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    NSURL * url1 = [NSURL URLWithString:self.dataArray[indexPath.row][@"picture1"]];
    NSURL * url2 = [NSURL URLWithString:self.dataArray[indexPath.row][@"picture2"]];
    [cell.midImageView sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [cell.midTwoImageVIew sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"img_moren"]];

}


















#pragma mark ==========  搜索相关 ==========
-(void)setNavSearchView{
    UIColor *color =  YXRGBAColor(239, 239, 239);
    UITextField * searchBar = [[UITextField alloc] init];
    searchBar.frame = CGRectMake(50, 0, KScreenWidth - 50, 35);
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 10;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"   🔍 搜索";
    [searchBar addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingDidBegin];
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = searchBar;
}
-(void)textField1TextChange:(UITextField *)tf{
    [self clickSearchBar];
}
- (void)clickSearchBar{
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"PYExampleSearchPlaceholderText", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        [searchViewController.navigationController pushViewController:[[PYTempViewController alloc] init] animated:YES];
    }];
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoryStyle = 1;
    searchViewController.delegate = self;
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    [self.navigationController pushViewController:searchViewController animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.type = @"1";
}
//计算html字符串高度
-(CGFloat )getHTMLHeightByStr:(NSString *)str
{
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]}documentAttributes:NULL error:nil];
    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, htmlString.length)];
    CGSize textSize = [htmlString boundingRectWithSize:(CGSize){KScreenWidth - 10, CGFLOAT_MAX}options:NSStringDrawingUsesFontLeading || NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return textSize.height;
}
@end
