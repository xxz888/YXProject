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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self requestZhiNanGet];
    [self addRefreshView:self.yxTableView];
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
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"1/%@",self.startDic[@"id"]];
    [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
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
                            }
                             dispatch_semaphore_signal(sema);
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
    kWeakSelf(self);
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
    return  self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200 + self.contentHeight + 25;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.collArray.count > 0) {
        NSInteger n = [self.collArray[indexPath.row] count];
        return 45 * (n/2+n%2) + 60;
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
    //block
    cell.clickCollectionItemBlock = ^(NSString * index) {
        YXZhiNanDetailViewController * vc = [[YXZhiNanDetailViewController alloc]init];
        vc.startArray = [[NSMutableArray alloc]init];
        for (NSInteger i=0; i<weakself.collArray.count; i++) {
            for (NSDictionary * dic in weakself.collArray[i]) {
                NSMutableDictionary * mDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                NSString * vcTitle = [NSString stringWithFormat:@"0%ld/%@",i+1,weakself.dataArray[i][@"name"]];
                [mDic setValue:vcTitle forKey:@"vcTitle"];
                [vc.startArray addObject:mDic];
            }
        }
     
        for (NSInteger i = 0; i<vc.startArray.count; i++) {
            NSDictionary * dic = vc.startArray[i];
            if ([dic[@"id"] integerValue] == [index integerValue]) {
                vc.startIndex = i;
            }
        }
        
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
-(void)initTableView{
    _contentHeight = 56;
    [self.navigationController.navigationBar setHidden:NO];
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
    YX_MANAGER.moreBool = NO;
}
@end
