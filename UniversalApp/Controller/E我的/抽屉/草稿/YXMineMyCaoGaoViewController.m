//
//  YXMineMyCaoGaoViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineMyCaoGaoViewController.h"
#import "YXHomeXueJiaTableViewCell.h"
#import "YXPublishImageViewController.h"
@interface YXMineMyCaoGaoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic,strong)NSMutableArray * caoGaoArray;
@property(nonatomic,strong)NSMutableDictionary * caoGaoDic;

@end

@implementation YXMineMyCaoGaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationItemWithTitles:@[@"清空"] isLeft:NO target:self action:@selector(clearCachae) tags:@[@1000]];

    self.title = @"我的草稿";
    self.caoGaoArray = [[NSMutableArray alloc]init];
    self.caoGaoDic = [[NSMutableDictionary alloc]init];
    self.yxTableView.backgroundColor = KWhiteColor;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaTableViewCell"];
    self.yxTableView.delegate= self;
    self.yxTableView.dataSource = self;
    self.yxTableView.tableFooterView = [[UIView alloc]init];
    self.caoGaoDic = UserDefaultsGET(YX_USER_FaBuCaoGao);
    [self.yxTableView reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)clearCachae{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:YX_USER_FaBuCaoGao];
    [[NSUserDefaults standardUserDefaults]synchronize];
    self.caoGaoDic = UserDefaultsGET(YX_USER_FaBuCaoGao);
    [self.yxTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.caoGaoDic ? 1 : 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YXHomeXueJiaTableViewCell";
    YXHomeXueJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[YXHomeXueJiaTableViewCell alloc]initWithStyle:0 reuseIdentifier:identify];
    }
    NSString * str = [(NSMutableString *)self.caoGaoDic[@"photo1"] replaceAll:@" " target:@"%20"];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.cellLbl.text = self.caoGaoDic[@"tag"];
    cell.cellAutherLbl.text = [self.caoGaoDic[@"describe"] UnicodeToUtf8];
    cell.cellDataLbl.hidden = YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXPublishImageViewController * imageVC = [[YXPublishImageViewController alloc]init];
    imageVC.whereComeCaogao = YES;
    [self presentViewController:imageVC animated:YES completion:nil];
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
