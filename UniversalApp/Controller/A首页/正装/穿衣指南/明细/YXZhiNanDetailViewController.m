//
//  YXZhiNanDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNanDetailViewController.h"
#import "YXZhiNanDetailHeaderView.h"
#import "YXZhiNan1Cell.h"
#import "YXZhiNan2Cell.h"
#import "YXZhiNan3Cell.h"
#import "YXZhiNan4Cell.h"
#import "YXZhiNan5Cell.h"
#import "QiniuLoad.h"
#import "YXZhiNanPingLunViewController.h"
@interface YXZhiNanDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) YXZhiNanDetailHeaderView * headerView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) BOOL is_collect;
@property (weak, nonatomic) IBOutlet UILabel *plLbl;

@property (nonatomic,assign) CGFloat contentHeight;
@end

@implementation YXZhiNanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化UI
    [self setVCUI];
    [self requestZhiNanGet];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)headerRereshing{
    if (self.bigIndex == 0) {
        [self endRefresh];
    }else{
        self.bigIndex --;
        [self requestZhiNanGet];
    }
}
-(void)footerRereshing{
    if (self.bigIndex == [self.startArray count] - 1) {
        [self endRefresh];
    }else{
        self.bigIndex ++;
        [self requestZhiNanGet];
    }
}
-(void)endRefresh{
    [self.yxTableView.mj_header endRefreshing];
    [self.yxTableView.mj_footer endRefreshing];
}
-(void)requestZhiNanGet{
    kWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"开始");
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSArray * smallArray = [NSArray arrayWithArray:self.startArray[self.bigIndex]];
        [weakself.dataArray removeAllObjects];
        for (NSInteger i = 0; i < [smallArray count]; i++) {
            NSString * par = [NSString stringWithFormat:@"0/%@",smallArray[i][@"id"]];
            [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
                if ([object count] > 0) {
                    [weakself.dataArray addObject:object];
                    if (weakself.dataArray.count == smallArray.count) {
                        [weakself endRefresh];
                        [UIView transitionWithView:weakself.yxTableView
                                          duration:.5f
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:^{
                                            [weakself.yxTableView reloadData];
                                            [weakself.yxTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                                        } completion:^(BOOL finished) {}];
                       //[weakself panduanIsColl];
                    }
                }
                dispatch_semaphore_signal(sema);
                [QMUITips hideAllTipsInView:weakself.view];
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
    });
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.section][indexPath.row];
    NSInteger obj = [dic[@"obj"] integerValue];
    if (obj == 1) {
        return 90;
    }else if(obj == 2) {
        return  [YXZhiNan2Cell jisuanCellHeight:dic] + 30;
    }else if(obj == 3 || obj == 4) {
        return (KScreenWidth-30)*[dic[@"ratio"] doubleValue] + 30;
    }else if(obj == 5){
        return 80;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.section][indexPath.row];
    NSInteger obj = [dic[@"obj"] integerValue];
    if (obj == 1 ) {
        YXZhiNan1Cell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan1Cell" forIndexPath:indexPath];
        [cell1 setCellData:dic];
        return cell1;
    }else if(obj == 2) {
        YXZhiNan2Cell * cell2 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan2Cell" forIndexPath:indexPath];
        [cell2 setCellData:dic];
        return cell2;
    }else if(obj == 3) {
        YXZhiNan3Cell * cell3 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan3Cell" forIndexPath:indexPath];
        [cell3 setCellData:dic];
        return cell3;
    }else if(obj == 4) {
        YXZhiNan4Cell * cell4 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan4Cell" forIndexPath:indexPath];
        [cell4 setCellData:dic];
        return cell4;
    }else if (obj == 5) {
        YXZhiNan5Cell * cell5 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan5Cell" forIndexPath:indexPath];
        [cell5 setCellData:dic];
        return cell5;
    }
    return nil;
}
//初始化UI
-(void)setVCUI{
    [self addNavigationItemWithImageNames:@[@"更多"] isLeft:NO target:self action:@selector(moreShare) tags:@[@"999"]];
    self.view.backgroundColor = KWhiteColor;
    self.dataArray = [[NSMutableArray alloc]init];
    [self addRefreshView:self.yxTableView];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan1Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan1Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan2Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan2Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan3Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan3Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan4Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan4Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan5Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan5Cell"];
}
-(void)panduanIsColl{
    self.plLbl.text = kGetString(self.startArray[self.bigIndex][@"comment_number"]);
    if ([userManager loadUserInfo]) {
        self.is_collect = [self.startArray[self.bigIndex][@"is_collect"] integerValue] == 1;
        UIImage * likeImage = self.is_collect ? [UIImage imageNamed:@"收藏选择"] : [UIImage imageNamed:@"收藏未选择"] ;
        [self.collImgView setImage:likeImage];
    }
}
-(void)moreShare{
    [[ShareManager sharedShareManager] saveImage:self.yxTableView];
}
- (IBAction)bottomAction:(UIButton *)btn{
    switch (btn.tag) {
        case 1://收藏
            [self collectAction];
            break;
        case 2://评论
            [self pinglunAction];
            break;
        case 3://分享
            [self moreShare];
            break;
        default:
            break;
    }
}
-(void)pinglunAction{
    YXZhiNanPingLunViewController * vc = [[YXZhiNanPingLunViewController alloc]init];
    vc.startDic = [NSDictionary dictionaryWithDictionary:self.dataArray[self.bigIndex]];
    vc.startId = self.startArray[self.bigIndex][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)collectAction{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    kWeakSelf(self);
    NSString * tagId = @"";//kGetString(self.startArray[self.currentIndex][@"id"]);
    [YXPLUS_MANAGER requestCollect_optionGet:[@"3/" append:tagId] success:^(id object) {
        UIImage * likeImage = weakself.is_collect ? [UIImage imageNamed:@"收藏未选择"] : [UIImage imageNamed:@"收藏选择"] ;
        [weakself.collImgView setImage:likeImage];
        weakself.is_collect = !weakself.is_collect;
    }];
}
@end
