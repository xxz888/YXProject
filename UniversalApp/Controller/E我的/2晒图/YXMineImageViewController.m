//
//  YXMineImageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineImageViewController.h"
#import "YXMineImageTableViewCell.h"
@interface YXMineImageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger page ;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YXMineImageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWeakSelf(self);
    NSString * pageString = NSIntegerToNSString(page) ;
    [YX_MANAGER requestImageListGET:pageString success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineImageTableViewCell"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineImageTableViewCell" forIndexPath:indexPath];
    [cell.mineImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"photo1"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.mineImageLbl.text = self.dataArray[indexPath.row][@"describe"];
    NSString * time = self.dataArray[indexPath.row][@"publish_time"];
    cell.mineTimeLbl.text = [ShareManager timestampSwitchTime:[time integerValue] andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    return cell;
}

@end
