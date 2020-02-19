//
//  YXChildPingLunViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/23.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXChildPingLunViewController.h"
#import "YXChildHeadView.h"
#import "YXChildFootView.h"
#import "YXChildPingLunTableViewCell.h"
#import "YXDingZhiDetailTableViewCell.h"
#import "ZInputToolbar.h"

@interface YXChildPingLunViewController ()<ZInputToolbarDelegate>
@property (nonatomic,strong)  YXDingZhiDetailTableViewCell * cell;
@property (nonatomic, strong) ZInputToolbar *inputToolbar;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation YXChildPingLunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
    [self getChildData];
}
//初始化控件
-(void)initControl{
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXChildPingLunTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXChildPingLunTableViewCell"];
    [self.yxTableView reloadData];
    [self addShadowToView:self.bottomView withColor:kRGBA(102, 102, 102, 0.08)];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXDingZhiDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXDingZhiDetailTableViewCell"];
    [self addRefreshView:self.yxTableView];
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    [self.bottomMySelfImv sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:userInfo[@"photo"]]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
    
    BOOL isp =  [self.startDic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ?  IMAGE_NAMED(@"F蓝色已点赞") : IMAGE_NAMED(@"F灰色未点赞") ;
    [self.zanBtn setBackgroundImage:likeImage forState:UIControlStateNormal];

}
-(void)headerRereshing{
    [super headerRereshing];
    [self getChildData];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self getChildData];
}
-(void)getChildData{
    NSString * par = [NSString stringWithFormat:@"page=%ld&father_id=%@",
                      (long)self.requestPage,self.startDic[@"id"]];
    kWeakSelf(self);
    [YXPLUS_MANAGER getShopBusiness_comment_childSuccess:par success:^(id object) {
        [weakself.yxTableView.mj_header endRefreshing];
        [weakself.yxTableView.mj_footer endRefreshing];
         weakself.dataArray = [weakself commonAction:object[@"data"] dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
-(YXDingZhiDetailTableViewCell *)cell{
    if (!_cell) {
        _cell = [[[NSBundle mainBundle]loadNibNamed:@"YXDingZhiDetailTableViewCell" owner:self options:nil]lastObject];
    }
    return _cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = [YXChildPingLunTableViewCell cellDefaultHeight:self.dataArray[indexPath.row]];
     return cellHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self.cell setCellData:self.startDic];
    _cell.zanBtn.hidden = _cell.talkBtn.hidden = YES;
    return self.cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat cellHeight = [YXDingZhiDetailTableViewCell cellDefaultHeight:self.startDic];
    return cellHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXChildFootView" owner:self options:nil];
    YXChildFootView * footView = [nib objectAtIndex:0];
    return footView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 46;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXChildPingLunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXChildPingLunTableViewCell" forIndexPath:indexPath];
    [cell setCellShopData:self.dataArray[indexPath.row]];
    cell.tag = indexPath.row;
    cell.plZan.userInteractionEnabled = YES;
    kWeakSelf(self);
    cell.zanBlock = ^(NSInteger index) {
        NSIndexPath * indexPathSelect = [NSIndexPath indexPathForRow:index  inSection:0];
        YXChildPingLunTableViewCell * cell = [weakself.yxTableView cellForRowAtIndexPath:indexPathSelect];
        //赞
        BOOL isp =  [weakself.dataArray[index][@"is_praise"] integerValue] == 1;
        UIImage * likeImage = isp ?  IMAGE_NAMED(@"F灰色未点赞") : IMAGE_NAMED(@"F蓝色已点赞");
        [cell.plZan setBackgroundImage:likeImage forState:UIControlStateNormal];
        
        NSString * comment_id = kGetString(weakself.dataArray[index][@"id"]);
        [YXPLUS_MANAGER clickShopBusiness_comment_praiseSuccess:@{@"comment_id":comment_id,@"type":@"2"} success:^(id object) {
            [weakself getChildData];
        }];
    };
    return cell;
}
-(void)getShopPingLunList{
    NSString * par = [NSString stringWithFormat:@"page=%ld&business_id=%@&type=%@",(long)self.requestPage,self.startDic[@"id"],@"1"];
    kWeakSelf(self);
    [YXPLUS_MANAGER getShopBusiness_commentSuccess:par success:^(id object) {
      [weakself.yxTableView.mj_header endRefreshing];
      [weakself.yxTableView.mj_footer endRefreshing];
      weakself.dataArray = [weakself commonAction:object[@"data"] dataArray:weakself.dataArray];
      [weakself.yxTableView reloadData];
    }];
}
- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,-4);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 1;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 5;
    theView.layer.cornerRadius = 5;
    
}
- (IBAction)zanAction:(id)sender {
    //赞
    BOOL isp =  [self.startDic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ?  IMAGE_NAMED(@"F灰色未点赞") : IMAGE_NAMED(@"F蓝色已点赞");
    [self.zanBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    NSString * comment_id = kGetString(self.startDic[@"id"]);
    [YXPLUS_MANAGER clickShopBusiness_comment_praiseSuccess:@{@"comment_id":comment_id,@"type":@"1"} success:^(id object) {
    }];
}



- (IBAction)clickPingLunAction:(id)sender{
    [self setupTextField];
    [self.inputToolbar.textInput becomeFirstResponder];
}
- (void)setupTextField{
    [self.inputToolbar removeFromSuperview];
    self.inputToolbar = [[ZInputToolbar alloc] initWithFrame:CGRectMake(0,self.view.height, self.view.width, 60)];
    self.inputToolbar.textViewMaxLine = 5;
    self.inputToolbar.delegate = self;
    self.inputToolbar.placeholderLabel.text = @"开始评论...";
    [self.view addSubview:self.inputToolbar];
}
#pragma mark - ZInputToolbarDelegate
-(void)inputToolbar:(ZInputToolbar *)inputToolbar sendContent:(NSString *)sendContent {
    [self finishTextView:inputToolbar.textInput];
    // 清空输入框文字
    [self.inputToolbar sendSuccessEndEditing];
}
#pragma mark - UITextFieldDelegate
-(void)finishTextView:(UITextView *)textField{
    kWeakSelf(self);
    [YXPLUS_MANAGER addShopBusiness_comment_childSuccess:
                                                    @{@"comment":textField.text,
                                                    @"father_id":kGetString(self.startDic[@"id"]),
                                                    @"publish_time":[ShareManager getNowTimeMiaoShu],
                                                    } success:^(id object) {
             [weakself getChildData];
    }];
}



@end
