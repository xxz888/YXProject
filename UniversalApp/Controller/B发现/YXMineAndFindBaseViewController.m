//
//  YXMineAndFindBaseViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineAndFindBaseViewController.h"
#import "XHWebImageAutoSize.h"
#import "HGPersonalCenterViewController.h"
#import "YXFindSearchTagDetailViewController.h"
#import "ZInputToolbar.h"
#import "UIView+LSExtension.h"
#import "YXPublishImageViewController.h"
#import "XLVideoPlayer.h"

@interface YXMineAndFindBaseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZInputToolbarDelegate,UIScrollViewDelegate>{
    CGFloat _autoPLHeight;
    BOOL _tagSelectBool;
    XLVideoPlayer *_player;

}
@property (nonatomic, strong) NSDictionary *shareDic;
@property (nonatomic, strong) ZInputToolbar *inputToolbar;

@end
@implementation YXMineAndFindBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _autoPLHeight = 0;
    [self tableviewCon];
    [self addRefreshView:self.yxTableView];
}

#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:self.yxTableView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    self.yxTableView.estimatedRowHeight = 0;
    self.yxTableView.estimatedSectionHeaderHeight = 0;
    self.yxTableView.estimatedSectionFooterHeight = 0;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFirstFindImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFirstFindImageTableViewCell"];
    
    
    
    self.nodataImg = [[UILabel alloc]init];
    self.nodataImg.frame = CGRectMake((KScreenWidth-200)/2,80 , 200, 100);
    self.nodataImg.text = @"暂时还没有晒图和文章";
    self.nodataImg.font = [UIFont systemFontOfSize:14];
    self.nodataImg.textColor = [UIColor lightGrayColor];
    self.nodataImg.textAlignment = NSTextAlignmentCenter;
    [self.yxTableView addSubview:self.nodataImg];
    self.nodataImg.hidden = YES;
    
}
#pragma mark ========== tableview代理方法 ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    return [YXFirstFindImageTableViewCell cellDefaultHeight:dic];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (XLVideoPlayer *)player {
    if (!_player) {
        _player = [[XLVideoPlayer alloc] init];
        _player.frame = CGRectMake(0, 64, self.view.frame.size.width, 250);
    }
    return _player;
}
#pragma mark 字典转化字符串
-(NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    [_player destroyPlayer];
    _player = nil;
    
    UIView *view = tapGesture.view;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:view.tag inSection:0];
    YXFirstFindImageTableViewCell * cell = [self.yxTableView cellForRowAtIndexPath:indexPath];
    cell.playImV.hidden = YES;
    _player = [[XLVideoPlayer alloc] init];
    NSDictionary * dic = self.dataArray[indexPath.row];
    _player.videoUrl = dic[@"url_list"][0];
    [_player playerBindTableView:self.yxTableView currentIndexPath:indexPath];
    _player.frame = cell.onlyOneImv.bounds;
    
    [cell.onlyOneImv addSubview:_player];
    
    _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
        cell.playImV.hidden = NO;
        [player destroyPlayer];
        _player = nil;
    };
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    return [self customImageData:dic indexPath:indexPath];
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
        YXFindImageTableViewCell * cell = [weakself.yxTableView cellForRowAtIndexPath:indexPathSelect];
        UserInfo * userInfo = curUser;
        BOOL isOwn = [cell.dataDic[@"user_id"] integerValue] == [userInfo.id integerValue];
        weakself.shareDic = [NSDictionary dictionaryWithDictionary:cell.dataDic];
        [weakself addGuanjiaShareViewIsOwn:isOwn isWho:@"1" tag:cell.tagId startDic:cell.dataDic];
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
        [YX_MANAGER requestSearchFind_all:@{@"key":string,@"key_unicode":[string utf8ToUnicode],@"page":@"1",@"type":@"2"} success:^(id object) {
            if ([object count] > 0) {
                YXFindSearchTagDetailViewController * VC = [[YXFindSearchTagDetailViewController alloc] init];
                VC.type = @"3";
                VC.key = object[0][@"tag"];
                VC.startDic = [NSDictionary dictionaryWithDictionary:object[0]];
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
        YXFindImageTableViewCell * cell = [weakself.yxTableView cellForRowAtIndexPath:indexPathSelect];
        if (tag == 1) {//评论
            [weakself tableView:weakself.yxTableView didSelectRowAtIndexPath:indexPathSelect];
        }else if(tag == 2){//点赞
            [weakself requestDianZan_Image_Action:indexPathSelect];
        }else{//分享
            UserInfo * userInfo = curUser;
            BOOL isOwn = [cell.dataDic[@"user_id"] integerValue] == [userInfo.id integerValue];
            weakself.shareDic = [NSDictionary dictionaryWithDictionary:cell.dataDic];
            
            [weakself addGuanjiaShareViewIsOwn:isOwn isWho:@"1" tag:cell.tagId startDic:cell.dataDic];
        }
    };
    //播放视频按钮
    cell.playBlock = ^(UITapGestureRecognizer * tap) {
        [weakself showVideoPlayer:tap];
    };
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.yxTableView]) {
        
        [_player playerScrollIsSupportSmallWindowPlay:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player destroyPlayer];
    _player = nil;

}
-(void)commonDidVC:(NSIndexPath *)indexPath{
  
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZan_Image_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        [weakself requestAction];
    }];
}
-(void)requestTableData{
    
}

#pragma mark ========== 头像点击 ==========
-(void)clickUserImageView:(NSString *)userId{
     UserInfo *userInfo = curUser;
    if ([userInfo.id isEqualToString:userId]) {
        self.navigationController.tabBarController.selectedIndex = 4;
        return;
    }
     HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
     mineVC.userId = userId;
     mineVC.whereCome = YES;    //  YES为其他人 NO为自己
     [self.navigationController pushViewController:mineVC animated:YES];
    
}
#pragma mark ========== tableViewcell点击 ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tagSelectBool) {
        return;
    }
    NSDictionary * dic = self.dataArray[indexPath.row];
    YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
    CGFloat h = [YXFirstFindImageTableViewCell cellDefaultHeight:dic];
    VC.headerViewHeight = h;
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:VC animated:YES];
}








#pragma mark ========== 分享 ==========
- (void)addGuanjiaShareViewIsOwn:(BOOL)isOwn isWho:(NSString *)isWho tag:(NSInteger)tagId startDic:(NSDictionary *)startDic{
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    kWeakSelf(self);
    // 如果你的 item 是确定的，则可以直接通过 items 属性来显示，如果 item 需要经过一些判断才能确定下来，请看第二个示例
    NSMutableArray * itemsArray1 = [[NSMutableArray alloc]init];
    [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_add") title:@"编辑" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
        [moreOperationController hideToBottom];
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
        [weakself presentViewController:imageVC animated:YES completion:nil];
    }]],
    [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_remove") title:@"删除" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
        [moreOperationController hideToBottom];
        if ([isWho isEqualToString:@"1"]) {
            [YX_MANAGER requestDel_ShaiTU:NSIntegerToNSString(tagId) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
                [weakself requestTableData];
            }];
        }else if ([isWho isEqualToString:@"2"]){
            [YX_MANAGER requestDel_WenDa:NSIntegerToNSString(tagId) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
                
                [weakself requestTableData];
            }];
        }else if ([isWho isEqualToString:@"3"]){
            [YX_MANAGER requestDel_ZuJi:NSIntegerToNSString(tagId) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
                
                [weakself requestTableData];
            }];
        }
    }]],
    [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_report") title:@"举报" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
        [moreOperationController hideToBottom];
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
    }]];
    
    if (isOwn) {
        [itemsArray1 removeObjectAtIndex:2];
        if (![isWho isEqualToString:@"1"]) {
            [itemsArray1 removeObjectAtIndex:0];
        }
    }else{
        [itemsArray1 removeObjectAtIndex:0];
        [itemsArray1 removeObjectAtIndex:0];
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
    [QiniuLoad uploadImageToQNFilePath:@[viewImage] success:^(NSString *reslut) {
        [[ShareManager sharedShareManager] shareWebPageZhiNanDetailToPlatformType:umType obj:@{@"img":reslut}];
    } failure:^(NSString *error) {
        NSLog(@"%@",error);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)shareAction{
    
}
@end
