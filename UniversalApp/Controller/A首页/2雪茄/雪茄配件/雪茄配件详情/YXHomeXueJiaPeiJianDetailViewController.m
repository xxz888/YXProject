//
//  YXHomeXueJiaPeiJianDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPeiJianDetailViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>
#import "YXHomeXueJiaPeiJianDetailTuiJianViewController.h"
@interface YXHomeXueJiaPeiJianDetailViewController (){
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC1;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC2;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC3;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC4;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC5;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC6;

}

@end

@implementation YXHomeXueJiaPeiJianDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.startDic[@"brand_name"];
    self.view.backgroundColor = KWhiteColor;

    kWeakSelf(self);
    [YX_MANAGER requestGetCigar_accessories_type:kGetString(self.startDic[@"id"]) success:^(id object) {
        
        
        UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
        
        NSMutableArray * names = [NSMutableArray array];
        NSMutableArray * controllers = [NSMutableArray array];

        for (NSDictionary * dic in object) {
            YXHomeXueJiaPeiJianDetailTuiJianViewController * VC = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
            VC.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
            VC.segIndex = kGetString(dic[@"id"]);
            [names addObject:kGetString(dic[@"type"])];
            [controllers addObject:VC];
        }
        [self setSegmentControllersArray:controllers title:names defaultIndex:0 top:kTopHeight view:self.view  ];
    }];
    
 
}


@end
