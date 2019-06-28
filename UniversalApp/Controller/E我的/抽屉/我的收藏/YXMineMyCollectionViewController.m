//
//  YXMineMyCollectionViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineMyCollectionViewController.h"
#import "YXMinePingLunViewController.h"
#import "YXMineMyCollectionTableViewCell.h"
#import "YXHomeXueJiaPinPaiLastDetailViewController.h"
#import "YXZhiNanViewController.h"
#import "YXZhiNanDetailViewController.h"
#import "BJNoDataView.h"

@interface YXMineMyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString * _sort;
}

@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YXMineMyCollectionViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self setInitTableView];
    _sort = @"0";
    [self addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionNew context:nil];

}
#pragma mark-----KVO回调----
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"dataArray"]) {
        return;
    }
    if ([self.dataArray count]==0) {//无数据
        [[BJNoDataView shareNoDataView] showCenterWithSuperView:self.yxTableView icon:nil iconClicked:^{
            //图片点击回调
            //[self loadData];//刷新数据
        }];
        return;
    }
    //有数据
    [[BJNoDataView shareNoDataView] clear];
}
-(void)dealloc{
    //移除KVO
    [self removeObserver:self forKeyPath:@"dataArray"];
}
-(void)requestMyCollectionListGet{
   kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",_sort,NSIntegerToNSString(self.requestPage)];
   [YX_MANAGER requestMyXueJia_CollectionListGet:par success:^(id object) {
       weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
       [weakself.yxTableView reloadData];
   }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self requestMyCollectionListGet];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineMyCollectionTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"YXMineMyCollectionTableViewCell" forIndexPath:indexPath];
    [cell setCellData:self.dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger sort = [dic[@"sort"] integerValue];
    if (sort == 1) {
        [self requestCigar:indexPath];
    }else if (sort == 2) {
        [self requestCigar_brand_details:kGetString(dic[@"target_id"]) indexPath:indexPath];
    }else if (sort == 3){
        if ([dic[@"detail"] count] > 0) {
            YXZhiNanDetailViewController * vc = [[YXZhiNanDetailViewController alloc]init];
            vc.smallIndex = 0;
            vc.bigIndex = 0;
            vc.startArray = [[NSMutableArray alloc] init];
            NSDictionary * dic4 =
            @{
                @"id":kGetString(dic[@"target_id"]),
                @"father_id":@"0",
                @"intro":dic[@"intro"],
                @"heat":@"0",
                @"is_collect":@"1",
                @"photo_detail":dic[@"photo_detail"],
                @"collect_number":kGetString(dic[@"collect_number"]),
                @"weight":@"0",
                @"comment_number":kGetString(dic[@"comment_number"]),
                @"is_next":@"",
                @"name":dic[@"name"],
                @"photo":@"",
            };
            [vc.startArray addObject:dic4];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            YXZhiNanViewController * vc = [[YXZhiNanViewController alloc]init];
            NSDictionary * dic3 =
            @{
              @"is_collect":@"1",
              @"father_id":kGetString(dic[@"id"]),
              @"id":kGetString(dic[@"target_id"]),
              @"intro":dic[@"intro"],
              @"photo":@"",
              @"is_next":@YES,
              @"name":dic[@"name"],
              @"photo_detail":dic[@"photo_detail"]
              };
            vc.startDic = [NSDictionary dictionaryWithDictionary:dic3];
            [self.navigationController pushViewController:vc animated:YES];
        }
 
    }
}

-(void)requestCigar:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    YXHomeXueJiaPinPaiLastDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiLastDetailViewController"];
    NSDictionary * dic = self.dataArray[indexPath.row];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"detail"]];
    VC.PeiJianOrPinPai = NO;
    //请求六宫格图片
    NSString * tag = VC.startDic[@"cigar_name"];
    [YX_MANAGER requestGetDetailListPOST:@{@"type":@(0),@"tag":tag,@"page":@(1)} success:^(id object) {
        NSMutableArray * imageArray = [NSMutableArray array];
        for (NSDictionary * dic in object) {
            [imageArray addObject:dic[@"photo1"]];
        }
        [VC.startDic setValue:weakself.title forKey:@"cigar_brand"];
        VC.imageArray = [NSMutableArray arrayWithArray:imageArray];
        [weakself.navigationController pushViewController:VC animated:YES];
        
    }];
}

-(void)requestCigar_brand_details:(NSString *)cigar_brand_id indexPath:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    [YX_MANAGER requestCigar_brand_detailsPOST:@{@"cigar_brand_id":@([cigar_brand_id intValue])} success:^(id object) {
        UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
        YXHomeXueJiaPinPaiDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiDetailViewController"];
        NSDictionary * dic = weakself.dataArray[indexPath.row];
        VC.dicData = [NSMutableDictionary dictionaryWithDictionary:object];
        VC.dicStartData = [NSMutableDictionary dictionaryWithDictionary:dic[@"detail"]];
        VC.whereCome = NO;
        [weakself.navigationController pushViewController:VC animated:YES];
    }];
}
-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    kWeakSelf(self);
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSDictionary * dic = self.dataArray[indexPath.row];
        [weakself delSort:kGetString(dic[@"sort"]) xxzId:kGetString(dic[@"target_id"])];
        [weakself.dataArray removeObjectAtIndex:indexPath.row];
        [weakself.yxTableView reloadData];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestMyCollectionListGet];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestMyCollectionListGet];
}
-(void)setInitTableView{
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineMyCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineMyCollectionTableViewCell"];
    [self addRefreshView:self.yxTableView];
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxTableView.tableFooterView = [[UIView alloc]init];
    ViewRadius(self.btn1, 5);
    ViewRadius(self.btn2, 5);
    ViewRadius(self.btn3, 5);
    ViewRadius(self.btn4, 5);
}
- (IBAction)btnAction:(UIButton *)sender {
    UIColor * selColor = YXRGBAColor(12,36,45);
    UIColor * nolColor = YXRGBAColor(193,193,193);
    
    _sort = NSIntegerToNSString(sender.tag == 1 ? 3 : sender.tag == 3 ? 1 : sender.tag);
    [self requestMyCollectionListGet];
    
    switch (sender.tag) {
        case 0:{
            self.btn1.backgroundColor = selColor;
            self.btn2.backgroundColor = self.btn3.backgroundColor = self.btn4.backgroundColor  = nolColor;
        }
            break;
        case 1:{
            self.btn2.backgroundColor = selColor;
            self.btn1.backgroundColor = self.btn3.backgroundColor = self.btn4.backgroundColor  = nolColor;
        }
            break;
        case 2:{
            self.btn3.backgroundColor = selColor;
            self.btn1.backgroundColor = self.btn2.backgroundColor = self.btn4.backgroundColor  = nolColor;
        }
            break;
        case 3:{
            self.btn4.backgroundColor = selColor;
            self.btn1.backgroundColor = self.btn2.backgroundColor = self.btn3.backgroundColor  = nolColor;
        }
            break;
        default:
            break;
    }
    
}

#pragma mark ========== 点赞按钮 ==========
-(void)delSort:(NSString *)sort xxzId:(NSString *)xxzId{
    NSString * par = [NSString stringWithFormat:@"%@/%@",sort,xxzId];
    [YXPLUS_MANAGER requestCollect_optionGet:par success:^(id object) {}];
}
@end
