//
//  YXBaseFaXianDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/26.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXBaseFaXianDetailViewController.h"
#import "HGPersonalCenterViewController.h"

@interface YXBaseFaXianDetailViewController ()<UITextFieldDelegate,SDTimeLineCellDelegate>

@end

@implementation YXBaseFaXianDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ViewRadius(self.clickPingLunBtn, 10);
    _imageArr = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _pageArray = [[NSMutableArray alloc]init];
}


#pragma mark ========== tableview代理和所有方法 ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    if (indexPath.row == 0) {
        cell.bottomLine.hidden = YES;
    }

    cell.model = self.dataArray[indexPath.row];

    CGFloat height1 = cell.model.moreCountPL.integerValue <= 0 ? 0 : 20;
    [cell.showMoreCommentBtn setTitle:height1 == 0 ? @"" : @"显示更多回复 >>"  forState:UIControlStateNormal];
    cell.showMoreCommentBtn.hidden = height1 == 0;
    

    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    cell.imgBlock = ^(SDTimeLineCell * cell) {
        NSDictionary * userInfo = userManager.loadUserAllInfo;
        NSString * cellUserId = kGetString(cell.model.userID);
        if ([kGetString(userInfo[@"id"]) isEqualToString:cellUserId]) {
            weakSelf.navigationController.tabBarController.selectedIndex = 3;
            return;
        }
        HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
        mineVC.userId = cellUserId;
        mineVC.whereCome = YES;    //  YES为其他人 NO为自己
        [weakSelf.navigationController pushViewController:mineVC animated:YES];
    };
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            
            SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.yxTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell * cell) {
            
            
            if (![userManager loadUserInfo]) {
                KPostNotification(KNotificationLoginStateChange, @NO);
                return;
            }
            
             weakSelf.inputToolbar.placeholderLabel.text = [NSString stringWithFormat:@"  回复：%@", commentId];
            weakSelf.currentEditingIndexthPath = cell.indexPath;
            [weakSelf.inputToolbar.textInput becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;
            //[weakSelf adjustTableViewToFitKeyboard];
        }];
        
        [cell setDidLongClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell *cell,NSInteger tag) {
            
            if (![userManager loadUserInfo]) {
                KPostNotification(KNotificationLoginStateChange, @NO);
                return;
            }
            //在此添加你想要完成的功能
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {}];
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                
                [weakSelf delePingLun:tag];

            }];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleActionSheet];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController showWithAnimated:YES];
        }];
        cell.delegate = weakSelf;
    }
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    cell.starView.hidden = YES;
    

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    
    kWeakSelf(self);
    //在此添加你想要完成的功能
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {}];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"回复" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
        [weakself setupTextField];
        SDTimeLineCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        weakself.currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
        SDTimeLineCellModel * model = self.dataArray[self.currentEditingIndexthPath.row];
        weakself.inputToolbar.placeholderLabel.text = [NSString stringWithFormat:@"  回复：%@",model.name];
        weakself.currentEditingIndexthPath = cell.indexPath;
        [weakself.inputToolbar.textInput becomeFirstResponder];
        weakself.isReplayingComment = YES;
        weakself.commentToUser = model.name;
        weakself.commentToUserID = model.userID;
//        [weakself adjustTableViewToFitKeyboard];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        SDTimeLineCellModel * model = weakself.dataArray[weakself.currentEditingIndexthPath.row];
        [weakself deleFather_PingLun:model.id];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"操作" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];

    [alertController showWithAnimated:YES];
    
    
    

    
}

-(void)delePingLun:(NSInteger)tag{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    SDTimeLineCellModel * model = self.dataArray[indexPath.row];
    CGFloat height1 = model.moreCountPL.integerValue <= 0 ? 0 : 20;

    return [self.yxTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]] + height1;
}
- (CGFloat)cellContentViewWith{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.inputToolbar.textInput resignFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.inputToolbar.textInput resignFirstResponder];
    [self.inputToolbar.textInput removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)dealloc{
    //移除KVO
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)initAllControl{
    kWeakSelf(self);
    self.title = @"";
    self.segmentIndex = 0;
    [self.yxTableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    self.yxTableView.estimatedRowHeight = 0;
    self.yxTableView.estimatedSectionHeaderHeight = 0;
    self.yxTableView.estimatedSectionFooterHeight = 0;
    self.yxTableView.tableFooterView = [[UIView alloc]init];
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;
}
- (void)deallocsetContentViewValue{
    [self.textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)fenxiangAction:(id)sender {
    [self fenxiangAction];
}
- (IBAction)dianzanAction:(id)sender {
    [self dianzanAction];

}
- (IBAction)shareAction:(id)sender{
    [self shareAction];

}
- (void)fenxiangAction{
    
}
- (void)dianzanAction{
    
}
- (IBAction)backVCAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareAction{
    
}
@end
