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
@interface YXHomeXueJiaQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate>
@property (nonatomic, strong) NSMutableArray *momentList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *picArray;

@end

@implementation YXHomeXueJiaQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //搜索栏
    [self setNavSearchView];
    self.dataArray = [[NSMutableArray alloc]init];
    self.picArray = [[NSMutableArray alloc]init];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
//    [self initTestInfo];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
   
    [self requestQuestion];
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



- (void)clickSearchBar
{
    // 1. Create an Array of popular search
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"PYExampleSearchPlaceholderText", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        [searchViewController.navigationController pushViewController:[[PYTempViewController alloc] init] animated:YES];
    }];
    // 3. Set style for popular search and search history
    
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoryStyle = 1;
    
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present(Modal) or push search view controller
    // Present(Modal)
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    //    [self presentViewController:nav animated:YES completion:nil];
    // Push
    // Set mode of show search view controller, default is `PYSearchViewControllerShowModeModal`
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    //    // Push search view controller
    [self.navigationController pushViewController:searchViewController animated:YES];
}
-(void)requestQuestion{
    
//    [self.dataArray removeAllObjects];
//    [self.dataArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"aaabbb1"]];
//    [self initTestInfo];
//    [self.tableView reloadData];
//    return;
    
    
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/kw/%@",@"1",@"1"];
    [YX_MANAGER requestQuestionGET:par success:^(id object) {
        [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"aaabbb1"];
        
        
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
 
        [weakself initTestInfo];
        [weakself.tableView reloadData];
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



#pragma mark - 测试数据
#pragma mark - 测试数据
- (void)initTestInfo
{
    self.momentList = [[NSMutableArray alloc] init];
    NSMutableArray *commentList = nil;
    for (int i = 0;  i < self.dataArray.count; i ++)  {
        
        //最外层
        Moment *moment = [[Moment alloc] init];
        moment.commentList = commentList;
        moment.praiseNameList = nil;//@"胡一菲，唐悠悠，陈美嘉，吕小布，曾小贤，张伟，关谷神奇";
        moment.userName = self.dataArray[i][@"user_name"];
        moment.text = self.dataArray[i][@"title"];
        moment.time = [self.dataArray[i][@"publish_date"] longLongValue];
        moment.singleWidth = 500;
        moment.singleHeight = 315;
        moment.location = @"";
        moment.isPraise = NO;
        moment.photo =self.dataArray[i][@"user_photo"];
        NSString * pic1 = kGetString(self.dataArray[i][@"pic1"]);
        NSString * pic2 = kGetString(self.dataArray[i][@"pic2"]);
        NSString * pic3 = kGetString(self.dataArray[i][@"pic3"]);

//        if ([pic1 isEqualToString:@""] || [pic1 isEqualToString:@"1"]) {
//            moment.fileCount = 0;
//        }else if ([pic2 isEqualToString:@""] || [pic2 isEqualToString:@"0"]){
//            moment.fileCount = 1;
//        }else if ([pic3 isEqualToString:@""] || [pic3 isEqualToString:@"0"]){
//            moment.fileCount = 2;
//        }else{
            moment.fileCount = 3;
//        }
      
  

        moment.imageListArray = [NSMutableArray arrayWithObjects:
                                 self.dataArray[i][@"pic1"],
                                 self.dataArray[i][@"pic2"],
                                 self.dataArray[i][@"pic3"], nil];
        
        // 评论
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
        

        
        /*
        if (i == 5) {
            moment.commentList = nil;
            moment.praiseNameList = nil;
            moment.text = @"蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，18107891687主要指以四川成都为中心的川西平原一带的刺绣。😁蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。😁蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，https://www.baidu.com，主要指以四川成都为中心的川西平原一带的刺绣。蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。";
            moment.fileCount = 1;
        } else if (i == 1) {
            moment.text = @"天界大乱，九州屠戮，当初被推下地狱的她已经浴火归来 😭😭剑指仙界'你们杀了他，我便覆了你的天，毁了你的界，永世不得超生又如何！'👍👍 ";
            moment.fileCount = arc4random()%10;
            moment.praiseNameList = nil;
        } else if (i == 2) {
            moment.fileCount = 9;
        } else {
            moment.text = @"天界大乱，九州屠戮，当初被推下地狱cheerylau@126.com的她已经浴火归来，😭😭剑指仙界'你们杀了他，我便覆了你的天，毁了你的界，永世不得超生又如何！'👍👍";
            moment.fileCount = arc4random()%10;
        }*/
        [self.momentList addObject:moment];
    }
}
#pragma mark - UI
- (void)setUpUI
{
    // 表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, k_screen_width, k_screen_height-k_top_height)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
//    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.dataSource = self;
    tableView.delegate = self;
//    tableView.estimatedRowHeight = 0;
//    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = self.tableHeaderView;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}
// 查看全文/收起
- (void)didSelectFullText:(MomentCell *)cell
{
    NSLog(@"全文/收起");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
//    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
//    MomentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.menuView.show = NO;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
