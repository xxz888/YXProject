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

#import "YXFindImageTableViewCell.h"
#import "YXFindQuestionTableViewCell.h"
#import "YXFindFootTableViewCell.h"

@interface YXFindViewController ()<PYSearchViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
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
    //滑动条
    [self.view addSubview: [self headerView]];
    //创建tableview
    [self tableviewCon];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setViewData];
}
#pragma mark ========== headerview ==========
-(UIView *)headerView{
    kWeakSelf(self);
    sliderSegmentView = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 40)];
    sliderSegmentView.titleChooseReturn = ^(NSInteger x) {
        weakself.type = NSIntegerToNSString(x+1);
        [weakself requestFindTheType];
    };
    return sliderSegmentView;
}
#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 40, KScreenWidth, KScreenHeight - 104) style:0];
    [self.view addSubview:self.yxTableView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    page = 1;
    _type = @"1";
    self.dataArray = [[NSMutableArray alloc]init];
    
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindImageTableViewCell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindQuestionTableViewCell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindFootTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindFootTableViewCell"];
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZanAction:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object){
        [weakself requestFindTheType];
    }];
}
-(void)setViewData{
    [self requestFindTag];
}


#pragma mark ========== 1111111-先请求tag列表,获取发现页标签数据 ==========
-(void)requestFindTag{
    kWeakSelf(self);
    NSMutableArray * array = [[NSMutableArray alloc]init];
    [YX_MANAGER requestGet_users_find_tag:@"" success:^(id object) {
        for (NSDictionary * dic in object) {
            [array addObject:dic[@"type"]];
        }
       [sliderSegmentView setTitleArray:array withStyle:CBSegmentStyleSlider];
       [weakself requestFindTheType];
    }];
}
#pragma mark ========== 2222222-在请求具体tag下的请求,获取发现页标签数据全部接口 ==========
-(void)requestFindTheType{
    kWeakSelf(self);
    NSString * parString =[NSString stringWithFormat:@"%@/%@",self.type,@"1"];
    [YX_MANAGER requestGet_users_find:parString success:^(id object){
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}








































#pragma mark ========== tableview代理方法 ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  335;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"object"] integerValue];
    //1图片 2问答 3足迹
    switch (tag) {
        case 1:
            return [self customImageData:dic indexPath:indexPath];
        case 2:
            return [self customQuestionData:dic indexPath:indexPath];
        case 3:
            return [self cunstomFootData:dic indexPath:indexPath];
        default:
            return nil;
    }
}
#pragma mark ========== 图片 ==========
-(YXFindImageTableViewCell *)customImageData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFindImageTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindImageTableViewCell" forIndexPath:indexPath];
    return cell;
}
#pragma mark ========== 问答 ==========
-(YXFindQuestionTableViewCell *)customQuestionData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFindQuestionTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindQuestionTableViewCell" forIndexPath:indexPath];
    return cell;
}
#pragma mark ========== 足迹 ==========
-(YXFindFootTableViewCell *)cunstomFootData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFindFootTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindFootTableViewCell" forIndexPath:indexPath];
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    YX_MANAGER.isHaveIcon = NO;
    YXMineEssayDetailViewController * VC = [[YXMineEssayDetailViewController alloc]init];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 文章tableview ==========
-(void)customWenZhangCell:(YXMineEssayTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    kWeakSelf(self);
    cell.block = ^(YXMineEssayTableViewCell * cell) {
        NSIndexPath * indexPath = [weakself.yxTableView indexPathForCell:cell];
        [weakself requestDianZanAction:indexPath];
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
