//
//  YXMessageThreeDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMessageThreeDetailViewController.h"
#import "YXMessageThreeDetailViewCell.h"
#import "YXMineViewController.h"
@interface YXMessageThreeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * yxTableView;
@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation YXMessageThreeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    [self tableviewCon];
    [self addRefreshView:self.yxTableView];
    [self commonRequest];
}
-(void)commonRequest{
    //点赞
    if (self.whereCome == 1) {
        [self dianzanRequest];
    }else if(self.whereCome == 2){
        [self fensiRequest];
    }else if(self.whereCome == 3){
        [self hudongRequest];
    }
}
- (void)headerRereshing{
    [self commonRequest];
}
-(void)footerRereshing{
    [self commonRequest];

}
-(void)dianzanRequest{
    kWeakSelf(self);
    [YX_MANAGER requestGETPraiseHistory:NSIntegerToNSString(self.requestPage) success:^(id object) {
        [weakself commonRespond:object];
    }];
}
-(void)fensiRequest{
    kWeakSelf(self);
    [YX_MANAGER requestGETFansHistory:NSIntegerToNSString(self.requestPage) success:^(id object) {
        [weakself commonRespond:object];
    }];
}
-(void)hudongRequest{
    kWeakSelf(self);
    [YX_MANAGER requestGETCommenHistory:NSIntegerToNSString(self.requestPage) success:^(id object) {
        [weakself commonRespond:object];
    }];
}
-(void)commonRespond:(id)object{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:object];
    [self.yxTableView reloadData];
    [self.yxTableView.mj_header endRefreshing];
    [self.yxTableView.mj_footer endRefreshing];
}
#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight, KScreenWidth, KScreenHeight - kTopHeight)  style:0];
    
    [self.view addSubview:self.yxTableView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMessageThreeDetailViewCell" bundle:nil] forCellReuseIdentifier:@"YXMessageThreeDetailViewCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMessageThreeDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMessageThreeDetailViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    [cell.titleImg sd_setImageWithURL:[NSURL URLWithString:dic[@"user_photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.lbl1.text = dic[@"user_name"];
    cell.lbl3.text =  [ShareManager timestampSwitchTime:[dic[@"fans_time"] integerValue] andFormatter:@""];
    cell.userId = dic[@"user_id"];
    kWeakSelf(self);
    cell.imgBlock = ^(YXMessageThreeDetailViewCell * cell) {
        [weakself clickUserImageView:kGetString(cell.userId)];
    };
    //点赞
    if (self.whereCome == 1) {
        cell.lbl1Tag.text = @"赞了你的帖子";
        cell.lbl2.hidden = YES;
        cell.lbl3.text =  [ShareManager timestampSwitchTime:[dic[@"praise_time"] integerValue] andFormatter:@""];
        cell.lbl1Height.constant = 35;
        cell.lbl2Height.constant = 0;
    }else if(self.whereCome == 2){
        cell.lbl1Tag.text = @"开始关注你了";
        cell.lbl2.hidden = YES;
        cell.lbl3.text =  [ShareManager timestampSwitchTime:[dic[@"fans_time"] integerValue] andFormatter:@""];
        cell.lbl1Height.constant = 35;
        cell.lbl2Height.constant = 0;
        cell.guanZhuBtn.hidden = NO;
        cell.gzBlock = ^(YXMessageThreeDetailViewCell * cell) {
            [YX_MANAGER requestLikesActionGET:kGetString(cell.userId) success:^(id object) {
                BOOL is_like = [cell.guanZhuBtn.titleLabel.text isEqualToString:@"关注"] == 1;
                [ShareManager setGuanZhuStatus:cell.guanZhuBtn status:!is_like alertView:YES];
                NSString * islike = is_like ? @"互相关注" : @"关注";
                [cell.guanZhuBtn setTitle:islike forState:UIControlStateNormal];
            }];
        };

    }else if(self.whereCome == 3){
        cell.lbl1Tag.text = @"评论了你的帖子";
        cell.lbl2.hidden = NO;
        cell.lbl3.text =  [ShareManager timestampSwitchTime:[dic[@"comment_time"] integerValue] andFormatter:@""];
        cell.lbl1Height.constant = 70/3;
        cell.lbl2Height.constant = 70/3;

        cell.lbl2.text = [dic[@"comment"] UnicodeToUtf8];
    }
    
    return cell;
}
#pragma mark ========== 头像点击 ==========
-(void)clickUserImageView:(NSString *)userId{
    UserInfo *userInfo = curUser;
    if ([userInfo.id isEqualToString:userId]) {
        self.navigationController.tabBarController.selectedIndex = 4;
        return;
    }
    UIStoryboard * stroryBoard5 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    YXMineViewController * mineVC = [stroryBoard5 instantiateViewControllerWithIdentifier:@"YXMineViewController"];
    mineVC.userId = userId;
    mineVC.whereCome = YES;    //  YES为其他人 NO为自己
    [self.navigationController pushViewController:mineVC animated:YES];
    
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
