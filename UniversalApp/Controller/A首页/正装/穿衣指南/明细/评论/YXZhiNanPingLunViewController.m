//
//  YXZhiNanPingLunViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/11.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNanPingLunViewController.h"
#import "YXChildPingLunTableViewCell.h"
#import "YXChildFootView.h"
#import "ZInputToolbar.h"
#import "TJNoPingLunView.h"
#import "HGPersonalCenterViewController.h"
@interface YXZhiNanPingLunViewController ()<ZInputToolbarDelegate,QMUIMoreOperationControllerDelegate>
@property (nonatomic, strong) ZInputToolbar *inputToolbar;
@property(nonatomic,strong)   TJNoPingLunView * noView;

@end

@implementation YXZhiNanPingLunViewController
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
    NSString * par = [NSString stringWithFormat:@"obj=1&target_id=%@&page=%@",self.startDic[@"id"],NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestPubSearchAndDelComment:par success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView.mj_header endRefreshing];
        [weakself.yxTableView.mj_footer endRefreshing];
        [weakself.yxTableView reloadData];
    }];
}
//初始化控件
-(void)initControl{
    self.navigationController.navigationBar.hidden = YES;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXChildPingLunTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXChildPingLunTableViewCell"];
    [self.yxTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [self addShadowToView:self.bottomView withColor:kRGBA(102, 102, 102, 0.08)];
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
    if (self.dataArray.count == 0) {
           return KScreenHeight - kTopHeight - 50 - TabBarHeight;
    }
    CGFloat cellHeight = [YXChildPingLunTableViewCell cellDefaultHeight:self.dataArray[indexPath.row]];
     return cellHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.dataArray.count != 0) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXChildFootView" owner:self options:nil];
        YXChildFootView * footView = [nib objectAtIndex:0];
        return footView;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count == 0 ? 1 : self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   return self.dataArray.count == 0 ? 0 : 46;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
          UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
          cell.userInteractionEnabled = NO;
          self.noView.center = cell.contentView.center;
          [cell.contentView addSubview:self.noView];
          return cell;
      }else{
           YXChildPingLunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXChildPingLunTableViewCell" forIndexPath:indexPath];
            cell.plZan.hidden = YES;
            cell.contentView.backgroundColor = KWhiteColor ;
            cell.tag = indexPath.row;
            cell.lineView.backgroundColor = COLOR_EEEEEE;
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
    [YX_MANAGER requestPubFaBuPingLunComment:@{@"comment":textField.text,
                                                    @"target_id":kGetString(self.startDic[@"id"]),
                                                    @"obj":@"1",} success:^(id object) {
             [weakself requestNewList];
    }];
}
#pragma mark ========== 删除评论==========
-(void)pressLongDelChildCurrentCell:(NSDictionary *)dic{
    kWeakSelf(self);
    NSString * str = [NSString stringWithFormat:@"target_id=%@",kGetString(dic[@"id"])];
    [YX_MANAGER requestPubSearchAndDelComment:str success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        [weakself requestNewList];
    }];
}

- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    NSString * string = [NSString stringWithFormat:@"%ld",[self.dataArray count]];
    self.pinglunBlock(string);
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

-(UIView *)noView{
    if (!_noView) {
         NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"TJNoPingLunView" owner:self options:nil];
        _noView = [nib objectAtIndex:0];
        _noView.frame = CGRectMake((KScreenWidth-250)/2, 50, 250, 178);
    }
    return _noView;
}

























//
//
//
//-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
//     return self;
//}
//-(void)backBtnClicked{
//    [super backBtnClicked];
//    NSString * string = [NSString stringWithFormat:@"%ld",[self.dataArray count]];
//    self.pinglunBlock(string);
//}
//- (void)viewDidLoad{
//    [super viewDidLoad];
//    //初始化所有的控件
//    [self initAllControl];
//    [self requestNewList];
//    self.title = @"评论";
//    self.pinglunView1.hidden = YES;
//    self.pinglunView2.hidden = NO;
//
//
//    NSDictionary * userInfo = userManager.loadUserAllInfo;
//    [self.pinglunView2TitleImv sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:userInfo[@"photo"]]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
//}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//    self.coustomNavView.hidden = YES;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.shareBtn.hidden = self.backBtn.hidden = self.imgShareBtn.hidden = YES;
//}
//-(void)headerRereshing{
//    [super headerRereshing];
//    [self requestNewList];
//}
//-(void)footerRereshing{
//    [super footerRereshing];
//    [self requestNewList];
//}
//-(void)initAllControl{
//    [super initAllControl];
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.dataArray.count == 0) {
//        return KScreenHeight - kTopHeight - 50 - TabBarHeight;
//    }
//    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXChildFootView" owner:self options:nil];
//    YXChildFootView * footView = [nib objectAtIndex:0];
//    return footView;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 46;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.1;
//}
//#pragma mark ========== 获取晒图评论列表 ==========
//-(void)requestNewList{
//    kWeakSelf(self);
//    //请求评价列表 最新评论列表
//    NSString * par = [NSString stringWithFormat:@"obj=1&target_id=%@&page=%@",self.startId,NSIntegerToNSString(self.requestPage)];
//    [YX_MANAGER requestPubSearchAndDelComment:par success:^(id object) {
//        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
//        [weakself.yxTableView.mj_header endRefreshing];
//        [weakself.yxTableView.mj_footer endRefreshing];
//        [weakself  refreshTableView];
//    }];
//}
//-(void)refreshTableView{
//    [self.yxTableView reloadData];
//}
//#pragma mark ========== 评论子评论 ==========
//-(void)requestpost_comment_child:(NSDictionary *)dic{
//    kWeakSelf(self);
//    [YX_MANAGER requestPubFaBuChildPingLunComment:dic success:^(id object) {
//        [weakself requestNewList];
//    }];
//}
//#pragma mark ========== 评论 ==========
//-(void)pinglunFatherPic:(NSDictionary *)dic{
//    kWeakSelf(self);
//    [YX_MANAGER requestPubFaBuPingLunComment:dic success:^(id object) {
//        [weakself requestNewList];
//    }];
//}
//-(void)delePingLun:(NSInteger)tag{
//    kWeakSelf(self);
//    [YX_MANAGER requestPubSearchAndDelChildComment:NSIntegerToNSString(tag) success:^(id object) {
//        [QMUITips showSucceed:@"删除成功"];
//        [weakself requestNewList];
//    }];
//}
//-(void)deleFather_PingLun:(NSString *)tag{
//    kWeakSelf(self);
//    NSString * str = [NSString stringWithFormat:@"target_id=%@",tag];
//    [YX_MANAGER requestPubSearchAndDelComment:str success:^(id object) {
//        [QMUITips showSucceed:@"删除成功"];
//        [weakself requestNewList];
//    }];
//}
//
//- (IBAction)clickPingLunAction:(id)sender{
//    [self setupTextField];
//    [self.inputToolbar.textInput becomeFirstResponder];
//}
//
//- (void)setupTextField{
//    [self.inputToolbar removeFromSuperview];
//    self.inputToolbar = [[ZInputToolbar alloc] initWithFrame:CGRectMake(0,self.view.height, self.view.width, 60)];
//    self.inputToolbar.textViewMaxLine = 5;
//    self.inputToolbar.delegate = self;
//    self.inputToolbar.placeholderLabel.text = @"开始评论...";
//    [self.view addSubview:self.inputToolbar];
//}
#pragma mark - ZInputToolbarDelegate
//-(void)inputToolbar:(ZInputToolbar *)inputToolbar sendContent:(NSString *)sendContent {
//    [self finishTextView:inputToolbar.textInput];
//    // 清空输入框文字
//    [self.inputToolbar sendSuccessEndEditing];
//}
#pragma mark - UITextFieldDelegate
//-(void)finishTextView:(UITextView *)textField{
//    if (self.isReplayingComment) {
//        SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
//        [self requestpost_comment_child:@{@"comment":textField.text,
//                                          @"father_id":@([model.id intValue]),
//                                          @"aim_id":self.commentToUserID,
//                                          }];
//        self.isReplayingComment = NO;
//    }else{
//        [self pinglunFatherPic:@{@"comment":textField.text,
//                                 @"target_id":self.startId,
//                                 @"obj":@"1"
//                                 }];
//
//    }
//}

@end
