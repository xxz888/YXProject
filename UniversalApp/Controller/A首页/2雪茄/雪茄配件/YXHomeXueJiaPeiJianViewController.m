//
//  YXHomeXueJiaPeiJianViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPeiJianViewController.h"
#import "QMUIGridView.h"
#import "YXHomeXueJiaPeiJianDetailViewController.h"
#import "YXHomeXueJiaTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "YXHeaderView1.h"

@interface YXHomeXueJiaPeiJianViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic, strong) QMUIGridView *gridView;
@property(nonatomic, strong) NSMutableArray * dataArray;
@property(nonatomic, strong) NSMutableArray * cellDataArray;

@end

@implementation YXHomeXueJiaPeiJianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"配件";
    self.dataArray = [[NSMutableArray alloc]init];
    self.cellDataArray = [[NSMutableArray alloc]init];
    self.yxTableView.delegate= self;
    self.yxTableView.dataSource=self;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaTableViewCell"];
    self.yxTableView.tableFooterView = [[UIView alloc]init];
    
    kWeakSelf(self);
    [YX_MANAGER requestCigar_accessories_CbrandGET:@"" success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself createMiddleCollection];
    }];
    
    [YX_MANAGER requestCigar_accessories_cultureGET:@"1" success:^(id object) {
        [weakself.cellDataArray removeAllObjects];
        [weakself.cellDataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

//九宫格
- (void)createMiddleCollection{
    [self.yxTableView.tableHeaderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!self.gridView) {
        self.gridView = [[QMUIGridView alloc] init];
    }
    float height = 120;
    NSInteger count = [self.dataArray count];
    if (count < 3) {
        height = 120;
    }else if (count >= 3 && count < 5){
        height = 120 * 2;
    }else if (count > 5 && count < 7){
        height = 120 * 3;
    }else if (count > 7 && count < 9){
        height = 120 * 4;
    }
    self.gridView.frame = CGRectMake(0, 0, KScreenWidth, height);
    
    self.gridView.columnCount = 2;
    self.gridView.rowHeight = 120;
    self.gridView.separatorWidth = PixelOne;
    self.gridView.separatorColor = UIColorClear;
    self.gridView.separatorDashed = YES;
    self.yxTableView.tableHeaderView = self.gridView;
    UIView * lineView = [[UIView alloc]init];
    lineView.sd_layout.leftSpaceToView(self.yxTableView.tableHeaderView, 0)
    .rightSpaceToView(self.yxTableView.tableHeaderView, 0)
    .centerYIs(self.yxTableView.tableHeaderView.centerY)
    .topEqualToView(self.yxTableView.tableHeaderView)
    .heightIs(5);
//    [self.yxTableView.tableHeaderView addSubview:lineView];
    for (NSInteger i = 0; i < [self.dataArray count]; i++) {
        
        
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHeaderView1" owner:self options:nil];
        YXHeaderView1 * headerView1 = [nib objectAtIndex:0];
        NSString * str = [(NSMutableString *)self.dataArray[i][@"brand_logo"] replaceAll:@" " target:@"%20"];

        [headerView1.titleImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        headerView1.titleImageView.tag = i;
        headerView1.titleLbl.text = self.dataArray[i][@"brand_name"];
        [self.gridView addSubview:headerView1];
        //view添加点击事件
        headerView1.titleImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [headerView1.titleImageView addGestureRecognizer:tapGesturRecognizer];
        
    }
}
-(void)tapAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    YXHomeXueJiaPeiJianDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPeiJianDetailViewController"];
    VC.startDic = [NSDictionary dictionaryWithDictionary:self.dataArray[tag]];
    [self.navigationController pushViewController:VC animated:YES];


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellDataArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeXueJiaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaTableViewCell" forIndexPath:indexPath];
    NSString * str = [(NSMutableString *)self.cellDataArray[indexPath.row][@"photo"] replaceAll:@" " target:@"%20"];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.cellLbl.text = self.cellDataArray[indexPath.row][@"title"];
    cell.cellAutherLbl.text = self.cellDataArray[indexPath.row][@"author"];
    cell.cellDataLbl.text = [ShareManager timestampSwitchTime:[self.cellDataArray[indexPath.row][@"update_time"] integerValue] andFormatter:@""];
    return cell;
}

@end
