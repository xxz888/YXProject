//
//  YXHomeGaoErFuViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeGaoErFuViewController.h"
#import "YXHomeGEFPinPaiViewController.h"
#import "YXQCDJCViewController.h"

@interface YXHomeGaoErFuViewController ()<UITableViewDelegate,UITableViewDataSource,ClickGridView>

@end

@implementation YXHomeGaoErFuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.informationArray = [NSMutableArray array];
    //tableview列表
    [self createBottomTableView];
    //顶部广告请求
    //[self requestAdvertising];
    //tableview请求
    //[self requestInformation];
}
-(void)requestInformation{
    [self.informationArray removeAllObjects];
    [self.informationArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"aaabbb5"]];
    [self.bottomTableView reloadData];
    return;
    kWeakSelf(self);
    [YX_MANAGER requestGETInformation:@"1" success:^(id object) {
        [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"aaabbb5"];
        
        [weakself.informationArray removeAllObjects];
        [weakself.informationArray addObjectsFromArray:object];
        [weakself.bottomTableView reloadData];
    }];
    
}
-(void)requestAdvertising{
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
        self.bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.bootomView.frame.size.height - 60) style:UITableViewStyleGrouped];
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
    self.headerView.titleArray = @[@"高尔夫品牌",@"高尔夫知识",@"球场及度假村",@"问答交流",@"记分",@"足迹"];
    self.headerView.titleTagArray = @[@"Golf Brand",@"Knowledge",@"Resort",@"Q&A",@"Score",@"Journey"];
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
        VC = [[YXHomeGEFPinPaiViewController alloc]init];
    }else if(tag == 1){
        VC = [[YXHomeXueJiaWenHuaViewController alloc]init];
    }else if (tag == 2){
        VC = [[YXQCDJCViewController alloc]init];
    }else if(tag == 3){
        VC = [[YXHomeXueJiaToolsViewController alloc]init];
    }else if (tag == 4){
        VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaQuestionViewController"];
    }else if(tag == 5){
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

@end
