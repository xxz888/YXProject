//
//  YXFindViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//
#import "HXEasyCustomShareView.h"
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
#import "YXFindSearchViewController.h"
#import "YXFindSearchResultViewController.h"

@interface YXFindViewController ()<PYSearchViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSInteger page ;
    CBSegmentView * sliderSegmentView;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * typeArray;

@property(nonatomic,strong)NSString * type;
@end

@implementation YXFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
 
    //搜索栏
    [self setNavSearchView];
    self.navigationItem.rightBarButtonItem = nil;
    [self headerView];
    //创建tableview
    [self tableviewCon];
    
    [self requestFindTag];

     [self addRefreshView:self.yxTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.type = @"1";
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
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
-(void)headerView{
    kWeakSelf(self);
    sliderSegmentView = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, kTopHeight, KScreenWidth, 40)];
    sliderSegmentView.titleChooseReturn = ^(NSInteger x) {
        [weakself.dataArray removeAllObjects];
        weakself.type = weakself.typeArray[x];
        weakself.requestPage = 1;
        [weakself requestFindTheType];
    };
    [self.view addSubview:sliderSegmentView];
}
#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    self.dataArray = [[NSMutableArray alloc]init];
    self.typeArray = [[NSMutableArray alloc]init];
    self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight + 40, KScreenWidth, KScreenHeight - kTopHeight-TabBarHeight - 40) style:0];
    [self.view addSubview:self.yxTableView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    page = 1;
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
        [weakself.typeArray removeAllObjects];
        for (NSDictionary * dic in object) {
            [array addObject:dic[@"type"]];
            [weakself.typeArray addObject:dic[@"id"]];
        }
        weakself.type = weakself.typeArray[0];
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
    if (tag == 1 || tag == 4) {
        return 690;
    }else if (tag == 3){
        return 410;
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
        return [self customImageData:dic indexPath:indexPath whereCome:NO];
    }else if (tag == 3){
        return [self customQuestionData:dic indexPath:indexPath];
    }else if (tag == 4){
        return [self customImageData:dic indexPath:indexPath whereCome:YES];
    }else{
        return nil;
    }
}
#pragma mark ========== 图片 ==========
-(YXFindImageTableViewCell *)customImageData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath whereCome:(BOOL)whereCome{
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
    cell.shareblock = ^(YXFindImageTableViewCell * cell) {
        [weakself addGuanjiaShareView];
    };
    cell.jumpDetailVCBlock = ^(YXFindImageTableViewCell * cell) {
        NSIndexPath * indexPathSelect = [weakself.yxTableView indexPathForCell:cell];
        [weakself tableView:weakself.yxTableView didSelectRowAtIndexPath:indexPathSelect];
    };
    [cell setCellValue:dic whereCome:whereCome];
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
    cell.jumpDetail1VCBlock = ^(YXFindQuestionTableViewCell * cell) {
        NSIndexPath * indexPathSelect = [weakself.yxTableView indexPathForCell:cell];
        [weakself tableView:weakself.yxTableView didSelectRowAtIndexPath:indexPathSelect];
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
        moment.time = [dic[@"publish_time"] integerValue];
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

-(void)textField1TextChange:(UITextField *)tf{
    [self clickSearchBar];
}
- (void)clickSearchBar{
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    YXFindSearchViewController *searchViewController = [YXFindSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索", @"搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
 
        [searchViewController.navigationController pushViewController:[[YXFindSearchResultViewController alloc] init] animated:YES];
    }];
    searchViewController.hotSearchStyle = PYHotSearchStyleBorderTag;
    searchViewController.searchHistoryStyle = 1;
    searchViewController.delegate = self;
    RootNavigationController *nav2 = [[RootNavigationController alloc]initWithRootViewController:searchViewController];
    [self presentViewController:nav2 animated:YES completion:nil];
}





#pragma mark ========== 分享 ==========
- (void)addGuanjiaShareView {
    NSArray *shareAry = @[@{@"image":@"shareView_wx",
                            @"title":@"微信"},
                          @{@"image":@"shareView_friend",
                            @"title":@"朋友圈"},
                          @{@"image":@"shareView_wb",
                            @"title":@"新浪微博"},
                          @{@"image":@"shareView_rr",
                            @"title":@"其他"},
                          @{@"image":@"",
                            @"title":@""},
                          @{@"image":@"",
                            @"title":@""},
                          @{@"image":@"",
                            @"title":@""},
                          @{@"image":@"share_copyLink",
                            @"title":@"复制链接"},
                          @{@"image":@"share_copyLink",
                            @"title":@"删除"}];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 54)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, headerView.frame.size.width, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, headerView.frame.size.width, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [headerView addSubview:lineLabel];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 0.5)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    
    HXEasyCustomShareView *shareView = [[HXEasyCustomShareView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    shareView.headerView = headerView;
    float height = [shareView getBoderViewHeight:shareAry firstCount:7];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    shareView.middleLineLabel.hidden = YES;
    [shareView.cancleButton addSubview:lineLabel1];
    shareView.cancleButton.frame = CGRectMake(shareView.cancleButton.frame.origin.x, shareView.cancleButton.frame.origin.y, shareView.cancleButton.frame.size.width, 54);
    shareView.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [shareView.cancleButton setTitleColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    [shareView setShareAry:shareAry delegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    

}

#pragma mark HXEasyCustomShareViewDelegate

- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title {
    NSLog(@"当前点击:%@",title);
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self clickSearchBar];
    return YES;
}
@end
