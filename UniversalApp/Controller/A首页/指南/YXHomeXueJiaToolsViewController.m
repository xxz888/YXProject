//
//  YXHomeXueJiaToolsViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaToolsViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>
#import "YXHomeChiCunViewController.h"
#import "YXXingZhuangViewController.h"
#import "YXColorViewController.h"
#import "HGSegmentedPageViewController.h"
#import "YXHomeXueJiaToolsTableViewCell.h"
#import "YXZhiNanViewController.h"

@interface YXHomeXueJiaToolsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * titleArray;

@property (strong, nonatomic) UITableView *yxTableView;
@property (nonatomic,strong) UIView * view1;

@end

@implementation YXHomeXueJiaToolsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文化";
    [self tableviewCon];
    [self requestZhiNan1Get];
}
-(void)requestZhiNan1Get{
    kWeakSelf(self);
    [YXPLUS_MANAGER requestZhiNan1Get:@"1/0" success:^(id object) {
        [weakself.titleArray removeAllObjects];
        [weakself.titleArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}
#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    [self.navigationController.navigationBar setHidden:YES];
    
    self.titleArray = [[NSMutableArray alloc]init];
    self.yxTableView = [[UITableView alloc]init];
    self.yxTableView.frame = CGRectMake(0,0, KScreenWidth,self.view.frame.size.height-kTopHeight-kTabBarHeight);
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaToolsTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaToolsTableViewCell"];
    [self.view addSubview:self.yxTableView];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeXueJiaToolsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaToolsTableViewCell" forIndexPath:indexPath];
    
    NSDictionary * dic = self.titleArray[indexPath.row];
    NSString * str1 = [(NSMutableString *)dic[@"photo"] replaceAll:@" " target:@"%20"];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    
    cell.selectionStyle = 0;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXZhiNanViewController * vc1 = [[YXZhiNanViewController alloc]init];
    vc1.startDic = [NSDictionary dictionaryWithDictionary:self.titleArray[indexPath.row]];
    [self.navigationController pushViewController:vc1 animated:YES];
}

//- (HGSegmentedPageViewController *)segmentedPageViewController {
//    if (!_segmentedPageViewController) {
//        UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        yifuVC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeYiFuViewController"];
//
//        VC1 = [[YXColorViewController alloc]init];
//        VC2 = [[YXXingZhuangViewController alloc]init];
//        VC3 = [[YXHomeChiCunViewController alloc]init];
//
//
//        NSArray *titles = @[@"套装搭配",@"雪茄颜色",@"雪茄形状",@"尺寸工具"];
//        NSArray *controllers = @[yifuVC,VC1,VC2,VC3];
//
//        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
//        _segmentedPageViewController.pageViewControllers = controllers.copy;
//        _segmentedPageViewController.categoryView.titles = titles;
//        _segmentedPageViewController.categoryView.originalIndex = 0;
//    }
//    return _segmentedPageViewController;
//}


@end
