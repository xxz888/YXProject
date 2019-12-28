//
//  YXBaseFaXianDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/26.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXBaseFaXianDetailViewController.h"
#import "HGPersonalCenterViewController.h"
#import "QiniuLoad.h"
#import "TJNoPingLunView.h"
#import "YXPingLunTableViewCell.h"
#import "YXPingLunDetailViewController.h"

@interface YXBaseFaXianDetailViewController ()<UITextFieldDelegate,SDTimeLineCellDelegate>
@property(nonatomic,strong)   TJNoPingLunView * noView;
@end

@implementation YXBaseFaXianDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ViewRadius(self.clickPingLunBtn, 10);
    _imageArr = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _pageArray = [[NSMutableArray alloc]init];
    
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXPingLunTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXPingLunTableViewCell"];
}

-(UIView *)noView{
    if (!_noView) {
         NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"TJNoPingLunView" owner:self options:nil];
        _noView = [nib objectAtIndex:0];
        _noView.frame = CGRectMake((KScreenWidth-250)/2, 50, 250, 178);
    }
    return _noView;
}
#pragma mark ========== tableview代理和所有方法 ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count == 0 ? 1 : self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return 1;
    }
    CGFloat cellHeight = [YXPingLunTableViewCell cellDefaultHeight:self.dataArray[indexPath.row]];
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        self.noView.center = cell.contentView.center;
        [cell.contentView addSubview:self.noView];
        return cell;
    }else{
        YXPingLunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXPingLunTableViewCell" forIndexPath:indexPath];
        cell.tag = indexPath.row;
        [cell setCellData:self.dataArray[indexPath.row]];
        //查看全部评论
        cell.seeAllblock = ^(NSInteger index) {
            YXPingLunDetailViewController * vc = [[YXPingLunDetailViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        //点赞
        cell.zanBlock = ^(NSInteger index) {
            [self zanCurrentCell:self.dataArray[index]];
        };
        //长按child某一条评论，弹出删除
        cell.pressLongChildCellBlock = ^(NSDictionary * dic) {
            [self pressLongCell:dic];
        };
        return cell;
//        SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
//          if (indexPath.row == 0) {
//              cell.bottomLine.hidden = YES;
//          }
//
//          cell.model = self.dataArray[indexPath.row];
//
//          CGFloat height1 = cell.model.moreCountPL.integerValue <= 0 ? 0 : 20;
//          [cell.showMoreCommentBtn setTitle:height1 == 0 ? @"" : @"显示更多回复 >>"  forState:UIControlStateNormal];
//          cell.showMoreCommentBtn.hidden = height1 == 0;
//
//
//          cell.indexPath = indexPath;
//          __weak typeof(self) weakSelf = self;
//          cell.imgBlock = ^(SDTimeLineCell * cell) {
//              NSDictionary * userInfo = userManager.loadUserAllInfo;
//              NSString * cellUserId = kGetString(cell.model.userID);
//              if ([kGetString(userInfo[@"id"]) isEqualToString:cellUserId]) {
//                  weakSelf.navigationController.tabBarController.selectedIndex = 3;
//                  return;
//              }
//              HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
//              mineVC.userId = cellUserId;
//              mineVC.whereCome = YES;    //  YES为其他人 NO为自己
//              [weakSelf.navigationController pushViewController:mineVC animated:YES];
//          };
//          if (!cell.moreButtonClickedBlock) {
//              [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
//
//                  SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
//                  model.isOpening = !model.isOpening;
//                  [weakSelf.yxTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//              }];
//
//              [cell setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell * cell) {
//
//
//                  if (![userManager loadUserInfo]) {
//                      KPostNotification(KNotificationLoginStateChange, @NO);
//                      return;
//                  }
//
//                   weakSelf.inputToolbar.placeholderLabel.text = [NSString stringWithFormat:@"  回复：%@", commentId];
//                  weakSelf.currentEditingIndexthPath = cell.indexPath;
//                  [weakSelf.inputToolbar.textInput becomeFirstResponder];
//                  weakSelf.isReplayingComment = YES;
//                  weakSelf.commentToUser = commentId;
//                  //[weakSelf adjustTableViewToFitKeyboard];
//              }];
//
//              [cell setDidLongClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell *cell,NSInteger tag) {
//
//                  if (![userManager loadUserInfo]) {
//                      KPostNotification(KNotificationLoginStateChange, @NO);
//                      return;
//                  }
//                  //在此添加你想要完成的功能
//                  QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {}];
//                  QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
//
//                      [weakSelf delePingLun:tag];
//
//                  }];
//                  QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleActionSheet];
//                  [alertController addAction:action1];
//                  [alertController addAction:action2];
//                  [alertController showWithAnimated:YES];
//              }];
//              cell.delegate = weakSelf;
//          }
//          ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
//          [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
//
//          cell.starView.hidden = YES;
          return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      if (![userManager loadUserInfo]) {
           KPostNotification(KNotificationLoginStateChange, @NO);
           return;
      }
      kWeakSelf(self);
      NSDictionary * userInfo = userManager.loadUserAllInfo;
      NSDictionary * dic = self.dataArray[indexPath.row];
      NSString * countent = [NSString stringWithFormat:@"%@:%@",dic[@"user_name"],dic[@"comment"]];
      UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
      }];
      UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
          [weakself huFuCurrentCell:dic];
      }];
     UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
         [weakself delCurrentCell:dic];
     }];
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"回复" message:countent preferredStyle:0];
      [alertController addAction:action1];
      [alertController addAction:action2];
      if ([kGetString(userInfo[@"id"]) integerValue] == [dic[@"user_id"] integerValue]) {
          [alertController addAction:action3];
      }
      [self presentViewController:alertController animated:YES completion:NULL];
}

-(void)huFuCurrentCell:(NSDictionary *)dic{
    
}
-(void)delCurrentCell:(NSDictionary *)dic{
    
}
-(void)zanCurrentCell:(NSDictionary *)dic{
  
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
-(void)pressLongDelChildCurrentCell:(NSDictionary *)dic{

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
    [self.yxTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
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
- (IBAction)guanzhuAction:(id)sender {
    [self guanzhuAction];
}
- (void)guanzhuAction{
    
}
- (void)saveImage:(UMSocialPlatformType)umType{
    UIImage* viewImage = nil;
    UITableView *scrollView = self.yxTableView;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);{
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    //先上传到七牛云图片  再提交服务器
    [QMUITips showLoadingInView:self.view];
    [QiniuLoad uploadImageToQNFilePath:@[viewImage] success:^(NSString *reslut) {
        [QMUITips hideAllTips];

           NSDictionary * userInfo = userManager.loadUserAllInfo;
           NSString * title = [NSString stringWithFormat:@"%@发布的内容@蓝皮书app",userInfo[@"username"]];
           NSString * desc = @"这篇内容真的很赞，快点开看!";
          [[ShareManager sharedShareManager] shareAllToPlatformType:umType obj:@{@"img":reslut,@"desc":desc,@"title":title,@"type":@"3"}];
    } failure:^(NSString *error) {
        
    }];
}
@end
