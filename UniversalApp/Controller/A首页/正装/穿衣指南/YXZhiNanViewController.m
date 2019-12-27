//
//  YXZhiNanViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/17.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNanViewController.h"
#import "YXZhiNanTableViewCell.h"
#import "YXZhiNanDetailViewController.h"
#import "YXZhiNanDetailHeaderView.h"
#import "QiniuLoad.h"
#import "YXZhiNanYaoQingJieSuoTableViewController.h"
#import "YXMineImageDetailViewController.h"
#import "YXFirstFindImageTableViewCell.h"
@interface YXZhiNanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) YXZhiNanDetailHeaderView * headerView;
@property (nonatomic,assign) CGFloat contentHeight;
@property (nonatomic,strong) NSMutableArray * collArray;


@end

@implementation YXZhiNanViewController
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //上滑
    if (scrollView.contentOffset.y < 80) {
        self.topView.backgroundColor = [KWhiteColor colorWithAlphaComponent:scrollView.contentOffset.y / 80];
        [self.backBtn setImage:IMAGE_NAMED(@"A黑色背景返回") forState:UIControlStateNormal];
        [self.moreBtn setImage:IMAGE_NAMED(@"B黑色背景横向更多") forState:UIControlStateNormal];
        self.fanhuiWidth.constant = self.moreWidth.constant = 32;
        self.titleLbl.hidden = YES;
    }else{
        [self.backBtn setImage:IMAGE_NAMED(@"A黑色返回") forState:UIControlStateNormal];
        [self.moreBtn setImage:IMAGE_NAMED(@"B黑色横向更多") forState:UIControlStateNormal];
        self.fanhuiWidth.constant = self.moreWidth.constant = 32;
        self.topView.backgroundColor = [KWhiteColor colorWithAlphaComponent:1];
        self.titleLbl.text = self.startDic[@"name"];
        self.titleLbl.hidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(jiesuochenggong:) name:@"jiesuochenggong" object:nil];
}
-(void)jiesuochenggong:(id)notice{
    [self requestZhiNanGet];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self addRefreshView:self.yxTableView];
//    [self requestZhiNanGet];
}
-(void)initTableView{
    _contentHeight = 56;
    self.fanhuiWidth.constant = self.moreWidth.constant = 32;
    //根据当前id找到所用的数组
    self.dataArray = [[NSMutableArray alloc]initWithArray:[YXPLUS_MANAGER inStartId2OutCurrentArray:self.startId]];
    self.collArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNanTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXZhiNanTableViewCell"];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestZhiNanGet];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self.yxTableView.mj_header endRefreshing];
    [self.yxTableView.mj_footer endRefreshing];
}
-(void)requestZhiNanGet{
    [QMUITips showLoadingInView:self.view];
    kWeakSelf(self);
    [YXPLUS_MANAGER getAllOptionArraySuccess:^{
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:[YXPLUS_MANAGER inStartId2OutCurrentArray:weakself.startId]];
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"weight" ascending:YES]];
        [weakself.dataArray sortUsingDescriptors:sortDescriptors];
        [weakself.yxTableView reloadData];
        [weakself.yxTableView.mj_header endRefreshing];
        [weakself.yxTableView.mj_footer endRefreshing];
    }];
    
    
    
    
//    NSString * par = [NSString stringWithFormat:@"1/%@",self.startDic[@"id"]];
//    [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
//        if ([object count] == 0) {
//            [QMUITips hideAllTipsInView:weakself.view];
//            return;
//        }
//
//
//        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
//        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"weight" ascending:YES]];
//        [weakself.dataArray sortUsingDescriptors:sortDescriptors];
//
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//            [weakself.collArray removeAllObjects];
//
//
//                for (NSInteger i = 0; i < [weakself.dataArray count]; i++) {
//                    NSString * par1 = [NSString stringWithFormat:@"1/%@",weakself.dataArray[i][@"id"]];
//                        [YXPLUS_MANAGER requestZhiNan1Get:par1 success:^(id object) {
//                            [weakself.collArray addObject:object];
//
//                            if (weakself.dataArray.count == weakself.collArray.count) {
//
//                                [weakself.yxTableView reloadData];
//                                [weakself panduanUMXiaoXi];
//                            }
//                             dispatch_semaphore_signal(sema);
//                            [QMUITips hideAllTipsInView:weakself.view];
//                        }];
//                    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//                }
//        });
//    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXZhiNanDetailHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    [self.headerView setHeaderViewData:[YXPLUS_MANAGER inStartId2OutCurrentDic:self.startId]];
    return  self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 300;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger collCount = [self.dataArray[indexPath.row][@"child_list"] count];
    if (collCount > 0) {
        return 44 * (collCount/2+collCount%2) + 80;
    }
    return 85;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXZhiNanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNanTableViewCell" forIndexPath:indexPath];
    [cell setCellData:self.dataArray[indexPath.row] :indexPath.row];
    //这里记录tag，是要得到点击item需要的哪个cell
    cell.tag = indexPath.row;
    kWeakSelf(self);
    //点击进入详情界面
    cell.clickCollectionItemBlock = ^(NSInteger smallIndex,NSInteger selectCellIndexRow) {
        //如果没有详情，说明这个item里面还没有写内容
        if ( weakself.dataArray[selectCellIndexRow][@"child_list"] == 0) {
            [QMUITips showInfo:@"暂无详情信息"];
            return;
        }
        //获取所选择的cell的item
        NSDictionary * itemDic = weakself.dataArray[selectCellIndexRow][@"child_list"][smallIndex];
        //smallindex 点击的哪个item
        YXZhiNanDetailViewController * vc = [[YXZhiNanDetailViewController alloc]init];
        //用作记录是哪个小item，用作滑动
        vc.selectItemIndex = smallIndex;
        vc.selectCellIndex = selectCellIndexRow;
        vc.firstSelectId   = weakself.startId;
        //用作记录上下滑动的id
        vc.selectCellArray = [NSArray arrayWithArray:weakself.dataArray];
        //这里判断是否锁了
        NSInteger is_lock =   [itemDic[@"is_lock"] integerValue];
        NSInteger user_lock = [itemDic[@"user_lock"] integerValue];
        //1代表锁了
        if (is_lock == 1) {
            if (user_lock == 0) {
                if (![userManager loadUserInfo]) {
                          KPostNotification(KNotificationLoginStateChange, @NO);
                          return;
                }
                NSString * title = @"蓝皮书,品位生活指南@蓝皮书app";
                NSString * desc = @"Ta开启了蓝皮书之旅,快来加入吧";
                [[ShareManager sharedShareManager] pushShareViewAndDic:
                 @{@"type":@"4",@"desc":desc,@"title":title,@"thumbImage":@"http://photo.lpszn.com/appiconWechatIMG1store_1024pt.png"}];
            }else{
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [weakself.navigationController pushViewController:vc animated:YES];
            return;
            if ([itemDic[@"ratio"] integerValue] == 99999) {
                  //这一步是先获取图片高度
                  NSDictionary * resultDic = [ShareManager stringToDic:itemDic[@"detail"]];
                  YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
                  CGFloat h = [YXFirstFindImageTableViewCell cellDefaultHeight:resultDic];
                  VC.headerViewHeight = h;
                  VC.startDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
                  [weakself.navigationController pushViewController:VC animated:YES];
            }else{
                 [weakself.navigationController pushViewController:vc animated:YES];
            }
         }
//                NSString * par = [NSString stringWithFormat:@"0/%@",weakself.dataArray[bigIndex][@"id"]];
//                [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
//                    NSInteger newsmallIndex = smallIndex;
//                    if ([object count] <= smallIndex) {
//                        newsmallIndex = [object count] - 1;
//                    }
//
//                   if ([object[newsmallIndex] count] > 0) {
//                          NSDictionary * dic = object[newsmallIndex][0];
//                                         if ([dic[@"ratio"] integerValue] == 99999) {
//                                               NSDictionary * resultDic = [ShareManager stringToDic:dic[@"detail"]];
//                                               YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
//                                               CGFloat h = [YXFirstFindImageTableViewCell cellDefaultHeight:resultDic];
//                                               VC.headerViewHeight = h;
//                                               VC.startDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
//                                               [weakself.navigationController pushViewController:VC animated:YES];
//                                         }else{
//                                             [weakself.navigationController pushViewController:vc animated:YES];
//                                         }
//                                      }else{
//                                          [QMUITips showInfo:@"暂无详情信息"];
//                                      }
//
//                }];
//        }
    };
    return cell;
}

-(void)panduanUMXiaoXi{
//    if (self.umDic && self.umDic.count > 0) {
//        kWeakSelf(self);
//        YXZhiNanDetailViewController * vc = [[YXZhiNanDetailViewController alloc]init];
//        for (NSInteger i = 0 ; i<self.dataArray.count; i++) {
//            if ([self.dataArray[i][@"id"] integerValue] == [self.umDic[@"key3"] integerValue]) {
//                vc.smallIndex = 0;
//                vc.bigIndex = i;
//                vc.startArray = [[NSMutableArray alloc]initWithArray:weakself.dataArray];
//                [weakself.navigationController pushViewController:vc animated:YES];
//            }
//        }
//    }
}

-(IBAction)moreShare{
    NSString * title = self.startDic[@"name"];
    NSString * desc = self.startDic[@"intro"];
    NSString * cid = self.startDic[@"id"];
    [[ShareManager sharedShareManager] pushShareViewAndDic:@{
        @"type":@"1",@"img":@"",@"desc":desc,@"title":title,@"id":cid,@"thumbImage":self.startDic[@"photo"],@"index":kGetNSInteger(self.index)}];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
@end
