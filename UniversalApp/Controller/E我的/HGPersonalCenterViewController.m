//
//  HGPersonalCenterViewController.m
//  HGPersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "HGPersonalCenterViewController.h"
#import "YXMineHeaderView.h"
#import "YXMineFenSiViewController.h"
#import "YXMineGuanZhuViewController.h"
#import "YXMineAllViewController.h"
#import "YXHomeEditPersonTableViewController.h"
#import "YXMineMyCollectionViewController.h"
#import "YXMineSettingTableViewController.h"
#import "YXMineMyCaoGaoViewController.h"
#import "YXMineMyDianZanViewController.h"
#import "YXMineFindViewController.h"
#import "YXMineMyCollectionViewController.h"
#import "YXMineJiFenTableViewController.h"
#import "YXMineChouJiangViewController.h"
#import "YXJiFenShopViewController.h"
#import "SimpleChatMainViewController.h"
#import "HGPersonalCenterTableViewCell.h"
#import "SDPhotoBrowser.h"
#import "QiniuLoad.h"
#import "YXFindSearchTagDetailViewController.h"
#import "XLVideoPlayer.h"
#import "YXMineImageDetailViewController.h"
#import "YXPublishImageViewController.h"
#import "YXWenZhangEditorViewController.h"
#import "YXXinDongTaiView.h"
#import "YXZhiNanDetailViewController.h"
#import "YXZhiNanViewController.h"
#import "HGPersonal1TableViewCell.h"
#import "BaseAlertController.h"

#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]
#import "YXFirstFindImageTableViewCell.h"
#import "LZMenuButton.h"

#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)

@interface HGPersonalCenterViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,SDPhotoBrowserDelegate,lzMenuDelegate>{
    QMUIModalPresentationViewController * _modalViewController;
    NSArray * titleArray;
    CGFloat HeaderImageViewHeight;
    CGFloat _oldY;
    BOOL _tagSelectBool;
    XLVideoPlayer *_player;
    NSInteger _selectRow;
    NSString * _sort;
    BOOL _selectIndexBool;
}
@property (nonatomic,strong) YXXinDongTaiView * dongtaiView;
@property (nonatomic, strong) NSDictionary *shareDic;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic) BOOL cannotScroll;
@property (nonatomic, strong) YXMineHeaderView * headerView;
@property(nonatomic, strong) UserInfo *userInfo;//用户信息
@property(nonatomic, strong) NSDictionary *userInfoDic;//用户信息
@property (nonatomic) BOOL isCanBack;
@property (nonatomic, strong) NSMutableArray *picPathStringsArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) NSInteger  downSelectIndex;
@property (nonatomic,strong)LZMenuButton *menuBtn;
@end

@implementation HGPersonalCenterViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _selectIndexBool = NO;
    _downSelectIndex = 2001;
    HeaderImageViewHeight = 276 + kStatusBarHeight;
    self.controllerHeaderViewHeight.constant = 44 + kStatusBarHeight;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.controllerHeaderView.hidden = YES;
    [self createTableView];
    [self setViewData];
    [self requestTableData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (YX_MANAGER.isNeedRefrshMineVc) {
        [self setViewData];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)requestTableData{
    if (_selectIndexBool) {
        [self requestMyCollectionListGet];
    }else{
        
        self.whereCome ? [self requestOther_AllList] : [self requestMine_AllList];
    }
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestTableData];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestTableData];
}
-(void)requestMyCollectionListGet{
    [QMUITips showLoadingInView:kAppWindow];
    kWeakSelf(self);
    NSString * obj = _downSelectIndex == 2001 ? @"1" : _downSelectIndex == 2002 ? @"2" :@"3";
    NSString * par = [NSString stringWithFormat:@"obj=%@&page=%@",obj,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestMyXueJia_CollectionListGet:par success:^(id object) {
       weakself.dataArray = [weakself commonAction:object[@"data"] dataArray:weakself.dataArray];
       [weakself.yxTableView reloadData];
       [QMUITips hideAllTips];
       [weakself endRefresh];
   }];
}
#pragma mark ========== 我自己的所有 ==========
-(void)requestMine_AllList{
    [QMUITips showLoadingInView:kAppWindow];
    kWeakSelf(self);
    NSString * parString =[NSString stringWithFormat:@"0&page=%@",NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGet_users_find:parString success:^(id object){
        [QMUITips hideAllTips];
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        if (_selectRow > -1) {
            [weakself.yxTableView reloadRow:_selectRow inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            _selectRow = -1;
        }else{
            [UIView performWithoutAnimation:^{
            [weakself.yxTableView reloadData];
            }];
        }
        [weakself setViewData];
        weakself.dongtaiView.hidden =  weakself.dataArray.count != 0;
    }];
}
#pragma mark ========== 其他用户的所有 ==========
-(void)requestOther_AllList{
    [QMUITips showLoadingInView:kAppWindow];
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",self.userId,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGetSers_Other_AllList:par success:^(id object){
        [QMUITips hideAllTips];
        weakself.dataArray =  [weakself commonAction:object dataArray:weakself.dataArray];
       if (_selectRow > -1) {
             [weakself.yxTableView reloadRow:_selectRow inSection:0 withRowAnimation:UITableViewRowAnimationNone];
           _selectRow = -1;
         }else{
             [UIView performWithoutAnimation:^{ [weakself.yxTableView reloadData];}];}
                weakself.nodataImg.hidden = weakself.dataArray.count != 0;
        [weakself setViewData];

    }];
}
- (void)loginStateChange:(NSNotification *)notification{
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) {
        [self setViewData];
    }
}
#pragma mark ========== 点击菜单按钮的方法 ==========
- (void)handleShowContentView {
    kWeakSelf(self);
    if (self.whereCome) {
        [YX_MANAGER requestGetUserothers:self.userId success:^(id object) {
            [weakself commonShowContentView:object];
        }];
    }else{
        [weakself commonShowContentView:@{@"is_black":@"0"}];
    }


}
-(void)commonShowContentView:(NSDictionary *)object{
            kWeakSelf(self);
             UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
             }];
             UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                 [weakself addGuanjiaShareView];
             }];
             UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"草稿箱" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                 YXMineMyCaoGaoViewController * VC = [[YXMineMyCaoGaoViewController alloc]init];
                 [weakself.navigationController pushViewController:VC animated:YES];
             }];
            BOOL isBlack = [object[@"is_black"] integerValue] == 0;
            NSString * laheiString = isBlack ? @"拉黑此用户" : @"解除拉黑";
            UIAlertAction *action4 = [UIAlertAction actionWithTitle:laheiString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [YXPLUS_MANAGER requestBlackGet:weakself.userId success:^(id object) {
                    [QMUITips showSucceed:isBlack ? @"已拉黑" : @"已解除拉黑"];
                }];
            }];
            UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"举报此用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       //         [moreOperationController hideToBottom];
                QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                }];
                QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"不友善内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                    [QMUITips showSucceed:@"举报成功"];
                }];
                QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"有害内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                    [QMUITips showSucceed:@"举报成功"];
                }];
                QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"抄袭内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                    [QMUITips showSucceed:@"举报成功"];
                }];
                QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
                [alertController addAction:action1];
                [alertController addAction:action2];
                [alertController addAction:action3];
                [alertController addAction:action4];
                [alertController showWithAnimated:YES];
            }];
             BaseAlertController * alertController = [BaseAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
             [alertController addAction:action2];
             
           if (weakself.whereCome) {
               [alertController addAction:action4];
               [alertController addAction:action5];
           }else{
               [alertController addAction:action3];
           }
             [alertController addAction:action1];

             if (IS_IPAD) {
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
                 CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
                 CGRect cellRectInSelfView = [self.view convertRect:cellRect fromView:self.tableView];
                 alertController.popoverPresentationController.sourceView = self.view;
                 alertController.popoverPresentationController.sourceRect = cellRectInSelfView;
             }
           [weakself presentViewController:alertController animated:YES completion:^{}];
}
- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)headerViewBlockAction{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];

    kWeakSelf(self);
    _headerView.guanzhublock = ^{
 
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
        YXMineGuanZhuViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineGuanZhuViewController"];
        VC.userId = weakself.userId;
        [weakself.navigationController pushViewController:VC animated:YES];
    };
    
    
    _headerView.fensiblock = ^{
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
        YXMineFenSiViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineFenSiViewController"];
        VC.userId = weakself.userId;
        [weakself.navigationController pushViewController:VC animated:YES];
    };
    
    _headerView.guanZhuOtherblock = ^{
        [weakself setGuanzhuCommonAction];
    };
    
    _headerView.editPersionblock = ^{
        YXMineJiFenTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineJiFenTableViewController"];
        VC.backvcBlock = ^{
            [weakself setViewData];
        };
        [weakself.navigationController pushViewController:VC animated:YES];
    };
    
    _headerView.setblock = ^{
        [weakself handleShowContentView];
    };
    
    _headerView.mineBackVCBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    _headerView.settingBlock = ^{
        YXMineSettingTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineSettingTableViewController"];
        [weakself.navigationController pushViewController:VC animated:YES];
    };
    _headerView.mineClickImageblock = ^{
        //如果是其他人，就是放大头像
        if(weakself.whereCome){
               SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
               browser.currentImageIndex = weakself.headerView.tag;
               browser.sourceImagesContainerView = weakself.headerView;
               browser.imageCount = weakself.picPathStringsArray.count;
               browser.delegate = weakself;
               [browser show];
        }else{
            
              YXHomeEditPersonTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXHomeEditPersonTableViewController"];
               VC.userInfoDic = [NSDictionary dictionaryWithDictionary:userManager.loadUserAllInfo];
               VC.backvcBlock = ^{[weakself setViewData];};
               [weakself.navigationController pushViewController:VC animated:YES];
        }
   
    };
    _headerView.shangchengblock = ^{
        YXJiFenShopViewController * vc = [[YXJiFenShopViewController alloc]init];
            [YXPLUS_MANAGER requestIntegral_Commodity_recommendGet:@"" success:^(id object) {
                vc.lunboArray = [[NSMutableArray alloc]initWithArray:object[@"data"]];
                [weakself.navigationController pushViewController:vc animated:YES];
            }];
    };
    _headerView.selectSegmentblock = ^(NSInteger selectIndex) {
        _selectIndexBool = selectIndex == 1;
        weakself.requestPage = 1;
        [weakself.dataArray removeAllObjects];
        [weakself requestTableData];

        
        //动态
        if (selectIndex == 0) {
            HeaderImageViewHeight = 276 + kStatusBarHeight;
            weakself.headerView.zhinanBtn.hidden = weakself.headerView.shoucangdongtaiBtn.hidden = weakself.headerView.huatiBtn.hidden = YES;
        //收藏
        }else if (selectIndex == 1){
            weakself.dongtaiView.hidden = YES;
            HeaderImageViewHeight = 276 + kStatusBarHeight + 60;
              weakself.headerView.zhinanBtn.hidden = weakself.headerView.shoucangdongtaiBtn.hidden = weakself.headerView.huatiBtn.hidden = NO;
        }

    };
    _headerView.liaoTianblock = ^{
        [weakself liaotianAction:nil];
    };
    _headerView.shoucangSegmentblock = ^(NSInteger selectIndex) {
        UIColor * back1Color = kRGBA(16, 35, 58, 1);
        UIColor * back2Color = kRGBA(245, 245, 245, 1);
        UIColor * textColor = kRGBA(153, 153, 153, 1);
        weakself.requestPage = 1;
        weakself.downSelectIndex = selectIndex;
        [weakself.dataArray removeAllObjects];
        [weakself requestMyCollectionListGet];
        //文章
        if (selectIndex == 2001) {
            [weakself.headerView.zhinanBtn setBackgroundColor:back1Color];
            [weakself.headerView.zhinanBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
            [weakself.headerView.shoucangdongtaiBtn setBackgroundColor:back2Color];
            [weakself.headerView.shoucangdongtaiBtn setTitleColor:textColor forState:UIControlStateNormal];
            [weakself.headerView.huatiBtn setBackgroundColor:back2Color];
            [weakself.headerView.huatiBtn setTitleColor:textColor forState:UIControlStateNormal];
        }else if(selectIndex == 2002){
            [weakself.headerView.shoucangdongtaiBtn setBackgroundColor:back1Color];
            [weakself.headerView.shoucangdongtaiBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
            [weakself.headerView.zhinanBtn setBackgroundColor:back2Color];
            [weakself.headerView.zhinanBtn setTitleColor:textColor forState:UIControlStateNormal];
            [weakself.headerView.huatiBtn setBackgroundColor:back2Color];
            [weakself.headerView.huatiBtn setTitleColor:textColor forState:UIControlStateNormal];
        }else if(selectIndex == 2003){
            [weakself.headerView.huatiBtn setBackgroundColor:back1Color];
            [weakself.headerView.huatiBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
            [weakself.headerView.shoucangdongtaiBtn setBackgroundColor:back2Color];
            [weakself.headerView.shoucangdongtaiBtn setTitleColor:textColor forState:UIControlStateNormal];
            [weakself.headerView.zhinanBtn setBackgroundColor:back2Color];
            [weakself.headerView.zhinanBtn setTitleColor:textColor forState:UIControlStateNormal];
        }
    };
}

#pragma mark - UITableViewDelegate
-(UIView *)headerView{
    if (!_headerView) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXMineHeaderView" owner:self options:nil];
        _headerView = [nib objectAtIndex:0];
        _headerView.mineImageView.layer.masksToBounds = YES;
        _headerView.mineImageView.layer.cornerRadius = _headerView.mineImageView.frame.size.width / 2.0;
        _headerView.zhinanBtn.hidden = _headerView.shoucangdongtaiBtn.hidden = _headerView.huatiBtn.hidden = YES;
        _headerView.dongtaiAndShouCangSegmentToBottomHeight.constant = _headerView.shoucangSegmentViewHeight.constant = 0;
        UIColor * back1Color = kRGBA(16, 35, 58, 1);
                 UIColor * back2Color = kRGBA(245, 245, 245, 1);
                 UIColor * textColor = kRGBA(153, 153, 153, 1);
          
          [_headerView.zhinanBtn setBackgroundColor:back1Color];
               [_headerView.zhinanBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
               [_headerView.shoucangdongtaiBtn setBackgroundColor:back2Color];
               [_headerView.shoucangdongtaiBtn setTitleColor:textColor forState:UIControlStateNormal];
               [_headerView.huatiBtn setBackgroundColor:back2Color];
               [_headerView.huatiBtn setTitleColor:textColor forState:UIControlStateNormal];
         [self setViewData];
    }
    _headerView.frame = CGRectMake(0, 0, KScreenWidth, HeaderImageViewHeight);
    _headerView.backgroundColor = kRGBA(16, 35, 58, 1);
    if (self.whereCome) {
        _headerView.guanzhuBtn.hidden = _headerView.fasixinBtn.hidden = _headerView.fasixinView.hidden = _headerView.backBtn.hidden = _headerView.liaoTianBtn.hidden =  NO;
        _headerView.editPersonBtn.hidden = _headerView.shezhiBtn.hidden  = YES;
    }else{
        _headerView.guanzhuBtn.hidden = _headerView.fasixinBtn.hidden =  _headerView.fasixinView.hidden =  _headerView.backBtn.hidden=   _headerView.liaoTianBtn.hidden = YES;
        _headerView.editPersonBtn.hidden = _headerView.shezhiBtn.hidden  = NO;
    }

    [self headerViewBlockAction];

    return _headerView;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return HeaderImageViewHeight;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectIndexBool) {
        if (_downSelectIndex == 2001 || _downSelectIndex == 2003) {
            return 120;
        }else{
            NSDictionary * dic = self.dataArray[indexPath.row];
            return [YXFirstFindImageTableViewCell cellDefaultHeight:dic];
        }
    }else{
        return [HGPersonalCenterTableViewCell cellDefaultHeight:self.dataArray[indexPath.row]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selectIndexBool) {
        NSDictionary * dic = self.dataArray[indexPath.row];
        //动态的cell
        if (self.downSelectIndex == 2001) {
            HGPersonal1TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HGPersonal1TableViewCell" forIndexPath:indexPath];
            cell.contentTopHeight.constant = 12;
            [cell setCellData:dic type:self.downSelectIndex];
            return  cell;
        }else if (self.downSelectIndex == 2003) {
            HGPersonal1TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HGPersonal1TableViewCell" forIndexPath:indexPath];
            cell.contentTopHeight.constant = 32;
            [cell setCellData:dic type:self.downSelectIndex];
            return  cell;
        }else{
            return [self customImageData:dic indexPath:indexPath];
        }
    }else{
        
         HGPersonalCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HGPersonalCenterTableViewCell" forIndexPath:indexPath];
          cell.tag = indexPath.row;
          cell.dataDic = self.dataArray[indexPath.row];
          [cell setCellData:self.dataArray[indexPath.row]];
          kWeakSelf(self);
          //点击tag
             cell.clickTagblock = ^(NSString * string) {
                 kWeakSelf(self);
                 _tagSelectBool = YES;
                 if ([string contains:@"#"]) {string = [string split:@"#"][1];}
                 [YX_MANAGER requestSearchFind_all:@{@"key":string,@"key_unicode":[string utf8ToUnicode],@"page":@"1",@"type":@"3"} success:^(id object) {
                     if ([object count] > 0) {
                         YXFindSearchTagDetailViewController * VC = [[YXFindSearchTagDetailViewController alloc] init];
                         VC.type = @"3";
                         VC.key = object[0][@"tag"];
                         VC.startDic = [NSDictionary dictionaryWithDictionary:object[0]];
                         VC.startArray = [NSArray arrayWithArray:object];

                         [weakself.navigationController pushViewController:VC animated:YES];
                     }else{
                         [QMUITips showInfo:@"无此标签的信息"];
                     }
                     _tagSelectBool = NO;
                 }];
             };
             //点击点赞和评论
             cell.clickDetailblock = ^(NSInteger tag, NSInteger tag1) {
                 NSIndexPath * indexPathSelect = [NSIndexPath indexPathForRow:tag1  inSection:0];
                 HGPersonalCenterTableViewCell * cell = [weakself.yxTableView cellForRowAtIndexPath:indexPathSelect];
                 if (tag == 1) {//评论
                     _selectRow = -1;
                     [weakself tableView:weakself.yxTableView didSelectRowAtIndexPath:indexPathSelect];
                 }else if(tag == 2){//点赞
                     _selectRow = tag1;
                     [weakself requestDianZan_Image_Action:indexPathSelect];
                 }else{//分享
                     _selectRow = -1;
                     NSDictionary * userInfo = userManager.loadUserAllInfo;
                     BOOL isOwn = [cell.dataDic[@"user_id"] integerValue] == [kGetString(userInfo[@"id"]) integerValue];
                     weakself.shareDic = [NSDictionary dictionaryWithDictionary:cell.dataDic];
                     [weakself addGuanjiaShareViewIsOwn:isOwn isWho:kGetString(cell.dataDic[@"obj"]) tag:[cell.dataDic[@"id"] integerValue] startDic:cell.dataDic];
                 }
             };
          //播放视频按钮
            cell.playBlock = ^(UITapGestureRecognizer * tap) {
                [weakself showVideoPlayer:tap];
            };
            return cell;
    }
    
  
}
#pragma mark ========== 图片 ==========
-(YXFirstFindImageTableViewCell *)customImageData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFirstFindImageTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFirstFindImageTableViewCell" forIndexPath:indexPath];
    cell.tagId = [dic[@"id"] integerValue];
    cell.tag = indexPath.row;
    cell.titleImageView.tag = indexPath.row;
    cell.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [cell setCellValue:dic];
    cell.topTopHeight.constant = 0;
    cell.bottomBottomHeight.constant = 0;
    cell.bottomPingLunLbl.hidden = YES;
    cell.wenzhangDetailHeight.constant = 0;//文章详情里面用的，外边设置为0
    cell.wenzhangDetailLbl.hidden = YES;//文章详情里面用的，外边设置为隐藏
    cell.toptop1Height.constant = 0;

    //以下为所有block方法
    kWeakSelf(self);
    //右上角分享
    cell.shareblock = ^(NSInteger tag) {
        NSIndexPath * indexPathSelect = [NSIndexPath indexPathForRow:tag  inSection:0];
        YXFirstFindImageTableViewCell * cell = [weakself.yxTableView cellForRowAtIndexPath:indexPathSelect];
        NSDictionary * userInfo = userManager.loadUserAllInfo;
        BOOL isOwn = [cell.dataDic[@"user_id"] integerValue] == [kGetString(userInfo[@"id"]) integerValue];
        weakself.shareDic = [NSDictionary dictionaryWithDictionary:cell.dataDic];
        
        NSArray * urlList = dic[@"url_list"];
        NSString * iswho = kGetString(cell.dataDic[@"obj"]);
        if ([kGetString(urlList[0]) containsString:@"mp4"]) {
            iswho = @"3";
        }

        [weakself addGuanjiaShareViewIsOwn:isOwn isWho:iswho tag:cell.tagId startDic:cell.dataDic];
    };
    //点击用户头像
    cell.clickImageBlock = ^(NSInteger tag) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    //点击tag
    cell.clickTagblock = ^(NSString * string) {
        kWeakSelf(self);
        _tagSelectBool = YES;
        if ([string contains:@"#"]) {string = [string split:@"#"][1];}
        [YX_MANAGER requestSearchFind_all:@{@"key":string,@"key_unicode":[string utf8ToUnicode],@"page":@"1",@"type":@"3"} success:^(id object) {
            if ([object count] > 0) {
                YXFindSearchTagDetailViewController * VC = [[YXFindSearchTagDetailViewController alloc] init];
                VC.type = @"3";
                VC.key = object[0][@"tag"];
                VC.startDic = [NSDictionary dictionaryWithDictionary:object[0]];
                VC.startArray = [NSArray arrayWithArray:object];

                [weakself.navigationController pushViewController:VC animated:YES];
            }else{
                [QMUITips showInfo:@"无此标签的信息"];
            }
            _tagSelectBool = NO;
        }];
    };
    //点击点赞和评论
    cell.clickDetailblock = ^(NSInteger tag, NSInteger tag1) {
        if (![userManager loadUserInfo]) {
                  KPostNotification(KNotificationLoginStateChange, @NO);
                  return;
              }
        NSIndexPath * indexPathSelect = [NSIndexPath indexPathForRow:tag1  inSection:0];
        YXFirstFindImageTableViewCell * cell = [weakself.yxTableView cellForRowAtIndexPath:indexPathSelect];
        if (tag == 1) {//评论
            [weakself tableView:weakself.yxTableView didSelectRowAtIndexPath:indexPathSelect];
        }else if(tag == 2){//点赞
            [weakself requestDianZan_Image_Action:indexPathSelect];
        }else{//分享
            NSDictionary * userInfo = userManager.loadUserAllInfo;
            BOOL isOwn = [cell.dataDic[@"user_id"] integerValue] == [kGetString(userInfo[@"id"]) integerValue];
            weakself.shareDic = [NSDictionary dictionaryWithDictionary:cell.dataDic];
            
            [weakself addGuanjiaShareViewIsOwn:isOwn isWho:kGetString(cell.dataDic[@"obj"]) tag:cell.tagId startDic:cell.dataDic];
        }
    };
    //播放视频按钮
    cell.playBlock = ^(UITapGestureRecognizer * tap) {
        [weakself showVideoPlayer:tap];
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
#pragma -----点击工具指南-----
-(void)didselect2001ShouCang:(NSDictionary *)dic{
    YXZhiNanDetailViewController * vc = [[YXZhiNanDetailViewController alloc]init];
    vc.smallIndex = 0;
    vc.bigIndex = 0;
    vc.whereCome = YES;
    vc.startArray = [[NSMutableArray alloc] init];
    [vc.startArray addObject:dic[@"title"]];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma -----点击动态-----
-(void)didselect2002ShouCang:(NSDictionary *)dic{
    YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
    CGFloat h = [YXFirstFindImageTableViewCell cellDefaultHeight:dic];
    VC.headerViewHeight = h;
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma -----点击话题-----
-(void)didselect2003ShouCang:(NSDictionary *)dic{
    kWeakSelf(self);
    NSString * string = dic[@"tag"];
    if ([string contains:@"#"]) {string = [string split:@"#"][1];}
    [YX_MANAGER requestSearchFind_all:@{@"key":string,@"key_unicode":string,@"page":@"1",@"type":@"3"} success:^(id object) {
          if ([object count] > 0) {
              YXFindSearchTagDetailViewController * VC = [[YXFindSearchTagDetailViewController alloc] init];
              VC.type = @"3";
              VC.key = string;
              VC.startDic = [NSDictionary dictionaryWithDictionary:object[0]];
              VC.startArray = [NSArray arrayWithArray:object];
              [weakself.navigationController pushViewController:VC animated:YES];
          }else{
              [QMUITips showInfo:@"无此标签的信息"];
          }
      }];
}
#pragma mark ========== tableViewcell点击 ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //收藏里面的点击
    if (_selectIndexBool) {
        NSDictionary * dic = self.dataArray[indexPath.row];
        //这个方法太长为了清晰
        if (_downSelectIndex == 2001) {
            [self didselect2001ShouCang:dic];
        }else if (_downSelectIndex == 2002){
            [self didselect2002ShouCang:dic];
        }else if (_downSelectIndex == 2003){
            [self didselect2003ShouCang:dic];
        }
    }else{
          NSDictionary * dic = self.dataArray[indexPath.row];
          YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
          CGFloat h = [YXFirstFindImageTableViewCell cellDefaultHeight:dic];
          VC.headerViewHeight = h;
          VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
          [self.navigationController pushViewController:VC animated:YES];
    }
  
}
#pragma mark - Lazy
- (void)createTableView {
    _selectRow = -1;
    _yxTableView.delegate = self;
    _yxTableView.dataSource = self;
    _yxTableView.tag = 99999;
    _yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_yxTableView registerNib:[UINib nibWithNibName:@"HGPersonalCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"HGPersonalCenterTableViewCell"];
    [_yxTableView registerNib:[UINib nibWithNibName:@"YXFirstFindImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFirstFindImageTableViewCell"];
      [_yxTableView registerNib:[UINib nibWithNibName:@"HGPersonal1TableViewCell" bundle:nil] forCellReuseIdentifier:@"HGPersonal1TableViewCell"];
    self.dataArray = [[NSMutableArray alloc]init];
    [self addRefreshView:self.yxTableView];
    
    if (self.whereCome) {
         self.nodataImg = [[UILabel alloc]init];
         self.nodataImg.frame = CGRectMake((KScreenWidth-200)/2,HeaderImageViewHeight-100+(KScreenHeight - HeaderImageViewHeight)/2, 200, 100);
         self.nodataImg.text = @"暂时还没有晒图和文章";
         self.nodataImg.font = [UIFont systemFontOfSize:14];
         self.nodataImg.textColor = [UIColor lightGrayColor];
         self.nodataImg.textAlignment = NSTextAlignmentCenter;
         [self.yxTableView addSubview:self.nodataImg];
         self.nodataImg.hidden = YES;
    }
    
    [self.yxTableView setTableHeaderView:self.headerView];
    
}
-(void)endRefresh{
    [self.yxTableView.mj_header endRefreshing];
    [self.yxTableView.mj_footer endRefreshing];
}
#pragma mark ========== 数据 ==========
-(void)setViewData{
    kWeakSelf(self);
    //  YES为其他人 NO为自己
    if (self.whereCome) {
        self.headerView.backBtn.hidden = self.headerView.guanzhuBtn.hidden = self.headerView.otherStackView.hidden = NO;
        self.headerView.myStackView.hidden = self.headerView.qiandaoBtn.hidden = self.headerView.shangchengBtn.hidden = YES;
        self.headerView.tieshubtn.userInteractionEnabled = NO;
        self.picPathStringsArray = [[NSMutableArray alloc]init];
        [YX_MANAGER requestGetUserothers:self.userId success:^(id object) {
            [weakself setControllerHeaderviewData:object];
            [weakself personValue:object];
            weakself.userInfoDic = [NSDictionary dictionaryWithDictionary:object];
            [weakself endRefresh];
        }];
    }else{
        self.headerView.backBtn.hidden = self.headerView.guanzhuBtn.hidden = self.headerView.otherStackView.hidden = self.headerView.shangchengBtn.hidden = YES;
        self.headerView.myStackView.hidden = self.headerView.qiandaoBtn.hidden =  NO;
        self.headerView.tieshubtn.userInteractionEnabled = YES;
        //积分
             [YX_MANAGER requestGetFind_My_user_Info:@"" success:^(id object) {
                 weakself.headerView.tieshuCountLbl.text= kGetNSInteger([object[@"wallet"][@"integral"] integerValue]);
                 
             }];
            [QMUITips hideAllTips];
//            [QMUITips showLoadingInView:self.view];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 NSDictionary * userInfo = userManager.loadUserAllInfo;
                       [YX_MANAGER requestGetFind_user_id:user_id_BOOL ? weakself.userId : kGetString(userInfo[@"id"]) success:^(id object) {
                           weakself.userInfoDic = [NSDictionary dictionaryWithDictionary:object];
                           [weakself setControllerHeaderviewData:object];
                           [QMUITips hideAllTips];
                           [weakself personValue:object];
                           [weakself endRefresh];
                       }];
             });
        [YX_MANAGER requestLikesGET:@"4/0/1/" success:^(id object) {
            weakself.headerView.guanzhuCountLbl.text = kGetString(object[@"like_number"]);
            weakself.headerView.fensiCountLbl.text = kGetString(object[@"fans_number"]);
        }];
    }
}
-(void)personValue:(id)object{
    NSString * str = [(NSMutableString *)object[@"photo"] replaceAll:@" " target:@"%20"];
    NSMutableDictionary * mDic = [NSMutableDictionary dictionaryWithDictionary:object];
    BOOL ishaveQianming = [object[@"character"] isEqualToString:@"请填写签名"] || [object[@"character"] length] == 0 || [object[@"character"] isEqualToString:@" "];
    self.navigationItem.title = kGetString(object[@"username"]);
    self.headerView.mineTitle.text =kGetString(object[@"username"]);
    NSString * sex = [object[@"gender"] integerValue] == 0 ? @"女" : @"男";
    self.headerView.mineAdress.text =  [NSString stringWithFormat:@"%@ | %@",sex,object[@"site"]];
    if (self.whereCome) {
        self.headerView.otherguanzhucountlbl.text = kGetString(object[@"likes_number"]);
        self.headerView.otherfensicountlbl.text = kGetString(object[@"fans_number"]);
        [self.picPathStringsArray removeAllObjects];
        [self.picPathStringsArray addObject:str];
        self.headerView.qianmingLbl.text = ishaveQianming ? @"" : object[@"character"];
        

    }else{
        NSDictionary * userInfoDic = UserDefaultsGET(KUserInfo);
        [mDic setValue:userInfoDic[@"token"] forKey:@"token"];
        UserDefaultsSET(mDic, KUserInfo);
        
        self.headerView.qianmingLbl.text = ishaveQianming ? @"简单介绍一下自己" : object[@"character"];
        
        if ([self.headerView.qianmingLbl.text isEqualToString:@"简单介绍一下自己"]) {
           NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self.headerView.qianmingLbl.text];
           NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
           attchImage.image = [UIImage imageNamed:@"minebianji"];
           attchImage.bounds = CGRectMake(0,-7, 22, 22);
           NSMutableAttributedString * attriStr1 = [[NSMutableAttributedString alloc] initWithString:@" "];
           NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
           [attriStr insertAttributedString:stringImage atIndex:0];
           [attriStr insertAttributedString:attriStr1 atIndex:1];
           self.headerView.qianmingLbl.attributedText = attriStr;

        }
      
    }

    
    //关注按钮样式
    NSInteger tag = [object[@"is_like"] integerValue];
    [self setGuanzhuCommonBtn:tag btn:self.headerView.guanzhuBtn];

    //签到按钮样式
    [self.headerView.qiandaoBtn setTitle:@"签到" forState:UIControlStateNormal];
    [self.headerView.mineImageView sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:str]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];

}
//关注按钮的初始化方法
-(void)setGuanzhuCommonBtn:(NSInteger)tag btn:(UIButton*)btn{
    self.guanzhuWidth.constant = 66;
    if(tag == 2){
        [WP_TOOL_ShareManager inYiGuanZhuStatusBtn:self.headerView.guanzhuBtn];
        [WP_TOOL_ShareManager inYiGuanZhuStatusBtn:self.controllerHeaderViewGauzhu];
    }else if(tag == 1){
        [WP_TOOL_ShareManager inHuXiangGuanZhuStatusBtn:self.headerView.guanzhuBtn];
        [WP_TOOL_ShareManager inHuXiangGuanZhuStatusBtn:self.controllerHeaderViewGauzhu];
    }else{
        [WP_TOOL_ShareManager inGuanZhuMineStatusBtn:self.headerView.guanzhuBtn];
        [WP_TOOL_ShareManager inGuanZhuStatusBtn:self.controllerHeaderViewGauzhu];
    }
}
//所有按钮的关注方法
-(void)setGuanzhuCommonAction{
    kWeakSelf(self);
    [YX_MANAGER requestLikesActionGET:weakself.userId success:^(id object) {
        [weakself setViewData];
    }];
}
-(void)setControllerHeaderviewData:(NSDictionary *)object{
       //控制器上的view  YES为其他人 NO为自己
        NSInteger tag = [object[@"is_like"] integerValue];
        [self setGuanzhuCommonBtn:tag btn:self.controllerHeaderViewGauzhu];
    
        NSString * str = [(NSMutableString *)object[@"photo"] replaceAll:@" " target:@"%20"];
        [self.controllerHeaderViewTitleImv sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:str]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
        self.controllerHeaderViewTitleLbl.text = kGetString(object[@"username"]);
    
    if (self.whereCome) {
     self.controllerHeaderViewOtherView.hidden = NO;
     self.controllerHeaderViewBackBtnWidth.constant = 20;
    }else{
     self.controllerHeaderViewOtherView.hidden = YES;
        self.controllerHeaderViewBackBtnWidth.constant = 0;
    }
}


#pragma mark ========== 分享 ==========
- (void)addGuanjiaShareView{
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    kWeakSelf(self);
    moreOperationController.items = @[
                                      // 第一行
                                      @[
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"分享给微信好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [weakself saveImage:UMSocialPlatformType_WechatSession];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [weakself saveImage:UMSocialPlatformType_WechatTimeLine];

                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_QQ") title:@"分享给QQ好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [weakself saveImage:UMSocialPlatformType_QQ];

                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareQzone") title:@"分享到QQ空间" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [weakself saveImage:UMSocialPlatformType_Qzone];

                                          }],
                                          ],
                                      ];
    [moreOperationController showFromBottom];

}
/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image);
}
- (void)saveImage:(UMSocialPlatformType)umType{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    UIImage* viewImage = [UIImage imageWithData:imageData];
      [QMUITips showLoadingInView:self.view];
      [QiniuLoad uploadImageToQNFilePath:@[viewImage] success:^(NSString *reslut) {
        [QMUITips hideAllTips];
            NSDictionary * userInfo = userManager.loadUserAllInfo;
           NSString * title = [NSString stringWithFormat:@"%@的主页@蓝皮书app",userInfo[@"username"]];
           NSString * desc = [NSString stringWithFormat:@"%@的蓝皮书主页，快来关注吧！",userInfo[@"username"]];
          [[ShareManager sharedShareManager] shareAllToPlatformType:umType obj:@{@"img":reslut,@"desc":desc,@"title":title,@"type":@"3"}];
    } failure:^(NSString *error) { }];
}

- (IBAction)controllerHeaderViewGuanzhuAction:(id)sender {
    [self setGuanzhuCommonAction];
}

- (IBAction)liaotianAction:(id)sender {
   SimpleChatMainViewController * vc = [[SimpleChatMainViewController alloc]init];
   vc.userInfoDic = [NSDictionary dictionaryWithDictionary:self.userInfoDic];
   [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)moreAction:(id)sender {
    [self handleShowContentView];
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.picPathStringsArray[index];
      NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
      return url;
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.headerView.mineImageView.image;
}

#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZan_Image_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        [weakself requestTableData];
    }];
}
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    [_player destroyPlayer];
    _player = nil;
    
    UIView *view = tapGesture.view;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:view.tag inSection:0];
    HGPersonalCenterTableViewCell * cell = [self.yxTableView cellForRowAtIndexPath:indexPath];
    cell.playImv.hidden = YES;
    _player = [[XLVideoPlayer alloc] init];
    NSDictionary * dic = self.dataArray[indexPath.row];
    _player.videoUrl = dic[@"url_list"][0];
    [_player playerBindTableView:self.yxTableView currentIndexPath:indexPath];
    _player.frame = cell.cellMidView.bounds;
    
    [cell.cellMidView addSubview:_player];
    
    _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
        cell.playImv.hidden = NO;
        [player destroyPlayer];
        _player = nil;
    };
}
- (XLVideoPlayer *)player {
    if (!_player) {
        _player = [[XLVideoPlayer alloc] init];
        _player.frame = CGRectMake(0, 64, self.view.frame.size.width, 250);
    }
    return _player;
}



#pragma mark ========== 分享 ==========
- (void)addGuanjiaShareViewIsOwn:(BOOL)isOwn isWho:(NSString *)isWho tag:(NSInteger)tagId startDic:(NSDictionary *)startDic{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    kWeakSelf(self);
    NSMutableArray * itemsArray1 = [[NSMutableArray alloc]init];
    if (isOwn) {
        if ([isWho isEqualToString:@"1"] || [isWho isEqualToString:@"2"]) {
            [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_add") title:@"编辑" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                [moreOperationController hideToBottom];
                if ([isWho isEqualToString:@"1"]) {
                    YXPublishImageViewController * imageVC = [[YXPublishImageViewController alloc]init];
                    YXShaiTuModel * model = [[YXShaiTuModel alloc]init];
                    model.post_id = kGetString(startDic[@"id"]);
                    model.coustomId = @"";
                    model.detail = startDic[@"detail"];
                    model.publish_site = startDic[@"publish_site"];
                    model.title = startDic[@"title"];
                    model.tag = startDic[@"tag"];
                    model.publish_site = startDic[@"publish_site"];
                    model.photo_list = startDic[@"photo_list"];
                    model.cover = startDic[@"cover"];
                    model.obj = kGetString(startDic[@"obj"]);
                    imageVC.model = model;
                    imageVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakself presentViewController:imageVC animated:YES completion:nil];
                }else{
                    YXWenZhangEditorViewController * wenzhangVC = [[YXWenZhangEditorViewController alloc]init];
                    YXShaiTuModel * model = [[YXShaiTuModel alloc]init];
                    model.post_id = kGetString(startDic[@"id"]);
                    model.coustomId = @"";
                    model.detail = startDic[@"detail"];
                    model.publish_site = startDic[@"publish_site"];
                    model.title = startDic[@"title"];
                    model.tag = startDic[@"tag"];
                    model.publish_site = startDic[@"publish_site"];
                    model.photo_list = startDic[@"photo_list"];
                    model.cover = startDic[@"cover"];
                    model.obj = kGetString(startDic[@"obj"]);
                    wenzhangVC.model = model;
                    wenzhangVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakself presentViewController:wenzhangVC animated:YES completion:nil];
                }
                       
            }]];
        }
    
        [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_remove") title:@"删除" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
            [moreOperationController hideToBottom];
                [QMUITips showLoadingInView:weakself.view];
                [YX_MANAGER requestDel_ShaiTU:NSIntegerToNSString(tagId) success:^(id object) {
                    [QMUITips hideAllTips];
                    [QMUITips showSucceed:@"删除成功"];
                    [weakself requestTableData];
                }];
        
        }]];
    }
    
    moreOperationController.items = @[
                                      // 第一行
                                      @[
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"分享给微信好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [weakself saveImage:UMSocialPlatformType_WechatSession];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [weakself saveImage:UMSocialPlatformType_WechatTimeLine];

                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_QQ") title:@"分享给QQ好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [weakself saveImage:UMSocialPlatformType_QQ];

                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareQzone") title:@"分享到QQ空间" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [weakself saveImage:UMSocialPlatformType_Qzone];

                                          }],
                                          ],
                                      itemsArray1
                                      // 第二行
                         
                                      ];
    [moreOperationController showFromBottom];

}
-(UIView *)dongtaiView{
    if (!_dongtaiView) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXXinDongTaiView" owner:self options:nil];
        _dongtaiView = [nib objectAtIndex:0];
        _dongtaiView.frame = CGRectMake(16,HeaderImageViewHeight+16, 160, 160);
        [self.yxTableView addSubview:_dongtaiView];
        
        
        //添加点击手势
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
        //点击几次后触发事件响应，默认为：1
        click.numberOfTapsRequired = 1;
        [_dongtaiView addGestureRecognizer:click];
        _dongtaiView.userInteractionEnabled = YES;
    }
    return _dongtaiView;
}
-(void)clickAction:(id)click{
//    [self addButton];
    self.navigationController.tabBarController.selectedIndex = 1;
}
- (void)addButton{
    
    CGRect floatFrame = CGRectMake(KScreenWidth-70, KScreenHeight-kTabBarHeight-80, 48, 48);
    self.menuBtn = [[LZMenuButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"findjiahao"] andPressedImage:[UIImage imageNamed:@"fabunewclose"] withScrollview:nil effectImage:[UIImage imageNamed:@""] menuWidth:45];
    self.menuBtn.imageArray = @[@"fabunewshaitu",@"fabunewwenzhang"];
    self.menuBtn.labelArray = @[@"文章",@"晒图"];
    self.menuBtn.hideWhileScrolling = NO;
    self.menuBtn.delegate = self;
    [self.view addSubview:self.menuBtn];
    
}
- (void)didSelectMenuOptionAtIndex:(NSInteger)row{
    if (row==1) {
        YXPublishImageViewController * imageVC = [[YXPublishImageViewController alloc]init];
        imageVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imageVC animated:YES completion:nil];
    }else{
        YXWenZhangEditorViewController * pinpaiVC = [[YXWenZhangEditorViewController alloc]init];
        pinpaiVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:pinpaiVC animated:YES completion:nil];
    }

    
    
   
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.yxTableView.contentOffset.y > HeaderImageViewHeight-40) { self.controllerHeaderView.hidden = NO;
    }else{if (self.yxTableView.contentOffset.y <= 0) { self.controllerHeaderView.hidden = YES;}}}

@end

