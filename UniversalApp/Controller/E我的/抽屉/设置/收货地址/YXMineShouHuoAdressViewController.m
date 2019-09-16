//
//  YXMineShouHuoAdressViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineShouHuoAdressViewController.h"
#import "YXMineShouHuoTableViewCell.h"

@interface YXMineShouHuoAdressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;

@end

@implementation YXMineShouHuoAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineShouHuoTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineShouHuoTableViewCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 146;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineShouHuoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineShouHuoTableViewCell" forIndexPath:indexPath];
    return cell;
}
- (IBAction)backVc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
