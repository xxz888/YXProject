//
//  YXHomeSearchMoreViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeSearchMoreViewController.h"


@interface YXHomeSearchMoreViewController (){
    NSInteger page ;
    CBSegmentView * sliderSegmentView;
}
@property(nonatomic,strong)NSMutableArray * typeArray;
@property(nonatomic,strong)NSString * type;

@end

@implementation YXHomeSearchMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //其他方法
    [self setOtherAction];
}
-(void)setOtherAction{
    self.title = self.tag;
    self.isShowLiftBack = NO;
    self.typeArray = [[NSMutableArray alloc]init];
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

    [YX_MANAGER requestGetDetailListPOST:@{@"type":@(0),@"tag":self.tag,@"page":NSIntegerToNSString(self.requestPage)} success:^(id object) {
        if ([object count] > 0) {
            NSMutableArray *_dataSourceTemp=[NSMutableArray new];
            for (NSDictionary *company in object) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:company];
                [dic setObject:@"1" forKey:@"obj"];
                [_dataSourceTemp addObject:dic];
            }
            object=_dataSourceTemp;
        }
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
        [weakself.yxTableView scrollToRow:weakself.scrollIndex inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:nil];
    }];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
@end
