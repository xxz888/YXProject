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

@interface YXZhiNanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) YXZhiNanDetailHeaderView * headerView;
@property (nonatomic,assign) CGFloat contentHeight;
@property (nonatomic,strong) NSMutableArray * collArray;


@end

@implementation YXZhiNanViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
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
    if (!_headerView) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXZhiNanDetailHeaderView" owner:self options:nil];
        _headerView = [nib objectAtIndex:0];
    }
    [_headerView setHeaderViewData:self.startDic];
    kWeakSelf(self);
    _headerView.backVCBlock = ^{
        
    };
    _headerView.openBlock = ^(void) {
        
    };
    return _headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KScreenWidth * 9/16 + self.contentHeight + 15;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.collArray.count > 0) {
        if ([self.collArray[indexPath.row] count] == 3) {
            return 161;
        }
    }
    return 101;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXZhiNanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNanTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 1) {
        cell.yxCollectionView.backgroundColor = KWhiteColor;
    }
    cell.selectionStyle = 0;
    NSDictionary * dic = self.dataArray[indexPath.row];
    [cell setCellData:dic tagIndex:indexPath.row cellArray:self.collArray[indexPath.row]];
    
    
    kWeakSelf(self);
    //block
    cell.clickCollectionItemBlock = ^(NSDictionary * dic) {
        YXZhiNanDetailViewController * vc = [[YXZhiNanDetailViewController alloc]init];
        vc.startDic = [NSDictionary dictionaryWithDictionary:dic];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    
    
    return cell;
}
-(void)initTableView{
    _contentHeight = [ShareManager inTextZhiNanOutHeight:self.startDic[@"intro"] lineSpace:9 fontSize:15];
    [self.navigationController.navigationBar setHidden:NO];
    self.dataArray = [[NSMutableArray alloc]init];
    self.collArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNanTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXZhiNanTableViewCell"];
    
}
@end
