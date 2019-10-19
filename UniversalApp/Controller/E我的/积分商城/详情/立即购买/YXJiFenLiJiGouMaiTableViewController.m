//
//  YXJiFenLiJiGouMaiTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/10.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXJiFenLiJiGouMaiTableViewController.h"
#import "YXJiFenLiJiGouMaiFootView.h"
#import "YXMineShouHuoAdressViewController.h"

@interface YXJiFenLiJiGouMaiTableViewController ()
@property (nonatomic,strong) YXJiFenLiJiGouMaiFootView * footerView;
@property (nonatomic,strong) NSMutableArray * addressArray;

@property (nonatomic,strong) NSString * address_id;

@end

@implementation YXJiFenLiJiGouMaiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBA(245, 245, 245, 1);
    self.tableView.bounces = NO;
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXJiFenLiJiGouMaiFootView" owner:self options:nil];
    self.footerView = [nib objectAtIndex:0];
    self.footerView.frame = CGRectMake(0, KScreenHeight-70, KScreenWidth, 70);
    [self.view addSubview:self.footerView];
    self.addressArray = [[NSMutableArray alloc]init];
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    kWeakSelf(self);
    self.footerView.lijigoumaiblock = ^{
        if (!weakself.footerView.querenzhifu.isEnabled) {
            [QMUITips showError:@"积分不足"];
            return;
        }
        UserInfo * info = curUser;
        
        NSDictionary * dic = @{@"type":@"1",
                               @"user_id":kGetString(info.id),
                               @"address_id":weakself.address_id,
                               @"commodity_id":kGetString(weakself.startDic[@"id"]),
        };
        
        [YXPLUS_MANAGER requestAddShopIntegral_orderPOST:dic success:^(id object) {
            [QMUITips showSucceed:object[@"message"]];
        }];
    };
    
    [self getdata];
    
    [self getAddressList];
    
    [self getjifen];
}
-(void)getjifen{
    kWeakSelf(self);
    [YX_MANAGER requestGetFind_My_user_Info:@"" success:^(id object) {
        NSInteger jifen = [object[@"wallet"][@"integral"] integerValue];
        weakself.keyongjifen.text= [@"可用积分" append:kGetNSInteger(jifen)];
        
        if (jifen < [weakself.startDic[@"integral"] integerValue]) {
            weakself.jifenbugoulbl.hidden = NO;
            weakself.footerView.querenzhifu.enabled = NO;
            [weakself.footerView.querenzhifu setBackgroundColor:kRGBA(239, 239, 239, 1)];
        }else{
            weakself.jifenbugoulbl.hidden = YES;
            weakself.footerView.querenzhifu.enabled = YES;
            [weakself.footerView.querenzhifu setBackgroundColor:kRGBA(10, 36, 54, 1)];

        }
    }];
}
-(void)getAddressList{
    kWeakSelf(self);
    [YXPLUS_MANAGER requestAddressListGet:@"" success:^(id object) {
        if ([object[@"address_list"] count] == 0) {
            weakself.addAdressLbl.hidden = NO;
            weakself.shouhuorenTagLbl.hidden = weakself.shouhuoren.hidden = weakself.shouhuoPhone.hidden = weakself.shouhuoAddress.hidden = YES;
        }else{
            for (NSDictionary * dic in object[@"address_list"]) {
                if ([dic[@"default"] integerValue] == 1) {
                    weakself.shouhuoren.text = dic[@"name"];
                    weakself.shouhuoPhone.text = dic[@"phone"];
                    weakself.shouhuoAddress.text = dic[@"site"];
                    weakself.address_id = kGetString(dic[@"id"]);
                    weakself.addAdressLbl.hidden = YES;
                    weakself.shouhuorenTagLbl.hidden = weakself.shouhuoren.hidden = weakself.shouhuoPhone.hidden = weakself.shouhuoAddress.hidden = NO;
                }
            }
        }
    }];
}
//商品信息和收货地址
-(void)getdata{
    [self.shangpinimg sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:self.startDic[@"photo_list"][0][@"photo"]]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.shangpinname.text = self.startDic[@"name"];
    self.shangpinjifen.text = kGetString(self.startDic[@"integral"]);
    self.shangpinAlljifen.text = kGetString(self.startDic[@"integral"]);
    self.footerView.jifen.text = kGetString(self.startDic[@"integral"]);

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        YXMineShouHuoAdressViewController * vc = [[YXMineShouHuoAdressViewController alloc]init];
        vc.backVCHaveParblock = ^(NSDictionary * dic) {
                            self.shouhuoren.text = dic[@"name"];
                               self.shouhuoPhone.text = dic[@"phone"];
                               self.shouhuoAddress.text = dic[@"site"];
                               self.address_id = kGetString(dic[@"id"]);
        };
        vc.whereCome = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)querenzhifuAction:(id)sender {
}
@end
