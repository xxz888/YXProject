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
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineFindTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineFindTableViewCell"];
    self.yxTableView.separatorStyle = 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineFindTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineFindTableViewCell" forIndexPath:indexPath];
    [cell.titleImv sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
    return cell;
}
- (IBAction)wechat1:(id)sender {
    [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_WechatSession obj:nil];
}
- (IBAction)wechat2:(id)sender {
   [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine obj:nil];

    
}
- (IBAction)wechat3:(id)sender {
}

@end
