//
//  YXJiFenShopViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/9.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXJiFenShopViewController.h"
#import "SDCycleScrollView.h"
#import "YXJiFenShop1TableViewCell.h"
#import "YXJiFenShop2TableViewCell.h"
#import "YXJiFenShopDetailViewController.h"

@interface YXJiFenShopViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic)SDCycleScrollView *cycleScrollView3;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation YXJiFenShopViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXJiFenShop1TableViewCell" bundle:nil] forCellReuseIdentifier:@"YXJiFenShop1TableViewCell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXJiFenShop2TableViewCell" bundle:nil] forCellReuseIdentifier:@"YXJiFenShop2TableViewCell"];
    [self getData];
}

-(void)getData{
    [self.dataArray removeAllObjects];
    kWeakSelf(self);
    [YXPLUS_MANAGER requestIntegral_classify:@"" success:^(id object) {
        [weakself.dataArray addObjectsFromArray:object[@"data"]];
        [weakself.yxTableView reloadData];
    }];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, KScreenWidth, KScreenWidth);
        NSMutableArray * photoArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in self.lunboArray) {
            if([dic[@"photo_list"] count] != 0){
                [photoArray addObject:[IMG_URI append:dic[@"photo_list"][0][@"photo"]]];
            }
        }
        _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenWidth) shouldInfiniteLoop:NO imageNamesGroup:photoArray];
        _cycleScrollView3.delegate = self;
        [view addSubview:_cycleScrollView3];
        _cycleScrollView3.delegate = self;
        _cycleScrollView3.bannerImageViewContentMode = 0;
        _cycleScrollView3.currentPageDotColor =  SEGMENT_COLOR;
        _cycleScrollView3.showPageControl = YES;
        _cycleScrollView3.autoScrollTimeInterval = 10000;
        _cycleScrollView3.pageDotColor = YXRGBAColor(239, 239, 239);
        _cycleScrollView3.backgroundColor = KWhiteColor;

    return view;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    kWeakSelf(self);
    [YXPLUS_MANAGER requestInIdOutIntegral_commodity:kGetString(self.lunboArray[index][@"photo_list"][0][@"commodity_id"]) success:^(id object) {
        [weakself pushDetail:object];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KScreenWidth;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    if ([dic[@"commodify_id"] integerValue] == 0) {
        return 550;
    }else{
         return 460;
    }
   
}
-(void)pushDetail:(NSMutableDictionary *)dic{
                YXJiFenShopDetailViewController * vc = [[YXJiFenShopDetailViewController alloc]init];
               vc.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
               [self.navigationController pushViewController:vc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic = self.dataArray[indexPath.row];
    if ([dic[@"commodify_id"] integerValue] == 0) {
        YXJiFenShop1TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXJiFenShop1TableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.yxCollectionView.tag = indexPath.row;
        [cell setCellData:self.dataArray[indexPath.row]];
        
        kWeakSelf(self);
        cell.clickCollectionItemBlock = ^(NSDictionary * dic) {
            [weakself pushDetail:dic];
        };
        
        return cell;
    }else{
           YXJiFenShop2TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXJiFenShop2TableViewCell" forIndexPath:indexPath];
         cell.selectionStyle = 0;
        cell.yxCollectionView.tag = indexPath.row;
         [cell setCellData:self.dataArray[indexPath.row]];
        
        
         kWeakSelf(self);
          cell.clickCollectionItemBlock = ^(NSDictionary * dic) {
            [weakself pushDetail:dic];

          };
        return cell;
    }
}












- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
