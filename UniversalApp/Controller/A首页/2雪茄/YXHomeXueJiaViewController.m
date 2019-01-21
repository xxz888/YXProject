
//
//  YXHomeXueJiaViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaViewController.h"
#import <ZXSegmentController/ZXSegmentController.h>

@interface YXHomeXueJiaViewController ()<UITableViewDelegate,UITableViewDataSource,ClickGridView>

@end

@implementation YXHomeXueJiaViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getSegmentIndex];
    // Do any additional setup after loading the view.
    self.informationArray = [NSMutableArray array];
    
    //tableview列表
    [self createBottomTableView];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //tableview请求
    [self requestInformation];
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //顶部广告请求
        [weakself requestAdvertising];
    });
}
-(void)getSegmentIndex{
    ZXSegmentController * segmentController = (ZXSegmentController *)self.parentViewController;
    segmentController.getIndex = ^(NSInteger index) {
        
    };
}
-(void)requestInformation{
    kWeakSelf(self);
    [YX_MANAGER requestGETInformation:TYPE_XUEJIA_1 success:^(id object) {
        [weakself.informationArray removeAllObjects];
        [weakself.informationArray addObjectsFromArray:object];
        [weakself.bottomTableView reloadData];
  

    }];

}
-(void)requestAdvertising{
    kWeakSelf(self);
    [YX_MANAGER requestGETAdvertising:TYPE_XUEJIA_1 success:^(id object) {
        if ([object count] > 0) {
            [weakself.headerView setUpSycleScrollView:object];
        }
    }];
}



//tableview
-(void)createBottomTableView{

    if (!self.bottomTableView) {
        self.bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.bootomView.frame.size.height - 60 - 64 - 49) style:UITableViewStyleGrouped];
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
    self.headerView.titleArray = @[@"雪茄品牌",@"雪茄文化",@"雪茄配件",@"工具",@"问答",@"品鉴足迹"];
    self.headerView.titleTagArray = @[@"Cigar Brand",@"Culture",@"Accessories",@"Tools",@"Q&A",@"Journey"];
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
        YXHomeXueJiaQuestionViewController *  VCCoustom = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaQuestionViewController"];
        VCCoustom.whereCome = TYPE_XUEJIA_1;
        [self.navigationController pushViewController:VCCoustom animated:YES];
    }
    else if(tag == 5){
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
