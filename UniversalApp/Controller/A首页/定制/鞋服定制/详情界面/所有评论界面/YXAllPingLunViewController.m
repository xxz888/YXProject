//
//  YXAllPingLunViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXAllPingLunViewController.h"
#import "YXDingZhiDetailTableViewCell.h"

@interface YXAllPingLunViewController ()
@property(nonatomic,strong)NSMutableArray * btnArray;
@end

@implementation YXAllPingLunViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initControl];
}
//初始化控件
-(void)initControl{
    
    ViewBorderRadius(self.btn1, 14, 1, KClearColor);
    [self selectBtnStatus:self.btn1];
    
    
    ViewBorderRadius(self.btn2, 14, 1, KClearColor);
    [self unSelectBtnStatus:self.btn2];

    
    ViewBorderRadius(self.btn3, 14, 1, KClearColor);
    [self unSelectBtnStatus:self.btn3];

    
    ViewBorderRadius(self.btn4, 14, 1, KClearColor);
    [self unSelectBtnStatus:self.btn4];

    
    
    self.btnArray = [[NSMutableArray alloc]init];
    
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXDingZhiDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXDingZhiDetailTableViewCell"];
    [self.yxTableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [YXDingZhiDetailTableViewCell cellDefaultHeight:@{@"":@""}];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDingZhiDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXDingZhiDetailTableViewCell" forIndexPath:indexPath];
    [cell setCellData:@{@"":@""}];
    return cell;
}

- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectBtnStatus:(UIButton *)btn{
    ViewBorderRadius(btn, 14, 1, KClearColor);
    [btn setTitleColor:KWhiteColor forState:0];
    [btn setBackgroundColor:SEGMENT_COLOR];
}
-(void)unSelectBtnStatus:(UIButton *)btn{
     ViewBorderRadius(btn, 14, 1, KClearColor);
      [btn setTitleColor:COLOR_444444 forState:0];
      [btn setBackgroundColor:COLOR_F5F5F5];
}

- (IBAction)btnAction:(UIButton *)btn {
    //1010,1020,大于1000代表未选择，小于1000代表选择
        switch (btn.tag) {
            case 1010:{
                self.btn1.tag = 10;
                [self selectBtnStatus:btn];
                
                self.btn2.tag = 1020;
                [self unSelectBtnStatus:self.btn2];
                self.btn3.tag = 1030;
                [self unSelectBtnStatus:self.btn3];
                self.btn4.tag = 1040;
                [self unSelectBtnStatus:self.btn4];
            }
                break;
            case 1020:{
                self.btn2.tag = 20;
                [self selectBtnStatus:btn];
                
                self.btn1.tag = 1010;
                [self unSelectBtnStatus:self.btn1];
                self.btn3.tag = 1030;
                [self unSelectBtnStatus:self.btn3];
                self.btn4.tag = 1040;
                [self unSelectBtnStatus:self.btn4];
            }
                    
                break;
            case 1030:{
                self.btn3.tag = 30;
                [self selectBtnStatus:btn];
                
                self.btn2.tag = 1020;
                [self unSelectBtnStatus:self.btn2];
                self.btn1.tag = 1010;
                [self unSelectBtnStatus:self.btn1];
                self.btn4.tag = 1040;
                [self unSelectBtnStatus:self.btn4];
            }
                    
                break;
            case 1040:{
                self.btn4.tag = 40;
                [self selectBtnStatus:btn];
                
                self.btn2.tag = 1020;
                [self unSelectBtnStatus:self.btn2];
                self.btn3.tag = 1030;
                [self unSelectBtnStatus:self.btn3];
                self.btn1.tag = 1010;
                [self unSelectBtnStatus:self.btn1];
            }
                        
                break;
            default:
                break;
    }
}
@end
