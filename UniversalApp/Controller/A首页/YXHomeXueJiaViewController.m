
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
#import "HGSegmentedPageViewController.h"
#import "YXHomeXueJiaGuBaViewController.h"
@interface YXHomeXueJiaViewController ()<UITableViewDelegate,UITableViewDataSource,ClickGridView,UIGestureRecognizerDelegate>
@property (nonatomic) BOOL isCanBack;
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic,strong) NSMutableArray * titlesArr;
@property (nonatomic,strong) NSMutableArray * tmpArr;



@end

@implementation YXHomeXueJiaViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcArr = [NSMutableArray array];
    self.titlesArr = [NSMutableArray array];

    [self requestZhiNan1Get];

}
-(void)requestZhiNan1Get{
    kWeakSelf(self);
    [YXPLUS_MANAGER requestZhiNan1Get:@"1/0" success:^(id object) {
        for (NSDictionary * dic in object) {
            YXHomeXueJiaToolsViewController * vc = [[YXHomeXueJiaToolsViewController alloc]init];
            vc.title = dic[@"name"];
            vc.startId = kGetString(dic[@"id"]);
            [weakself.vcArr addObject:vc];
            [weakself.titlesArr addObject:dic[@"name"]];
        }
        [weakself initSegment];
        
    }];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];

    //[self commonRequest];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];

}
-(void)initSegment{
    [self addChildViewController:self.segmentedPageViewController];
    [self.view addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController didMoveToParentViewController:self];
    kWeakSelf(self);
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view).mas_offset(UIEdgeInsetsMake(40, 0, 0, 0));
    }];
    
    //添加搜索框
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(15, 50, KScreenWidth-30, 30)];
    searchView.layer.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0].CGColor;
    searchView.layer.cornerRadius = 15;
    [self.segmentedPageViewController.view addSubview:searchView];
    
    
    UIImageView * fangdajingView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 6, 18, 18)];
    fangdajingView.image = [UIImage imageNamed:@"放大镜"];
    [searchView addSubview:fangdajingView];
    
    UILabel * fangdajingLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 100, 30)];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"搜索蓝皮书"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    
    fangdajingLabel.attributedText = string;
    fangdajingLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    fangdajingLabel.textAlignment = NSTextAlignmentLeft;
    fangdajingLabel.alpha = 1.0;
    [searchView addSubview:fangdajingLabel];
    
}
- (HGSegmentedPageViewController *)segmentedPageViewController{
    if (!_segmentedPageViewController) {
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
        _segmentedPageViewController.categoryView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _segmentedPageViewController.categoryView.titleSelectedFont =  [UIFont fontWithName:@"PingFangSC-Medium" size: 24];
        _segmentedPageViewController.categoryView.titleSelectedColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _segmentedPageViewController.categoryView.titleNormalColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        _segmentedPageViewController.pageViewControllers = self.vcArr.copy;
        _segmentedPageViewController.categoryView.titles = self.titlesArr;
        _segmentedPageViewController.categoryView.originalIndex = 0;
    }
    return _segmentedPageViewController;
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
    self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 100);
    self.headerView.delegate = self;
    self.headerView.titleArray = @[@"品牌",@"文化",@"工具",@"问答"];
    self.headerView.titleTagArray = @[@"Brand",@"Culture",@"Tools",@"Q&A"];
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
    return 350;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.informationArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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
    cell.cellLbl.hidden = cell.cellAutherLbl.hidden = cell.cellDataLbl.hidden = NO;
    
    
    [ShareManager setLineSpace:9 inLabel:cell.cellLbl size:15];
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

    }
    /*
    else if (tag == 2){
        VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPeiJianViewController"];
        [self.navigationController pushViewController:VC animated:YES];

    }*/
     else if(tag == 2){
        VC = [[YXHomeXueJiaToolsViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];

    }else if (tag == 3){
        YXHomeXueJiaQuestionViewController * VCCoustom = [[YXHomeXueJiaQuestionViewController alloc]init];
        VCCoustom.whereCome = TYPE_XUEJIA_1;
        [self.navigationController pushViewController:VCCoustom animated:YES];
    }
    /*
    else if(tag == 5){
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaFootViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
*/
}


-(NSString *)haomiaoChangeYYMMDDHHMMSS:(NSString *)string{
    NSTimeInterval time = [string doubleValue] ;
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}


@end
