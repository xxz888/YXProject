//
//  YXJiFenShopDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/9.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXJiFenShopDetailViewController.h"
#import "YXJiFenShop1TableViewCell.h"
#import "YXJiFenShopDetailHeaderView.h"
#import "YXJiFenDetailAllImageTableViewCell.h"
#import "YXJiFenLiJiGouMaiTableViewController.h"

@interface YXJiFenShopDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) YXJiFenShopDetailHeaderView * headerView;
@property (nonatomic,assign) CGFloat oldOffset;

@end

@implementation YXJiFenShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitle.text = self.startDic[@"name"];
    self.navJifen.text = kGetString(self.startDic[@"integral"]);
    
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXJiFenShop1TableViewCell" bundle:nil] forCellReuseIdentifier:@"YXJiFenShop1TableViewCell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXJiFenDetailAllImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXJiFenDetailAllImageTableViewCell"];
    [self.yxTableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
       NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXJiFenShopDetailHeaderView" owner:self options:nil];
        self.headerView = [nib objectAtIndex:0];
        UIView * view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, KScreenWidth, 530);
        [self.headerView setHeaderView:self.startDic];
        [view addSubview:self.headerView];
        return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 550;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.startDic[@"detail_list"] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 600;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXJiFenDetailAllImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXJiFenDetailAllImageTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.startDic[@"detail_list"][indexPath.row];
    [cell.signImage sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:dic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    return cell;
}
- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _oldOffset= scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y >_oldOffset) {
    // 向下
        self.navView.backgroundColor = KWhiteColor;
        self.wenziView.hidden = NO;
    }else{
        self.navView.backgroundColor = KClearColor;
        self.wenziView.hidden = YES;
}

}
- (IBAction)lijigoumaiAction:(id)sender {
            UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
            YXJiFenLiJiGouMaiTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXJiFenLiJiGouMaiTableViewController"];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:self.startDic];
            [self.navigationController pushViewController:VC animated:YES];
}

@end
