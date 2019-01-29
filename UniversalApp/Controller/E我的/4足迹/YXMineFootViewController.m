//
//  YXMineFootViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineFootViewController.h"

@interface YXMineFootViewController ()
@property(nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation YXMineFootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self requestZuJi];
}
-(void)requestZuJi{
    id obj = UserDefaultsGET(@"a2");
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@/%@",@"1",@"1",@"1"];
    [YX_MANAGER requestGetMy_Track_list:par success:^(id object) {
        UserDefaultsSET(object, @"a2");
        [weakself.dataSource removeAllObjects];
        [weakself.dataSource addObjectsFromArray:object];
//        [weakself.yxTableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
