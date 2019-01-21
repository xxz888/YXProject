//
//  YXHomeGolfScoreViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeGolfScoreViewController.h"
#import "YXHomeGolfScoreHeaderView.h"
#import "YXHomeGolfScoreTableViewCell.h"


@interface YXHomeGolfScoreViewController ()
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (nonatomic,strong) YXHomeGolfScoreHeaderView * headerView;
@property (weak, nonatomic) IBOutlet UIButton *startScoreBtn;
- (IBAction)startScoreAction:(id)sender;

@end

@implementation YXHomeGolfScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记分";
    ViewBorderRadius(_startScoreBtn, 3, 1, KDarkGaryColor);
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeGolfScoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeGolfScoreTableViewCell"];
    self.yxTableView.allowsMultipleSelection = NO;
    self.yxTableView.allowsSelectionDuringEditing = NO;
    self.yxTableView.allowsMultipleSelectionDuringEditing = NO;
}

//代理方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHomeGolfScoreHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 300;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 删除
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //实现删除方法
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
// 编辑按钮被点击
- (void)_rightBarButtonItemDidClicked:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        
        // 这个是fix掉:当你左滑删除的时候，再点击右上角编辑按钮， cell上的删除按钮不会消失掉的bug。且必须放在 设置tableView.editing = YES;的前面。
        [self.yxTableView reloadData];
        
        // 取消
        [self.yxTableView setEditing:YES animated:NO];
    }else{
        // 编辑
        [self.yxTableView setEditing:NO animated:NO];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YXHomeGolfScoreTableViewCell";
    YXHomeGolfScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[YXHomeGolfScoreTableViewCell alloc]initWithStyle:0 reuseIdentifier:identify];
    }
    return cell;
}
- (IBAction)startScoreAction:(id)sender {
    
}
@end
