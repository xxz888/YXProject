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
#import "YXFirstFindImageTableViewCell.h"
#import "QiniuLoad.h"
@interface YXFindSearchTagDetailViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>{
    NSInteger page ;
    ;
}
//@property (nonatomic, strong) YXFindSearchTagHeaderView * headerView;
@property (nonatomic) NSInteger is_collect;

@property (strong,nonatomic)  YXFindSearchTagHeaderView * headerView;
@property (nonatomic, strong) NSDictionary * headerViewStartDic;

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
    [self tableviewCon];
    [self requestAction];
}

#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    [super tableviewCon];
    [self.yxTableView setFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 280;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXFindSearchTagHeaderView" owner:self options:nil];
    _headerView = [nib objectAtIndex:0];
    _headerView.frame = CGRectMake(0, 0, KScreenWidth, 280);
    _headerView.lbl1.text = kGetString(self.headerViewStartDic[@"tag"]);
    _headerView.lbl2.text = [kGetNSInteger([self.headerViewStartDic[@"post_number"] integerValue]) append:@"篇帖子"];
    
    
     
        BOOL is_collect = [self.headerViewStartDic[@"is_collect"] integerValue] == 1;
        UIImage * likeImage = is_collect ? [UIImage imageNamed:@"收藏2"] : [UIImage imageNamed:@"收藏1"] ;
        _headerView.shoucangImage.image = likeImage;

        UIColor * backColor = is_collect ? SEGMENT_COLOR: KWhiteColor;
        [_headerView.choucangBtn setBackgroundColor:backColor];
        UIColor * textColor = is_collect ? KWhiteColor : KDarkGaryColor;
        _headerView.shoucangLabel.textColor = textColor;
        NSString * shoucangText = is_collect ? @"已收藏":@"收藏";
        _headerView.shoucangLabel.text = shoucangText;
        _headerView.shoucangWidth.constant = is_collect ? 72 : 65;
         
    
    
    
    NSString * photo = @"";
    if ([self.headerViewStartDic[@"photo"] length] > 0) {
        photo = self.headerViewStartDic[@"photo"];
    }else {
        if ([self.startDic[@"url_list"] count] > 0) { photo = self.startDic[@"url_list"][0];}
        if ([self.startDic[@"cover"] length] > 0)   { photo = self.startDic[@"cover"];}
    }
    
    [_headerView.titleImageView sd_setImageWithURL:[NSURL URLWithString:[WP_TOOL_ShareManager addImgURL:photo]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    kWeakSelf(self);
    _headerView.backvcblock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    _headerView.fenxiangblock = ^{
        [weakself addGuanjiaShareView];
    };
    _headerView.shoucangblock = ^(NSInteger tag) {
         NSString * photo = @"";
         if ([weakself.headerViewStartDic[@"photo"] length] > 0) {
             photo = weakself.headerViewStartDic[@"photo"];
         }else {
             if ([weakself.startDic[@"url_list"] count] > 0) { photo = weakself.startDic[@"url_list"][0];}
             if ([weakself.startDic[@"cover"] length] > 0)   { photo = weakself.startDic[@"cover"];}
         }
        
        
        NSString * tagRequest = [weakself.key concate:@"#"] ? [weakself.key split:@"#"][1] : weakself.key;
        [YXPLUS_MANAGER requestUserShouCangPOST:@{@"obj":@"3",@"target_id":@"",@"photo":photo,@"tag":tagRequest} success:^(id object) {
                    [weakself requestIsCollection];


            
            
//       NSString * tagRequest = [[weakself.key concate:@"#"] ? [weakself.key split:@"#"][1] : weakself.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//         [YXPLUS_MANAGER requestUserIsShouCangGet:tagRequest success:^(id object) {
//
//             BOOL is_collect = [weakself.headerViewStartDic[@"is_collect"] integerValue] == 1;
//             UIImage * likeImage = is_collect ? [UIImage imageNamed:@"收藏1"] : [UIImage imageNamed:@"收藏2"] ;
//             weakself.headerView.shoucangImage.image = likeImage;
//
//             UIColor * backColor = is_collect ? KWhiteColor  : SEGMENT_COLOR;
//             [weakself.headerView.choucangBtn setBackgroundColor:backColor];
//             UIColor * textColor = is_collect ? KDarkGaryColor : KWhiteColor;
//             weakself.headerView.shoucangLabel.textColor = textColor;
//             NSString * shoucangText = is_collect ? @"收藏":@"已收藏";
//             weakself.headerView.shoucangLabel.text = shoucangText;
//         }];
            
        }];
    };
    return _headerView;

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
-(void)requestAction{
    kWeakSelf(self);
    [YX_MANAGER requestSearchFind_all:@{@"key":self.key,@"page":NSIntegerToNSString(self.requestPage),@"type":self.type,@"key_unicode":[self.key utf8ToUnicode]} success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself requestIsCollection];



    }];
}
-(void)requestIsCollection{
    //请求是否收藏
    kWeakSelf(self);
    NSString * tagRequest = [[self.key concate:@"#"] ? [self.key split:@"#"][1] : self.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [YXPLUS_MANAGER requestUserIsShouCangGet:tagRequest success:^(id object) {
        weakself.headerViewStartDic = [NSDictionary dictionaryWithDictionary:object];
        [weakself.yxTableView reloadData];
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
//                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareQzone") title:@"分享到QQ空间" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
//                                              [moreOperationController hideToBottom];
//                                              [weakself saveImage:UMSocialPlatformType_Qzone];
//
//                                          }],
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
