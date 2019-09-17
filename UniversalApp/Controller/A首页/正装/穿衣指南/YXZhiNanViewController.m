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

@interface YXZhiNanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) YXZhiNanDetailHeaderView * headerView;
@property (nonatomic,assign) CGFloat contentHeight;
@property (nonatomic,strong) NSMutableArray * collArray;


@end

@implementation YXZhiNanViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self addRefreshView:self.yxTableView];
    [self requestZhiNanGet];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestZhiNanGet];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self.yxTableView.mj_footer endRefreshing];
}
-(void)requestZhiNanGet{
    [QMUITips showLoadingInView:self.view];
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"1/%@",self.startDic[@"id"]];
    [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
        if ([object count] == 0) {
            [QMUITips hideAllTipsInView:weakself.view];
            return;
        }
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"开始");
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            [weakself.collArray removeAllObjects];
        
            
                for (NSInteger i = 0; i < [object count]; i++) {
                    NSString * par1 = [NSString stringWithFormat:@"1/%@",object[i][@"id"]];
                        [YXPLUS_MANAGER requestZhiNan1Get:par1 success:^(id object) {
                            [weakself.collArray addObject:object];
                            if (weakself.dataArray.count == weakself.collArray.count) {
                                [weakself.yxTableView reloadData];
                                [weakself panduanUMXiaoXi];
                            }
                             dispatch_semaphore_signal(sema);
                            [QMUITips hideAllTipsInView:weakself.view];
                        }];
                    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                }
        });
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXZhiNanDetailHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    [self.headerView setHeaderViewData:self.startDic];
    /*
    _headerView.openBlock = ^(NSString * string) {
        if ([string isEqualToString:@"更多"]) {
            CGFloat h = [ShareManager inTextZhiNanOutHeight:weakself.startDic[@"intro"] lineSpace:9 fontSize:15];
            CGFloat th = h/4;
            weakself.contentHeight = h + th;
        }else{
            weakself.contentHeight = 56;
        }

        [weakself.yxTableView reloadData];
    };
     */
    return  self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 240;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.collArray.count > 0) {
        NSInteger n = [self.collArray[indexPath.row] count];
        return 40 * (n/2+n%2) + 80;
    }
    return 85;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXZhiNanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNanTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 1) {
        cell.yxCollectionView.backgroundColor = KWhiteColor;
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = 0;
    NSDictionary * dic = self.dataArray[indexPath.row];
    [cell setCellData:dic tagIndex:indexPath.row cellArray:self.collArray[indexPath.row]];
    
    
    kWeakSelf(self);
    //点击进入详情界面
    cell.clickCollectionItemBlock = ^(NSInteger smallIndex,NSInteger bigIndex) {
        YXZhiNanDetailViewController * vc = [[YXZhiNanDetailViewController alloc]init];
        vc.smallIndex = smallIndex;
        vc.bigIndex = bigIndex;
        vc.startArray = [[NSMutableArray alloc]initWithArray:weakself.dataArray];
        
        
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
-(void)panduanUMXiaoXi{
    if (self.umDic && self.umDic.count > 0) {
        kWeakSelf(self);
        YXZhiNanDetailViewController * vc = [[YXZhiNanDetailViewController alloc]init];
        for (NSInteger i = 0 ; i<self.dataArray.count; i++) {
            if ([self.dataArray[i][@"id"] integerValue] == [self.umDic[@"key3"] integerValue]) {
                vc.smallIndex = 0;
                vc.bigIndex = i;
                vc.startArray = [[NSMutableArray alloc]initWithArray:weakself.dataArray];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        }
    
    }
}
-(void)initTableView{
    _contentHeight = 56;
    self.dataArray = [[NSMutableArray alloc]init];
    self.collArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNanTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXZhiNanTableViewCell"];
}
-(IBAction)moreShare{
    [[ShareManager sharedShareManager] saveImage:self.yxTableView];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
@end
