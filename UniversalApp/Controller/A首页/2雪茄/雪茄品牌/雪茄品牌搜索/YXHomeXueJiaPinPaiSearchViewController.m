//
//  YXHomeXueJiaPinPaiSearchViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiSearchViewController.h"
#import "YXHomeXueJiaPinPaiDetailViewController.h"
#import "YXHomeXueJiaPinPaiLastDetailViewController.h"
@interface YXHomeXueJiaPinPaiSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YXHomeXueJiaPinPaiSearchViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavSearchView];
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.yxTableView.separatorStyle = 0;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self requestSearch];
[[[UIApplication sharedApplication] keyWindow] endEditing:YES];}
-(void)requestSearch{
    kWeakSelf(self);
    [YX_MANAGER requestSearchCigar_brand:@{@"key":self.searchHeaderView.searchBar.text,@"page":NSIntegerToNSString(self.requestPage)} success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSString * tag = self.dataArray[indexPath.row][@"cigar_brand"] ? self.dataArray[indexPath.row][@"cigar_brand"] : self.dataArray[indexPath.row][@"cigar_name"];
    cell.textLabel.text = tag;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray[indexPath.row][@"cigar_brand"]) {
        [self requestCigar_brand_details:kGetString(self.dataArray[indexPath.row][@"id"]) indexPath:indexPath isHot:NO];
    }else{
        [self requestDetail:self.dataArray[indexPath.row]];
    }
}
-(void)requestDetail:(NSDictionary *)dic{
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    YXHomeXueJiaPinPaiLastDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiLastDetailViewController"];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [VC.startDic setValue:dic[@"cigar_name"] forKey:@"cigar_brand"];
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)requestCigar_brand_details:(NSString *)cigar_brand_id indexPath:(NSIndexPath *)indexPath isHot:(BOOL)isHot{
    kWeakSelf(self);
    [YX_MANAGER requestCigar_brand_detailsPOST:@{@"cigar_brand_id":cigar_brand_id} success:^(id object) {
        UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
        YXHomeXueJiaPinPaiDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiDetailViewController"];
        VC.dicData = [NSMutableDictionary dictionaryWithDictionary:object];
        VC.dicStartData = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
        VC.whereCome = NO;
        
        [weakself.navigationController pushViewController:VC animated:YES];
    }];
}
@end
