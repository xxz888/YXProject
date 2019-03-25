//
//  YXMineFindViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineFindViewController.h"
#import "YXMineFindTableViewCell.h"

@interface YXMineFindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;

@end

@implementation YXMineFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现好友";
    // Do any additional setup after loading the view from its nib.
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineFindTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineFindTableViewCell"];
    self.yxTableView.separatorStyle = 0;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineFindTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineFindTableViewCell" forIndexPath:indexPath];
    
    
    
    [cell.titleImv sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img_moren"]];

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
