//
//  YXMineMyDianZanViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineMyDianZanViewController.h"
#import "YXMineImageDetailViewController.h"
@interface YXMineMyDianZanViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation YXMineMyDianZanViewController

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:VC animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //其他方法
    [self setOtherAction];
}
-(void)setOtherAction{
    self.title = @"我的点赞";
    self.isShowLiftBack = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.yxTableView.frame = CGRectMake(0, kTopHeight, KScreenWidth, KScreenHeight - kTopHeight);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self requestFindTheType];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestFindTheType];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestFindTheType];
}
-(void)requestAction{
    [self requestFindTheType];
}
#pragma mark ========== 2222222-在请求具体tag下的请求,获取发现页标签数据全部接口 ==========
-(void)requestFindTheType{
    kWeakSelf(self);
    [YX_MANAGER requestMyDianZanList:NSIntegerToNSString(self.requestPage) success:^(id object) {
        if ([object count] > 0) {
            NSMutableArray *_dataSourceTemp=[NSMutableArray new];
            for (NSDictionary *company in object) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:company];
                [dic setObject:@"1" forKey:@"obj"];
                [_dataSourceTemp addObject:dic];
            }
            object=_dataSourceTemp;
            weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
            [weakself.yxTableView reloadData];
        }
    }];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
