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
#import "YXHomeXueJiaQuestionDetailViewController.h"
#import "Moment.h"
#import "Comment.h"
#import "YXMineFootDetailViewController.h"

@interface YXFindViewController ()<PYSearchViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSInteger page ;
    CBSegmentView * sliderSegmentView;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSString * type;
@end

@implementation YXFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //搜索栏
    [self setNavSearchView];
    //创建tableview
    [self tableviewCon];
    
    [self requestFindTag];

     [self addRefreshView:self.yxTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestFindTheType];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestFindTheType];
}
#pragma mark ========== headerview ==========
-(UIView *)headerView{
    kWeakSelf(self);
    sliderSegmentView = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    sliderSegmentView.titleChooseReturn = ^(NSInteger x) {
        weakself.type = NSIntegerToNSString(x+1);
        [weakself requestFindTheType];
    };
    return sliderSegmentView;
}
#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationContentTop, KScreenWidth, KScreenHeight - NavigationContentTop) style:0];
    [self.view addSubview:self.yxTableView];
    self.yxTableView.tableHeaderView = [self headerView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    page = 1;
    _type = @"1";
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
    NSString * parString =[NSString stringWithFormat:@"%@/%@",self.type,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGet_users_find:parString success:^(id object){
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}








































#pragma mark ========== tableview代理方法 ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    if (tag == 1) {
        return 600;
    }else if (tag == 3){
        return 390;
    }else if(tag == 4){
        return 550;
    }else{
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    if (tag == 1) {
        return [self customImageData:dic indexPath:indexPath];
    }else if (tag == 3){
        return [self customQuestionData:dic indexPath:indexPath];
    }else if (tag == 4){
        return [self cunstomFootData:dic indexPath:indexPath];
    }else{
        return nil;
    }
}
#pragma mark ========== 图片 ==========
-(YXFindImageTableViewCell *)customImageData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFindImageTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindImageTableViewCell" forIndexPath:indexPath];
    cell.titleImageView.tag = indexPath.row;
    kWeakSelf(self);
    cell.clickImageBlock = ^(NSInteger tag) {
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    cell.zanblock = ^(YXFindImageTableViewCell * cell) {
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        [weakself requestDianZan_Image_Action:indexPath1];
    };
    [cell setCellValue:dic];
    return cell;
}
#pragma mark ========== 问答 ==========
-(YXFindQuestionTableViewCell *)customQuestionData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFindQuestionTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindQuestionTableViewCell" forIndexPath:indexPath];
    cell.titleImageView.tag = indexPath.row;
    kWeakSelf(self);
    cell.clickImageBlock = ^(NSInteger tag) {
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    [cell setCellValue:dic];
    return cell;
}
#pragma mark ========== 足迹 ==========
-(YXFindFootTableViewCell *)cunstomFootData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFindFootTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindFootTableViewCell" forIndexPath:indexPath];
    cell.titleImageView.tag = indexPath.row;
    [cell setCellValue:dic];

    kWeakSelf(self);
    cell.clickImageBlock = ^(NSInteger tag) {
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    cell.jumpDetailVC = ^(YXFindFootTableViewCell * cell) {
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        [weakself commonDidVC:indexPath1];
    };
    cell.zanblock = ^(YXFindFootTableViewCell * cell) {
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        [weakself requestDianZan_ZuJI_Action:indexPath1];
    };
    return cell;
}
-(void)commonDidVC:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    YXMineFootDetailViewController * VC = [[YXMineFootDetailViewController alloc]init];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    YX_MANAGER.isHaveIcon = NO;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 点击头像 ==========
-(void)clickUserImageView:(NSString *)userId{
    UIStoryboard * stroryBoard5 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    YXMineViewController * mineVC = [stroryBoard5 instantiateViewControllerWithIdentifier:@"YXMineViewController"];
    mineVC.userId = userId;
    mineVC.whereCome = YES;    //  YES为其他人 NO为自己
    [self.navigationController pushViewController:mineVC animated:YES];
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZan_Image_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        [weakself requestFindTheType];
    }];
}
#pragma mark ========== 足迹点赞 ==========
-(void)requestDianZan_ZuJI_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* track_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestDianZanFoot:@{@"track_id":track_id} success:^(id object) {
        [weakself requestFindTheType];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    if (tag == 1) {//晒图
        YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        YX_MANAGER.isHaveIcon = NO;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 2){//文章
        YX_MANAGER.isHaveIcon = NO;
        YXMineEssayDetailViewController * VC = [[YXMineEssayDetailViewController alloc]init];
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 3){//问答
        UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
        YXHomeXueJiaQuestionDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaQuestionDetailViewController"];
        VC.moment = [self setTestInfo:dic];
        YX_MANAGER.isHaveIcon = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 4){//足迹
        [self commonDidVC:indexPath];
    }
}

-(Moment *)setTestInfo:(NSDictionary *)dic{
        NSMutableArray *commentList = nil;
        Moment *moment = [[Moment alloc] init];
        moment.praiseNameList = nil;
        moment.userName = dic[@"user_name"];
        moment.text = dic[@"title"];
        moment.time = [dic[@"publish_date"] longLongValue];
        moment.singleWidth = 500;
        moment.singleHeight = 315;
        moment.location = @"";
        moment.isPraise = NO;
        moment.photo =dic[@"user_photo"];
        moment.startId = dic[@"id"];
        moment.fileCount = 3;
        moment.imageListArray = [NSMutableArray arrayWithObjects:
                                 dic[@"pic1"],
                                 dic[@"pic2"],
                                 dic[@"pic3"], nil];
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
@end
