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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.xuejiaNameArray.count;
}


#pragma mark-  UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.xuejiaNameArray[indexPath.row] ofType:@"gif"];
    UIImage * img = [UIImage imageNamed:filePath];
    CGFloat height = img.size.height;
    return (height/img.size.width)*KScreenWidth;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXXingZhuangTableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:@"YXXingZhuangTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self confirmCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)confirmCell:(YXXingZhuangTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.xuejiaNameArray[indexPath.row] ofType:@"gif"];
    UIImage * img = [UIImage imageNamed:filePath];
    cell.imageViewWid.constant = img.size.width / 3;
    cell.gifImageView.image = [UIImage imageNamed:filePath];
    cell.nameLbl.text = self.xuejiaNameArray[indexPath.row];
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
