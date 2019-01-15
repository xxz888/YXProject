
//
//  YXHomeXueJiaViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaViewController.h"
#import "YXHomeXueJiaTableViewCell.h"
#import "YXHomeXueJiaHeaderView.h"
#import "YXHomeXueJiaPinPaiViewController.h"
#import "YXHomeXueJiaWenHuaViewController.h"
#import "YXHomeXueJiaToolsViewController.h"
#import "YXHomeXueJiaQuestionViewController.h"
#import "YXHomeXueJiaPeiJianViewController.h"
@interface YXHomeXueJiaViewController ()<UITableViewDelegate,UITableViewDataSource,ClickGridView>
@property(nonatomic,strong)UITableView * bottomTableView;
@property(nonatomic,strong)YXHomeXueJiaHeaderView * headerView;
@property(nonatomic,strong)NSMutableArray * informationArray;
@end

@implementation YXHomeXueJiaViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.informationArray = [NSMutableArray array];
    //tableview列表
    [self createBottomTableView];
    //顶部广告请求
     [self requestAdvertising];
    //tableview请求
    [self requestInformation];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];


}


-(void)requestInformation{
//    [self.informationArray removeAllObjects];
//    [self.informationArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"aaabbb5"]];
//    [self.bottomTableView reloadData];
//    return;
    kWeakSelf(self);
    [YX_MANAGER requestGETInformation:@"1" success:^(id object) {
//        [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"aaabbb5"];

        [weakself.informationArray removeAllObjects];
        [weakself.informationArray addObjectsFromArray:object];
        [weakself.bottomTableView reloadData];
    }];

}
-(void)requestAdvertising{
//    [self.headerView setUpSycleScrollView:[[NSUserDefaults standardUserDefaults] objectForKey:@"aaabbb4"]];
//    return;
    kWeakSelf(self);
    [YX_MANAGER requestGETAdvertising:@"1" success:^(id object) {
        [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"aaabbb4"];

        [weakself.headerView setUpSycleScrollView:object];
        [weakself.bottomTableView reloadData];
    }];
}



//tableview
-(void)createBottomTableView{
    if (!self.bottomTableView) {
        self.bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.bootomView.frame.size.height) style:UITableViewStyleGrouped];
    }
    self.bottomTableView.backgroundColor = KWhiteColor;
    [self.bottomTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaTableViewCell"];
    self.bottomTableView.delegate= self;
    self.bottomTableView.dataSource = self;
    [self.bootomView addSubview:self.bottomTableView];
    

}

//代理方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHomeXueJiaHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 330);
    self.headerView.delegate = self;
    [self.headerView setUpSycleScrollView:[[NSUserDefaults standardUserDefaults] objectForKey:@"aaabbb4"]];

    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 330;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.informationArray.count;
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
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:self.informationArray[indexPath.row][@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.cellLbl.text = self.informationArray[indexPath.row][@"title"];
    cell.cellAutherLbl.text = self.informationArray[indexPath.row][@"author"];
    cell.cellDataLbl.text = [self haomiaoChangeYYMMDDHHMMSS:self.informationArray[indexPath.row][@"author"]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark ========== 点击九宫格 ==========
-(void)clickGridView:(NSInteger)tag{
    NSLog(@"%lu",tag);
    
    
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    RootViewController * VC = nil;
    if (tag == 0) {
        VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiViewController"];
    }else if(tag == 1){
        VC = [[YXHomeXueJiaWenHuaViewController alloc]init];
    }else if (tag == 2){
        VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPeiJianViewController"];
    }else if(tag == 3){
        VC = [[YXHomeXueJiaToolsViewController alloc]init];
    }else if (tag == 4){
        VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaQuestionViewController"];
    }
    else if(tag == 5){
        VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaFootViewController"];
    }
    [self.navigationController pushViewController:VC animated:YES];

}
-(NSString *)haomiaoChangeYYMMDDHHMMSS:(NSString *)string{
    NSTimeInterval time = [string doubleValue] ;
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
@end
