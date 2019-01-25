//
//  YXMinePingLunViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMinePingLunViewController.h"
#import "YXMinePingLunTableViewCell.h"

@interface YXMinePingLunViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *yxTableVIew;

@end

@implementation YXMinePingLunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的评论";
    [self.yxTableVIew registerNib:[UINib nibWithNibName:@"YXMinePingLunTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMinePingLunTableViewCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMinePingLunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMinePingLunTableViewCell" forIndexPath:indexPath];
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
