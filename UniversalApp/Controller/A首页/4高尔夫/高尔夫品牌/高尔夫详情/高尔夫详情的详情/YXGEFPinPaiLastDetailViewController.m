//
//  YXGEFPinPaiLastDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXGEFPinPaiLastDetailViewController.h"
#import "YXGEFPinPaiDetailTableViewCell.h"
@interface YXGEFPinPaiLastDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;

@end

@implementation YXGEFPinPaiLastDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.dicStartData[@"product_name"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXGEFPinPaiDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXGEFPinPaiDetailTableViewCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXGEFPinPaiDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXGEFPinPaiDetailTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dicStartData;
    cell.gefTitleLbl.text = dic[@"product_name"];
    cell.gnPriceLbl.text = kGet2fDouble([dic[@"price_CN"] doubleValue]);
    cell.mgPriceLbl.text = kGet2fDouble([dic[@"price_USA"] doubleValue]);
    cell.likeBtn.hidden = YES;
    if ([dic[@"photo_list"] count] > 0) {
        [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo_list"][0][@"photo_url"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }
    return cell;
}

@end
