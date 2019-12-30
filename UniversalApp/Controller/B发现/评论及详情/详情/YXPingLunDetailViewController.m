//
//  YXPingLunDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/28.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXPingLunDetailViewController.h"
#import "YXChildPingLunTableViewCell.h"
#import "YXChildFootView.h"
#import "ZInputToolbar.h"
#import "HGPersonalCenterViewController.h"
@interface YXPingLunDetailViewController ()<ZInputToolbarDelegate,UITextFieldDelegate>
@property (nonatomic, strong) ZInputToolbar *inputToolbar;
@end

@implementation YXPingLunDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
    [self requestNewList];
}
-(void)requestNewList{
    kWeakSelf(self);
    //请求评价列表 最新评论列表
    [YX_MANAGER requestPost_comment:[self getParamters:@"1" page:@"1"] success:^(id object) {
        NSMutableArray * dataNewArray = [NSMutableArray array];
        dataNewArray = [weakself commonAction:object dataArray:dataNewArray];
        for (NSDictionary * dic in dataNewArray) {
            if ([kGetString(dic[@"id"]) isEqualToString:kGetString(weakself.startDic[@"id"])]) {
                weakself.startDic = [NSDictionary dictionaryWithDictionary:dic];
            }
        }
        [weakself changeZanStatus];
        [weakself requestMoreCigar_comment_child:kGetString(self.startDic[@"id"])];
    }];
}
-(NSString *)getParamters:(NSString *)type page:(NSString *)page{
    return [NSString stringWithFormat:@"%@/0/%@/%@/",type,self.startStartDic[@"id"],page];
}
#pragma mark ========== 更多评论 ==========
-(void)requestMoreCigar_comment_child:(NSString *)farther_id{
    kWeakSelf(self);
    NSString * string = [NSString stringWithFormat:@"%@/%ld",farther_id,self.requestPage];
    [YX_MANAGER requestPost_comment_child:string success:^(id object) {
        [weakself.dataArray removeAllObjects];
        //在这里要拼接数组，以显示头部和上一个界面的数组
        //添加头部
        [weakself.dataArray addObject:weakself.startDic];
        //添加已经显示过的list
        [weakself.dataArray addObjectsFromArray:weakself.startDic[@"child_list"]];
        //显示更多的list
        weakself.lastArray = [weakself commonAction:object dataArray:weakself.lastArray];
        [weakself.dataArray addObjectsFromArray:weakself.lastArray];
        
        weakself.pinglunTitle.text = [NSString stringWithFormat:@"%@条回复",kGetString(weakself.startDic[@"child_number"])];
        [weakself.yxTableView reloadData];

        [weakself.yxTableView.mj_footer endRefreshing];
        [weakself.yxTableView.mj_header endRefreshing];

    }];
}
//初始化控件
-(void)initControl{
    self.navigationController.navigationBar.hidden = YES;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXChildPingLunTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXChildPingLunTableViewCell"];
    [self addShadowToView:self.bottomView withColor:kRGBA(102, 102, 102, 0.08)];
    self.lastArray = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];

    [self addRefreshView:self.yxTableView];

    NSDictionary * userInfo = userManager.loadUserAllInfo;
    [self.bottomMySelfImv sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:userInfo[@"photo"]]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
    [self changeZanStatus];
}
-(void)changeZanStatus{
    //F蓝色已点赞 F灰色未点赞
    [self.zanBtn setImage:[self.startDic[@"is_praise"] integerValue] == 0 ? IMAGE_NAMED(@"F灰色未点赞") : IMAGE_NAMED(@"F蓝色已点赞") forState:0];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestNewList];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestNewList];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = [YXChildPingLunTableViewCell cellDefaultHeight:self.dataArray[indexPath.row]];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   YXChildPingLunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXChildPingLunTableViewCell" forIndexPath:indexPath];
    cell.plZan.hidden = YES;
    cell.lineView.hidden = indexPath.row == 0;
    cell.contentView.backgroundColor = indexPath.row == 0 ? KWhiteColor : COLOR_F5F5F5;
    cell.tag = indexPath.row;
    [cell setCellData:self.dataArray[indexPath.row]];
    //长按child某一条评论，弹出删除
    cell.pressLongChildCellBlock = ^(NSDictionary * dic) {
        [self pressLongCell:dic];
    };
    //点击头像
    cell.tagTitleImvCellBlock = ^(NSString * userId) {
        [self clickUserImageView:userId];
    };
    return cell;
}
#pragma mark ========== 头像点击 ==========
-(void)clickUserImageView:(NSString *)userId{
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    if ([kGetString(userInfo[@"id"]) isEqualToString:userId]) {
        self.navigationController.tabBarController.selectedIndex = 3;
        return;
    }
    HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
    mineVC.userId = userId;
    mineVC.whereCome = YES;    //  YES为其他人 NO为自己
    [self.navigationController pushViewController:mineVC animated:YES];
}
-(void)pressLongCell:(NSDictionary *)dic{
   if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
   }
   kWeakSelf(self);
   NSDictionary * userInfo = userManager.loadUserAllInfo;
    NSString * countent = [NSString stringWithFormat:@"%@:%@",dic[@"user_name"],dic[@"comment"]];
   UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
   }];
   UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
       [weakself pressLongDelChildCurrentCell:dic];
   }];
   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除" message:countent preferredStyle:0];
   if ([kGetString(userInfo[@"id"]) integerValue] == [dic[@"user_id"] integerValue]) {
       [alertController addAction:action3];
       [alertController addAction:action1];
       [self presentViewController:alertController animated:YES completion:NULL];
   }
}
#pragma mark ========== tableview 点赞按钮 ==========
-(void)zanCurrentCell:(NSDictionary *)dic{
        kWeakSelf(self);
        [YX_MANAGER requestPost_comment_praisePOST:@{@"comment_id":kGetString(dic[@"id"])} success:^(id object) {
            [weakself requestNewList];
        }];
}
#pragma mark ========== 评论最外层晒图 ==========
-(void)pinglunFatherPic:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestPost_commentPOST:dic success:^(id object) {
         [weakself requestNewList];
    }];
}
#pragma mark ========== 回复某一个cell的 ==========
-(void)huFuCurrentCell:(NSDictionary *)dic{
     [self setupTextField];
     [self.inputToolbar.textInput becomeFirstResponder];
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
        [self requestpost_comment_child:@{@"comment":textField.text,
                                          @"father_id":kGetString(self.startDic[@"id"]),
                                          @"aim_id":kGetString(self.startDic[@"user_id"]),
                                          @"aim_name":self.startDic[@"user_name"]
                                          }];
}
//#pragma mark ========== 评论子评论 ==========
-(void)requestpost_comment_child:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestpost_comment_childPOST:dic success:^(id object) {
        [weakself requestNewList];
    }];
}
#pragma mark ========== 删除某一个cell ==========
-(void)delCurrentCell:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestDelFatherPl_ShaiTu:kGetString(dic[@"id"]) success:^(id object) {
          [QMUITips showSucceed:@"删除成功"];
          [weakself requestNewList];
    }];
}
#pragma mark ========== 删除某一个cell的自己的子评论 ==========
-(void)pressLongDelChildCurrentCell:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestDelChildPl_ShaiTu:kGetString(dic[@"id"]) success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        [weakself requestNewList];
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
    [self zanCurrentCell:self.startDic];
}
@end
