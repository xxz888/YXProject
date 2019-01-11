//
//  YXHomeXueJiaPinPaiLastDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiLastDetailViewController.h"
#import "YXHomeLastDetailView.h"
#import "YXHomeLastMyTalkView.h"
#import "XHStarRateView.h"
@interface YXHomeXueJiaPinPaiLastDetailViewController ()<UITableViewDelegate,UITableViewDataSource,clickMyTalkDelegate>
@property(nonatomic,strong)YXHomeLastDetailView * lastDetailView;
@property(nonatomic,strong)YXHomeLastMyTalkView * lastMyTalkView;



@end

@implementation YXHomeXueJiaPinPaiLastDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //初始化所有的控件
    [self initAllControl];
}

-(void)initAllControl{
    [self.yxTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    self.title = self.startDic[@"cigar_name"];
    [self.yxTableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    kWeakSelf(self);
    //请求评价列表 平均分
    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"1"] success:^(id object) {
        [weakself.lastDetailView againSetDetailView:weakself.startDic allDataDic:object];
    }];
    
//    //请求评价列表 个人分
    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"2"] success:^(id object) {

    }];
//
//    //请求评价列表 最新评论列表
    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"3"] success:^(id object) {
        [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"aaabbb2"];

    }];
//
//    //请求评价列表 最热评论列表
    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"4"] success:^(id object) {
        [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"aaabbb3"];

    }];
    //
    //请求六宫格图片
    NSString * tag = self.startDic[@"cigar_name"];

    [YX_MANAGER requestGetDetailListPOST:@{@"type":@(1),@"tag":@"xiba110",@"page":@(1)} success:^(id object) {
        NSMutableArray * imageArray = [NSMutableArray array];
        for (NSDictionary * dic in object) {
            [imageArray addObject:dic[@"photo1"]];
        }
        [weakself.lastDetailView setSixPhotoView:imageArray];
    }];
}
-(NSString *)getParamters:(NSString *)type{
    return [NSString stringWithFormat:@"%@/%@",type,self.startDic[@"id"]];
}

//代理方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHomeLastDetailView" owner:self options:nil];
    self.lastDetailView = [nib objectAtIndex:0];
    self.lastDetailView.frame = CGRectMake(0, 0, KScreenWidth, 330);
    self.lastDetailView.delegate = self;
    return self.lastDetailView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark ========== 点击我来评论 ==========
-(void)clickMyTalkAction{
    
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHomeLastMyTalkView" owner:self options:nil];
    self.lastMyTalkView = [nib objectAtIndex:0];
    self.lastMyTalkView.frame = CGRectMake(0, 0,KScreenWidth, 340);
    self.lastMyTalkView.backgroundColor = UIColorWhite;
    self.lastMyTalkView.layer.masksToBounds = YES;
    self.lastMyTalkView.layer.cornerRadius = 6;
    self.lastMyTalkView.parDic = [[NSMutableDictionary alloc]init];
    [self.lastMyTalkView.parDic setValue:@([self.startDic[@"id"] intValue]) forKey:@"cigar_id"];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    modalViewController.contentView = self.lastMyTalkView;
    [modalViewController showWithAnimated:YES completion:nil];
    
}


@end
