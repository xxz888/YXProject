//
//  YXXingZhuangViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXXingZhuangViewController.h"
#import "LLGifImageView.h"
#import "LLGifView.h"
#import "YXXingZhuangTableViewCell.h"

@interface YXXingZhuangViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (nonatomic, strong) LLGifView *gifView;
@property (nonatomic,strong) NSArray * xuejiaNameArray;


@end

@implementation YXXingZhuangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXXingZhuangTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXXingZhuangTableViewCell"];
    self.xuejiaNameArray = @[@"Cigarillo",@"Small Panetela",@"Slim Panetela",@"Short Panetela",@"Panetela",@"Long Panetela",@"Petit Corona",@"Corona",@"Long Corona",@"Lonsdale",@"Corona Extra",@"Grand Corona",@"Double Corona",@"Giant Corona",@"Churchill",@"Petit Robusto",@"Robusto",@"Robusto Extra",@"Double Robusto",@"Giant Robusto",@"Culebras",@"Petit Pyramid",@"Pyramid",@"Double Pyramid",@"Petit Perfecto",@"Perfecto",@"Double Perfecto",@"Giant Perfecto"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.xuejiaNameArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXXingZhuangTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXXingZhuangTableViewCell" forIndexPath:indexPath];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.xuejiaNameArray[indexPath.row] ofType:@"gif"];
    cell.gifImageView.gifData = [NSData dataWithContentsOfFile:filePath];

    cell.nameLbl.text = self.xuejiaNameArray[indexPath.row];

    cell.selectionStyle = 0;
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
