//
//  YXMineAllViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineAllViewController.h"
#import "YXXinDongTaiView.h"
#import "YXFaBuNewVCViewController.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineAllViewController (){
}
@property (nonatomic,strong) YXXinDongTaiView * dongtaiView;

@end

@implementation YXMineAllViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat height = user_id_BOOL  ? KScreenHeight  - kNavBarHeight - 27 : KScreenHeight  - kTabBarHeight - kStatusBarHeight - 50;
    self.yxTableView.frame = CGRectMake(0, 0, KScreenWidth, height);
 
    self.nodataImg.hidden = YES;
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSecondVC:) name:@"refreshSecondVC" object:nil];
}
- (void)dealloc {
    //单条移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshSecondVC" object:nil];
}
- (void)refreshSecondVC: (NSNotification *) notification {
    [self requestTableData];
}
-(UIView *)dongtaiView{
    if (!_dongtaiView) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXXinDongTaiView" owner:self options:nil];
        _dongtaiView = [nib objectAtIndex:0];
        _dongtaiView.frame = CGRectMake(16,16, 160, 160);
        [self.yxTableView addSubview:_dongtaiView];
        
        
        //添加点击手势
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
        //点击几次后触发事件响应，默认为：1
        click.numberOfTapsRequired = 1;
        [_dongtaiView addGestureRecognizer:click];
        _dongtaiView.userInteractionEnabled = YES;
    }
    return _dongtaiView;
}
-(void)clickAction:(id)click{
    YXFaBuNewVCViewController * contentViewController = [[YXFaBuNewVCViewController alloc] init];
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentViewMargins = UIEdgeInsetsMake(KScreenHeight-175-kTabBarHeight-10, KScreenWidth-146, kTabBarHeight+10, 0);
    modalViewController.contentViewController = contentViewController;
    [modalViewController showWithAnimated:YES completion:nil];
    
    contentViewController.block = ^{
        [modalViewController hideWithAnimated:YES completion:nil];
    };
}
-(void)requestTableData{
        kWeakSelf(self);
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           user_id_BOOL ? [self requestOther_AllList] : [self requestMine_AllList];
       });
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestTableData];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestTableData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestTableData];
}
#pragma mark ========== 我自己的所有 ==========
-(void)requestMine_AllList{
//    kWeakSelf(self);
//    [YX_MANAGER requestGetSersAllList:NSIntegerToNSString(self.requestPage) success:^(id object) {
//         weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
//        [weakself.yxTableView reloadData];
//    }];
    
    kWeakSelf(self);
    NSString * parString =[NSString stringWithFormat:@"0&page=%@",NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGet_users_find:parString success:^(id object){
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
        weakself.dongtaiView.hidden =  weakself.dataArray.count != 0;
//        weakself.nodataImg.hidden = weakself.dataArray.count != 0;
    }];
}
#pragma mark ========== 其他用户的所有 ==========
-(void)requestOther_AllList{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",self.userId,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGetSers_Other_AllList:par success:^(id object){
        weakself.dataArray =  [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZan_Image_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        [weakself requestTableData];
    }];
}
#pragma mark ========== 足迹点赞 ==========
-(void)requestDianZan_ZuJI_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* track_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestDianZanFoot:@{@"track_id":track_id} success:^(id object) {
        [weakself requestTableData];
    }];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat contentOffsetY = scrollView.contentOffset.y;
//    NSLog(@"%f",contentOffsetY);
//    scrollView.scrollEnabled = NO;
//}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    // 获取开始拖拽时tableview偏移量
//    CGFloat _oldY = self.yxTableView.contentOffset.y;
//    NSLog(@"%f",_oldY);
//
//}
@end
