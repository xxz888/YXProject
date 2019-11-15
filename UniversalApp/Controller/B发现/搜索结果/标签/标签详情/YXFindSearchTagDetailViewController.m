//
//  YXFindSearchTagDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/4/2.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchTagDetailViewController.h"
#import "YXMineImageDetailViewController.h"
#import "XHWebImageAutoSize.h"
#import "YXFindSearchTagHeaderView.h"
#import "YXHomeXueJiaQuestionDetailViewController.h"
#import "YXMineFootDetailViewController.h"
#import "YXFirstFindImageTableViewCell.h"
#import "QiniuLoad.h"
@interface YXFindSearchTagDetailViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>{
    NSInteger page ;
}
@property (strong,nonatomic)  UICollectionView * yxCollectionView;
//@property (nonatomic, strong) YXFindSearchTagHeaderView * headerView;

@end

@implementation YXFindSearchTagDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestAction];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 280;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXFindSearchTagHeaderView" owner:self options:nil];
        YXFindSearchTagHeaderView * headerView = [nib objectAtIndex:0];
        headerView.frame = CGRectMake(0, 0, KScreenWidth, 280);
    headerView.lbl1.text = kGetString(self.startDic[@"tag"]);
    headerView.lbl2.text = [kGetNSInteger([self.dataArray count]) append:@"篇帖子"];
    
    NSString * photo = @"";
    if ([self.startDic[@"url_list"] count] > 0) {
        photo = self.startDic[@"url_list"][0];
    }
    [headerView.titleImageView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    kWeakSelf(self);
    headerView.backvcblock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    headerView.fenxiangblock = ^{
        [weakself addGuanjiaShareView];
    };
    return headerView;

}
-(void)requestTableData{
     [self requestMine_AllList];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestTableData];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestTableData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 280;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
    scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
    scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
}
}
//-(void)viewDidLoad{
//    [super viewDidLoad];
//    self.view.backgroundColor = KWhiteColor;
//    self.dataArray = [[NSMutableArray alloc]init];
//    self.title = self.key;
//
//    [self requestAction];
//}
-(void)requestAction{
    kWeakSelf(self);
    [YX_MANAGER requestSearchFind_all:@{@"key":self.key,@"page":NSIntegerToNSString(self.requestPage),@"type":self.type,@"key_unicode":[self.key utf8ToUnicode]} success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxCollectionView reloadData];
        [weakself.yxTableView reloadData];
        [weakself.yxCollectionView.mj_header endRefreshing];
        [weakself.yxCollectionView.mj_footer endRefreshing];

    }];
}



#pragma mark ========== 我自己的所有 ==========
-(void)requestMine_AllList{
    [self.dataArray removeAllObjects];
          self.dataArray = [self commonAction:self.startArray dataArray:self.dataArray];
          [self.yxTableView reloadData];
          self.nodataImg.hidden = self.dataArray.count != 0;
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZan_Image_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        [weakself requestTableData];
    }];
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
    //先上传到七牛云图片  再提交服务器
      [QMUITips showLoadingInView:self.view];
    kWeakSelf(self)
    [QiniuLoad uploadImageToQNFilePath:@[viewImage] success:^(NSString *reslut) {
          [QMUITips hideAllTips];
        NSDictionary * userInfo = userManager.loadUserAllInfo;
        NSString * title = [NSString stringWithFormat:@"%@@蓝皮书app",userInfo[@"username"]];
           NSString * desc = [NSString stringWithFormat:@"分享了%@，快来关注吧！",weakself.startDic[@"tag"]];
          [[ShareManager sharedShareManager] shareAllToPlatformType:umType obj:@{@"img":reslut,@"desc":desc,@"title":title,@"type":@"3"}];
    } failure:^(NSString *error) {
        NSLog(@"%@",error);
    }];
}
@end
