
//
//  YXHomeXueJiaViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaViewController.h"
#import <ZXSegmentController/ZXSegmentController.h>
#import "YXHomeNewsDetailViewController.h"
#import "GCDAsyncUdpSocket.h"
#import "UDPManage.h"
@interface YXHomeXueJiaViewController ()<UITableViewDelegate,UITableViewDataSource,ClickGridView>

@end

@implementation YXHomeXueJiaViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.informationArray = [NSMutableArray array];
    
    self.scrollImgArray = [NSMutableArray array];

    //tableview列表
    [self createBottomTableView];
    //tableview请求
    [self addRefreshView:self.bottomTableView];

    
    if ([userManager loadUserInfo]) {
//        [ShareManager upDataPersionIP];
        [[UDPManage shareUDPManage] getNewMessageNumeber];
//        [[UDPManage shareUDPManage] createClientUdpSocket];
    }
    //老板说第二页太卡，在这里做个缓存吧
//    [self requestCigar_brand:@"1"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self commonRequest];
}

-(void)commonRequest{
    //tableview请求
    [self requestInformation];
        //顶部广告请求
    [self requestAdvertising];
}
-(void)headerRereshing{
    [self commonRequest];
}
-(void)footerRereshing{
    [self commonRequest];

}
-(void)requestCigar_brand:(NSString *)type{
    [YX_MANAGER requestCigar_brand:type success:^(id object) {
        [YX_MANAGER.cache1Dic removeAllObjects];
        YX_MANAGER.cache1Dic = object;
    }];
}
-(void)requestInformation{
    kWeakSelf(self);
    [YX_MANAGER requestGETInformation:TYPE_XUEJIA_1 success:^(id object) {
        [weakself.informationArray removeAllObjects];
        [weakself.informationArray addObjectsFromArray:object];
        [weakself.bottomTableView reloadData];
        [weakself.bottomTableView.mj_footer endRefreshing];
        [weakself.bottomTableView.mj_header endRefreshing];

    }];

}
-(void)requestAdvertising{
    kWeakSelf(self);
    [YX_MANAGER requestGETAdvertising:TYPE_XUEJIA_1 success:^(id object) {
//            [weakself.headerView setUpSycleScrollView:object];
            [weakself.scrollImgArray removeAllObjects];
            [weakself.scrollImgArray addObjectsFromArray:object];
            [weakself.bottomTableView.mj_footer endRefreshing];
            [weakself.bottomTableView.mj_header endRefreshing];
            [weakself.bottomTableView reloadData];

    }];
}



//tableview
-(void)createBottomTableView{

    if (!self.bottomTableView) {
        self.bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, AxcAE_IsiPhoneX ?self.bootomView.frame.size.height : KScreenHeight - kTopHeight - TabBarHeight) style:UITableViewStyleGrouped];
        [self.bootomView addSubview:self.bottomTableView];
    }
    self.bottomTableView.backgroundColor = KWhiteColor;
    [self.bottomTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaTableViewCell"];
    self.bottomTableView.delegate= self;
    self.bottomTableView.dataSource = self;
    

}

//代理方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHomeXueJiaHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 380);
    self.headerView.delegate = self;
    self.headerView.titleArray = @[@"品牌",@"文化",@"配件",@"工具",@"问答",@"品鉴足迹"];
    self.headerView.titleTagArray = @[@"Brand",@"Culture",@"Accessories",@"Tools",@"Q&A",@"Journey"];
    self.headerView.scrollImgArray = [NSMutableArray arrayWithArray:self.scrollImgArray];
    kWeakSelf(self);
    self.headerView.scrollImgBlock = ^(NSInteger index) {
        return;
        YXHomeNewsDetailViewController * VC = [YXHomeNewsDetailViewController alloc];
        NSDictionary * dic = weakself.scrollImgArray[index];
        VC.webDic =[NSMutableDictionary dictionaryWithDictionary:dic];
        [VC.webDic setValue:dic[@"title"] forKey:@"title"];
        [VC.webDic setValue:@"" forKey:@"date"];
        [VC.webDic setValue:dic[@"character"] forKey:@"details"];
        [VC.webDic setValue:@"" forKey:@"author"];
        [weakself.navigationController pushViewController:VC animated:YES];
    };
    
    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 380;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.informationArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YXHomeXueJiaTableViewCell";
    YXHomeXueJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    NSString * str = [(NSMutableString *)self.informationArray[indexPath.row][@"photo"] replaceAll:@" " target:@"%20"];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.cellLbl.text = self.informationArray[indexPath.row][@"title"];
    cell.cellAutherLbl.text = self.informationArray[indexPath.row][@"author"];
    cell.cellDataLbl.text =  [ShareManager timestampSwitchTime:[self.informationArray[indexPath.row][@"date"] integerValue] andFormatter:@""];
    cell.cellImageView.layer.masksToBounds = YES;
    cell.cellImageView.layer.cornerRadius = 3;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YXHomeNewsDetailViewController * VC = [YXHomeNewsDetailViewController alloc];
    VC.webDic =[NSMutableDictionary dictionaryWithDictionary:self.informationArray[indexPath.row]];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark ========== 点击九宫格 ==========
-(void)clickGridView:(NSInteger)tag{
    NSLog(@"%lu",tag);
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    RootViewController * VC = nil;
    if (tag == 0) {
        VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiViewController"];
        [self.navigationController pushViewController:VC animated:YES];

    }else if(tag == 1){
        VC = [[YXHomeXueJiaWenHuaViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];

    }else if (tag == 2){
        VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPeiJianViewController"];
        [self.navigationController pushViewController:VC animated:YES];

    }else if(tag == 3){
        VC = [[YXHomeXueJiaToolsViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];

    }else if (tag == 4){
        YXHomeXueJiaQuestionViewController * VCCoustom = [[YXHomeXueJiaQuestionViewController alloc]init];
        VCCoustom.whereCome = TYPE_XUEJIA_1;
        [self.navigationController pushViewController:VCCoustom animated:YES];
    }
    else if(tag == 5){
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaFootViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }

}


-(NSString *)haomiaoChangeYYMMDDHHMMSS:(NSString *)string{
    NSTimeInterval time = [string doubleValue] ;
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}
@end
