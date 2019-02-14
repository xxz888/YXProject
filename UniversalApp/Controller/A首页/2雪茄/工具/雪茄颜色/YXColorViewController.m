//
//  YXColorViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXColorViewController.h"
#import "YXToolsColorTableViewCell.h"
@interface YXColorViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray * titleArray;
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;

@property(nonatomic,strong)NSArray * dataArray;

@end

@implementation YXColorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXToolsColorTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXToolsColorTableViewCell"];
    self.yxTableView.delegate=  self;
    self.yxTableView.dataSource = self;
    self.title = @"雪茄文化";
    
    self.titleArray = @[@"Oscuro",@"Maduro",@"Colorado Maduro",@"Colorado",@"Colorado Claro",@"Claro",@"Double Claro"];
    self.dataArray = @[YXRGBAColor(48, 31, 20),
                       YXRGBAColor(92, 39, 23),
                       YXRGBAColor(102, 73, 66),
                       YXRGBAColor(124, 80, 69),
                       YXRGBAColor(141, 112, 99),
                       YXRGBAColor(161, 120, 58),
                       YXRGBAColor(147, 124, 68)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXToolsColorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXToolsColorTableViewCell" forIndexPath:indexPath];
    cell.colorView.backgroundColor = self.dataArray[indexPath.row];
    cell.colorLbl.text = self.titleArray[indexPath.row];
    return cell;
}

@end
