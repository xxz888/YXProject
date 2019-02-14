//
//  YXHomeXueJiaQuestionViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaQuestionViewController.h"
#import "MomentCell.h"
#import "Moment.h"
#import "Comment.h"
#import "MLLabel.h"
#import <MLLinkLabel.h>
#import "PYSearchViewController.h"
#import "PYTempViewController.h"
#import "YXHomeXueJiaQuestionDetailViewController.h"
#import "YXHomeQuestionFaBuViewController.h"

@interface YXHomeXueJiaQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate>
@property (nonatomic, strong) NSMutableArray *momentList;
@property (nonatomic, strong) UITableView * yxTableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *picArray;

@end

@implementation YXHomeXueJiaQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问答";
    //搜索栏
//    [self setNavSearchView];
    self.dataArray = [[NSMutableArray alloc]init];
    self.picArray = [[NSMutableArray alloc]init];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    
    [self addRefreshView:self.yxTableView];
    [self requestQuestion];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
   
}

#pragma mark ==========  搜索相关 ==========
-(void)setNavSearchView{
    UIColor *color =  YXRGBAColor(217, 217, 217);
    UITextField * searchBar = [[UITextField alloc] init];
    searchBar.frame = CGRectMake(-10, 0, KScreenWidth, 40);
    ViewBorderRadius(searchBar, 1, 1, color);
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(searchBar.py_size.width-60, 0, 25, 25);
    btn.centerY = searchBar.centerY;
    [btn setBackgroundImage:[UIImage imageNamed:@"放大镜"] forState:UIControlStateNormal];
    [searchBar addSubview:btn];
    [searchBar addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingDidBegin];
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = searchBar;
    
    
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = color;
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    searchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:attrs];
    
    CGRect frame = searchBar.frame;
    frame.size.width = 10;// 距离左侧的距离
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.leftView = leftview;
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
-(void)headerRereshing{
    [super headerRereshing];
    [self requestQuestion];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestQuestion];

}
-(void)requestQuestion{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/kw/%@",self.whereCome,   NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestQuestionGET:par success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself initTestInfo];
        [weakself.yxTableView reloadData];
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)initTestInfo{
    self.momentList = [[NSMutableArray alloc] init];
    NSMutableArray *commentList = nil;
    for (int i = 0;  i < self.dataArray.count; i ++)  {
        //最外层
        Moment *moment = [[Moment alloc] init];
        moment.praiseNameList = nil;//@"胡一菲，唐悠悠，陈美嘉，吕小布，曾小贤，张伟，关谷神奇";
        moment.userName = self.dataArray[i][@"user_name"];
        moment.text = self.dataArray[i][@"title"];
        moment.time = [self.dataArray[i][@"publish_time"] integerValue];
        moment.singleWidth = 500;
        moment.singleHeight = 315;
        moment.location = @"";
        moment.isPraise = NO;
        moment.photo =self.dataArray[i][@"user_photo"];
        moment.startId = self.dataArray[i][@"id"];
        moment.fileCount = 3;
        moment.imageListArray = [NSMutableArray arrayWithObjects:
                                 self.dataArray[i][@"pic1"],
                                 self.dataArray[i][@"pic2"],
                                 self.dataArray[i][@"pic3"], nil];
        commentList = [[NSMutableArray alloc] init];
        int num = (int)[self.dataArray[i][@"answer"] count];
        for (int j = 0; j < num; j ++) {
            Comment *comment = [[Comment alloc] init];
            comment.userName = self.dataArray[i][@"answer"][j][@"user_name"];
            comment.text =  self.dataArray[i][@"answer"][j][@"answer"];
            comment.time = 1487649503;
            comment.pk = j;
            [commentList addObject:comment];
        }
        [moment setValue:commentList forKey:@"commentList"];
        [self.momentList addObject:moment];
    }
}
#pragma mark - UI
- (void)setUpUI{
    // 表格
    self.yxTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, k_screen_width, k_screen_height-kTopHeight-TabBarHeight)];
    self.yxTableView.backgroundColor = [UIColor clearColor];
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    self.yxTableView.dataSource = self;
    self.yxTableView.delegate = self;
    self.yxTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.yxTableView];
}
// 查看全文/收起
- (void)didSelectFullText:(MomentCell *)cell
{
    NSLog(@"全文/收起");
    NSIndexPath *indexPath = [self.yxTableView indexPathForCell:cell];
    [self.yxTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.momentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MomentCell";
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.moment = [self.momentList objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    YXHomeXueJiaQuestionDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaQuestionDetailViewController"];
    VC.moment = self.momentList[indexPath.row];
    YX_MANAGER.isHaveIcon = YES;
    [self.navigationController pushViewController:VC animated:YES];

    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 使用缓存行高，避免计算多次
    Moment *moment = [self.momentList objectAtIndex:indexPath.row];
    return moment.rowHeight;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSIndexPath *indexPath =  [self.yxTableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
//    MomentCell *cell = [self.yxTableView cellForRowAtIndexPath:indexPath];
//    cell.menuView.show = NO;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)tiwenAction:(id)sender {
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    YXHomeQuestionFaBuViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeQuestionFaBuViewController"];
    VC.whereCome = self.whereCome;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
