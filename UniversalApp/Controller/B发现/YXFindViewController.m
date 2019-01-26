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
#import "YXMineEssayTableViewCell.h"
#import "YXMineEssayDetailViewController.h"
#import "YXMineImageTableViewCell.h"
#import "YXMineImageDetailViewController.h"
#import "YXMineViewController.h"

#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXFindViewController ()<PYSearchViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    NSInteger page ;
    CBSegmentView * sliderSegmentView;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * heightArray;
@property(nonatomic,strong)NSString * type;



@end

@implementation YXFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //搜索栏
    [self setNavSearchView];
    //tableview
    [self tableviewCon];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setViewData];
  
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
    self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 64, KScreenWidth-10, kScreenHeight-5) style:0];
    [self.view addSubview:self.yxTableView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.tableHeaderView = [self headerView];
    page = 1;
    _type = @"1";
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineImageTableViewCell"];
}
-(UIView *)headerView{
    kWeakSelf(self);
    sliderSegmentView = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
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
                    [weakself requestOtherShaiTuList];
                }else if ([weakself.type integerValue] == 2){
                    [weakself requestOtherWenZhangList];
                }
            }else{
                if ([weakself.type integerValue] == 1) {
                    [weakself requestMineShaiTuList];
                }else if ([weakself.type integerValue] == 2){
                    [weakself requestMineWenZhangList];
                }
            }
        }else{
            [weakself requestFind];
        }
    };
    return sliderSegmentView;
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
    [YX_MANAGER requestGetDetailListPOST:@{@"type":@(2),@"tag":@"0",@"page":@(1)} success:^(id object) {
        [weakself mineShaiTuCommonAction:object];
    }];
}
#pragma mark ========== 我的界面文章请求 ==========
-(void)requestMineWenZhangList{
    kWeakSelf(self);
    NSString * pageString = NSIntegerToNSString(page) ;
    [YX_MANAGER requestEssayListGET:pageString success:^(id object) {
        [weakself mineWenZhangCommonAction:object];
    }];
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZanAction:(YXMineImageTableViewCell *)cell{
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
    [self.yxTableView reloadData];
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
    return self.whereCome ? 350-60 : 350;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineImageTableViewCell" forIndexPath:indexPath];
    cell.topViewConstraint.constant =  self.whereCome ? 0 : 60;
    cell.topView.hidden = self.whereCome;
    cell.essayTitleImageView.tag = indexPath.row;
    [self sameCell:cell indexPath:indexPath];
    [self diffentCell:cell indexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    YX_MANAGER.isHaveIcon = NO;
    //1(晒图数据)2(文章数据)
    switch (self.whereCome ?  [self.type integerValue] : [dic[@"obj"] integerValue]) {
        case 1:{
            YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
            VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:{
            YXMineEssayDetailViewController * VC = [[YXMineEssayDetailViewController alloc]init];
            VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark ========== 定制不同的cell ==========
-(void)sameCell:(YXMineImageTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    [cell.essayTitleImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.essayNameLbl.text = dic[@"user_name"];
    cell.essayTimeLbl.text = [ShareManager timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@""];
    cell.mineImageLbl.text = dic[@"describe"];
    NSString * time = dic[@"publish_time"];
    cell.mineTimeLbl.text = [ShareManager timestampSwitchTime:[time integerValue] andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
}
-(void)diffentCell:(YXMineImageTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    kWeakSelf(self);
    cell.block = ^(YXMineImageTableViewCell * cell) {
        [weakself requestDianZanAction:cell];
    };
    cell.clickImageBlock = ^(NSInteger tag) {
        UIStoryboard * stroryBoard5 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
        YXMineViewController * mineVC = [stroryBoard5 instantiateViewControllerWithIdentifier:@"YXMineViewController"];
        mineVC.userId = kGetString(weakself.dataArray[tag][@"user_id"]);
        mineVC.whereCome = YES;
        [weakself.navigationController pushViewController:mineVC animated:YES];
    };
    //1(晒图数据)2(文章数据)
    switch (self.whereCome ?  [self.type integerValue] : [dic[@"obj"] integerValue]) {
        case 1:{
            cell.midImageView.hidden = NO;
            cell.midWebView.hidden = YES;

            NSURL * url = [NSURL URLWithString:self.dataArray[indexPath.row][@"photo1"]];
            [cell.midImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_moren"]];
        }
            break;
        case 2:{
            cell.midImageView.hidden = YES;
            cell.midWebView.hidden = NO;
            [cell.midWebView loadHTMLString:[ShareManager justFitImage:dic[@"essay"]] baseURL:nil];
        }
            break;
        default:
            break;
    }
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
