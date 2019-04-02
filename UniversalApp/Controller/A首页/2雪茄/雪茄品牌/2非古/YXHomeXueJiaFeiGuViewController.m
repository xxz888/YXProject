//
//  YXHomeXueJiaFeiGuViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/24.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaFeiGuViewController.h"
#import "YXHomeCountryViewController.h"

#import "CBGroupAndStreamView.h"
@interface YXHomeXueJiaFeiGuViewController(){
    CBGroupAndStreamView * silde;
}
@end
@implementation YXHomeXueJiaFeiGuViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self pushCountyView];
}
-(void)pushCountyView{
    kWeakSelf(self);

    [YX_MANAGER requestGetCigar_brand_site:@"" success:^(id object) {
        
        NSArray * titleArr = @[@""];
        NSMutableArray *contentArr = [NSMutableArray array];
        
        for (NSDictionary * dic in object) {
            [contentArr addObject:dic[@"site"]];
        }
        silde = [[CBGroupAndStreamView alloc] initWithFrame:CGRectMake(5, 0, KScreenWidth-10, kScreenHeight-kTopHeight-kTabBarHeight)];
        silde.isSingle = YES;
        silde.radius = 5;
        silde.font = [UIFont systemFontOfSize:12];
        silde.titleTextFont = [UIFont systemFontOfSize:18];
        silde.norColor = A_COlOR;
        silde.contentNorColor = KWhiteColor;
        silde.selColor = A_COlOR;
        silde.contentSelColor = KWhiteColor;
        silde.maragin_x = 15;
        silde.maragin_y = 20;

        silde.butHeight = 30;
        
        [silde setContentView:@[contentArr] titleArr:titleArr];
        
        [weakself.view addSubview:silde];
        
        
        silde.cb_selectCurrentValueBlock = ^(NSString *value, NSInteger index, NSInteger groupId) {
            YXHomeCountryViewController * VC = [[YXHomeCountryViewController alloc]init];
            VC.cigar_id = kGetString(object[index][@"id"]);
            [weakself.navigationController pushViewController:VC animated:YES];
            
        };
    }];
  

}

@end
