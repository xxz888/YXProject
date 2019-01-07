//
//  YXHomeXueJiaPinPaiDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/7.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiDetailViewController.h"
#import "YXHomeXueJiaDetailTableViewCell.h"

@implementation YXHomeXueJiaPinPaiDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    

    [self.tableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaDetailTableViewCell"];
    
    [self.tableView reloadData];
    
    NSDictionary * cellData = self.dicStartData;
    self.title = cellData[@"cigar_brand"];

    [self.section1ImageView sd_setImageWithURL:[NSURL URLWithString:cellData[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.section1ImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.section1TextView.text = kGetString(cellData[@"intro"]);
    self.section1countLbl.text = [kGetString(cellData[@"concern_number"]) append:@" 人关注"];
    self.section1TitleLbl.text = [NSString stringWithFormat:@"%@/%@",cellData[@"sort"],cellData[@"cigar_brand"]];
    
    
    ViewBorderRadius(self.section1GuanZhuBtn, 5, 1, self.section1GuanZhuBtn.titleLabel.textColor);
}





//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){//
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return [self.dicData[@"data"] count];//商品颜色的数组
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        NSDictionary * cellData = self.dicData[@"data"][indexPath.row];
        YXHomeXueJiaDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaDetailTableViewCell" forIndexPath:indexPath];
        [cell.section2ImageView sd_setImageWithURL:[NSURL URLWithString:cellData[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
//        [cell.section2ImageView setContentMode:UIViewContentModeScaleAspectFit];
        cell.section2TitleLbl.text = cellData[@"cigar_name"];
        cell.section2Lbl1.text = kGetString(cellData[@"ring_gauge"]) ;
        cell.section2Lbl2.text = kGetString(cellData[@"length"]);
        cell.section2Lbl3.text = kGetString(cellData[@"shape"]);
        cell.section2Lbl4.text = [kGetString(cellData[@"price_box_china"]) append:@"元"];
        cell.section2Lbl5.text = [kGetString(cellData[@"price_single_china"]) append:@"/支"];
        cell.section2Lbl6.text = [NSString stringWithFormat:@"%@元/盒\n(%@)支",cellData[@"price_box_china"],cellData[@"box_size"]];

        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 250;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
#pragma mark ========== 关注作者的方法 ==========
- (IBAction)section1GuanZhuAction:(id)sender {
    
}
@end
