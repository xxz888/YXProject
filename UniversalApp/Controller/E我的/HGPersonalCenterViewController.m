//
//  HGPersonalCenterViewController.m
//  HGPersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "HGPersonalCenterViewController.h"
#import "YXMineAllViewController.h"
#import "YXMineImageViewController.h"
#import "YXMineFootViewController.h"
#import "HGCenterBaseTableView.h"
#import "YXMineHeaderView.h"
#import "YXMineFenSiViewController.h"
#import "YXMineGuanZhuViewController.h"
#import "YXMineAllViewController.h"
//HGPersonalCenterExtend
#import "HGSegmentedPageViewController.h"
#import "HGPageViewController.h"
#import "YXHomeEditPersonTableViewController.h"
#import "YXMineMyCollectionViewController.h"
#import "YXMinePingLunViewController.h"
#import "YXMineSettingTableViewController.h"
#import "YXMineMyCaoGaoViewController.h"
#import "YXMineMyDianZanViewController.h"
#import "YXMineFindViewController.h"
#import "YXMineMyCollectionViewController.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

static CGFloat const HeaderImageViewHeight =320;

@interface HGPersonalCenterViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, HGSegmentedPageViewControllerDelegate, HGPageViewControllerDelegate,HGPageViewControllerDelegate1>{
    QMUIModalPresentationViewController * _modalViewController;
    NSArray * titleArray;

}
@property (nonatomic, strong) UITableView * menuTableView;

@property (nonatomic, strong) HGCenterBaseTableView *yxTableView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic) BOOL cannotScroll;
@property (nonatomic, strong) YXMineHeaderView * headerView;
@property(nonatomic, strong) UserInfo *userInfo;//用户信息
@property(nonatomic, strong) NSDictionary *userInfoDic;//用户信息
@property (nonatomic) BOOL isCanBack;

@end

@implementation HGPersonalCenterViewController


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //如果使用自定义的按钮去替换系统默认返回按钮，会出现滑动返回手势失效的情况
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self setupSubViews];
    self.isEnlarge = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self updateNavigationBarBackgroundColor];
    [self setViewData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
#pragma mark - Private Methods
- (void)setupSubViews {
    kWeakSelf(self);
    [self.view insertSubview:self.yxTableView belowSubview:self.navigationController.navigationBar];
    [self.yxTableView addSubview:self.headerView];
    [self.yxTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view);
    }];

}
#pragma mark ========== 点击菜单按钮的方法 ==========
- (void)handleShowContentView {
    
    
    kWeakSelf(self);
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"设置" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {

        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
        YXMineSettingTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineSettingTableViewController"];
        [weakself.navigationController pushViewController:VC animated:YES];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"分享" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {

    }];
    QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"草稿箱" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        YXMineMyCaoGaoViewController * VC = [[YXMineMyCaoGaoViewController alloc]init];
        [weakself.navigationController pushViewController:VC animated:YES];
    }];
 
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:action4];

    [alertController showWithAnimated:YES];
    
    
    
}
- (void)updateNavigationBarBackgroundColor {
    CGFloat alpha = 0;
    CGFloat currentOffsetY = self.yxTableView.contentOffset.y;
    if (-currentOffsetY <= NAVIGATION_BAR_HEIGHT) {
        alpha = 1;
    } else if ((-currentOffsetY > NAVIGATION_BAR_HEIGHT) && -currentOffsetY < HeaderImageViewHeight) {
        alpha = (HeaderImageViewHeight + currentOffsetY) / (HeaderImageViewHeight - NAVIGATION_BAR_HEIGHT);
    } else {
        alpha = 0;
    }
}

#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
//    [self.segmentedPageViewController.currentPageViewController makePageViewControllerScrollToTop];
    return YES;
}
-(YXMineHeaderView *)headerView{
    if (!_headerView) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXMineHeaderView" owner:self options:nil];
        _headerView = [nib objectAtIndex:0];
        
        
        if (self.whereCome) {
            _headerView.guanzhuBtn.hidden = NO;
            _headerView.editPersonBtn.hidden = YES;
        }else{
            _headerView.guanzhuBtn.hidden = YES;
            _headerView.editPersonBtn.hidden = NO;
        }
        
        _headerView.mineImageView.layer.masksToBounds = YES;
        _headerView.mineImageView.layer.cornerRadius = _headerView.mineImageView.frame.size.width / 2.0;
//        ViewBorderRadius(_headerView.guanzhuBtn, 5, 1,CFontColor1);
//        ViewBorderRadius(_headerView.editPersonBtn, 5, 1, CFontColor1);
        [self headerViewBlockAction];
        [self setViewData];
    }
    _headerView.frame = CGRectMake(0, -HeaderImageViewHeight, KScreenWidth, HeaderImageViewHeight);
    return _headerView;
}
-(void)headerViewBlockAction{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
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
        [YX_MANAGER requestLikesActionGET:weakself.userId success:^(id object) {
            BOOL is_like = [weakself.headerView.guanzhuBtn.titleLabel.text isEqualToString:@"关注"] == 1;
            if (!is_like) {
                [weakself.headerView.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
                 [QMUITips showSucceed:@"操作成功"] ;
            }else{
                [weakself.headerView.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [QMUITips showSucceed:@"操作成功"] ;
            }

            
            [weakself.headerView.guanzhuBtn setTitleColor:A_COlOR forState:0];
            [weakself.headerView.guanzhuBtn setBackgroundColor:KClearColor];
            ViewBorderRadius(weakself.headerView.guanzhuBtn, 5, 1,A_COlOR);

        }];
    };
    
    _headerView.editPersionblock = ^{
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
        YXHomeEditPersonTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXHomeEditPersonTableViewController"];
        VC.userInfoDic = [NSDictionary dictionaryWithDictionary:weakself.userInfoDic];
        [weakself.navigationController pushViewController:VC animated:YES];
    };
    
    _headerView.setblock = ^{
        [weakself handleShowContentView];
    };
    
    _headerView.mineBackVCBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
}
/**
 * 处理联动
 * 因为要实现下拉头部放大的问题，tableView设置了contentInset，所以试图刚加载的时候会调用一遍这个方法，所以要做一些特殊处理，
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //第一部分：处理导航栏
    [self updateNavigationBarBackgroundColor];
    
    //第二部分：处理手势冲突
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //吸顶临界点(此时的临界点不是视觉感官上导航栏的底部，而是当前屏幕的顶部相对scrollViewContentView的位置)
    CGFloat criticalPointOffsetY = [self.yxTableView rectForSection:0].origin.y -  [UIApplication sharedApplication].statusBarFrame.size.height;
    criticalPointOffsetY = AxcAE_IsiPhoneX ? -30 : -65;
    //利用contentOffset处理内外层scrollView的滑动冲突问题
    if (contentOffsetY >= criticalPointOffsetY) {
        /*
         * 到达临界点：
         * 1.未吸顶状态 -> 吸顶状态
         * 2.维持吸顶状态(pageViewController.scrollView.contentOffsetY > 0)
         */
        //“进入吸顶状态”以及“维持吸顶状态”
        self.cannotScroll = YES;
        scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
//        [self.segmentedPageViewController.currentPageViewController makePageViewControllerScroll:YES];
    } else {
        /*
         * 未达到临界点：
         * 1.吸顶状态 -> 不吸顶状态
         * 2.维持吸顶状态(pageViewController.scrollView.contentOffsetY > 0)
         */

        
        if (self.cannotScroll) {
            //“维持吸顶状态”
//            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        } else {
            /* 吸顶状态 -> 不吸顶状态
             * pageViewController.scrollView.contentOffsetY <= 0时，会通过代理HGPageViewControllerDelegate来改变当前控制器self.cannotScroll的值；
             */
        }
    }
    
    //第三部分：
    /**
     * 处理头部自定义背景视图 (如: 下拉放大)
     * 图片会被拉伸多出状态栏的高度
     */
    
    
    if(contentOffsetY <= -HeaderImageViewHeight) {
    
        if (self.isEnlarge) {
            CGRect f = self.headerView.frame;
            //改变HeadImageView的frame
            //上下放大
            f.origin.y = contentOffsetY;
            f.size.height = -contentOffsetY;
            //左右放大
            f.origin.x = (contentOffsetY * SCREEN_WIDTH / HeaderImageViewHeight + SCREEN_WIDTH) / 2;
            f.size.width = -contentOffsetY * SCREEN_WIDTH / HeaderImageViewHeight;
            //改变头部视图的frame
            self.headerView.frame = f;
        }else{
            scrollView.bounces = NO;
        }
        
    }else {
        scrollView.bounces = YES;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 9000) {
        return titleArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 9000) {
        static NSString *Identifier = @"Identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        }
        if (indexPath.row == 1) {
            cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
        }else if (indexPath.row == 0){
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UIImage * icon =[UIImage imageNamed:titleArray[indexPath.row]];
        CGSize itemSize = CGSizeMake(20, 20);//固定图片大小为36*36
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);//*1
        CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();//*2
        UIGraphicsEndImageContext();//*3
        cell.textLabel.text =titleArray[indexPath.row];
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addChildViewController:self.segmentedPageViewController];
    [cell.contentView addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController didMoveToParentViewController:self];
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 9000) {
        return 50;
    }
    return SCREEN_HEIGHT;
}

//解决tableView在group类型下tableView头部和底部多余空白的问题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView.tag == 9000) {
        return KScreenHeight-titleArray.count * 50;
    }
    return CGFLOAT_MIN;
}

#pragma mark - HGSegmentedPageViewControllerDelegate
- (void)segmentedPageViewControllerWillBeginDragging {
    self.yxTableView.scrollEnabled = NO;
}

- (void)segmentedPageViewControllerDidEndDragging {

    self.yxTableView.scrollEnabled = YES;
}

#pragma mark - HGPageViewControllerDelegate
- (void)pageViewControllerLeaveTop {
    self.cannotScroll = NO;
}

#pragma mark - Lazy
- (UITableView *)yxTableView {
    if (!_yxTableView) {
        _yxTableView = [[HGCenterBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _yxTableView.delegate = self;
        _yxTableView.dataSource = self;
        _yxTableView.contentInset = UIEdgeInsetsMake(HeaderImageViewHeight, 0, 0, 0);
        _yxTableView.showsVerticalScrollIndicator = NO;
        _yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    _yxTableView.tag = 7788;
    return _yxTableView;
    
}

- (HGSegmentedPageViewController *)segmentedPageViewController {
    if (!_segmentedPageViewController) {
         NSArray *titles = @[@"动态",@"收藏"];
        if (self.userId) {
            titles = @[@"动态"];
        }
        NSMutableArray *controllers = [NSMutableArray array];
        for (int i = 0; i < titles.count; i++) {
            if (i == 0) {
                YXMineAllViewController * controller = [[YXMineAllViewController alloc] init];
                controller.userId = self.userId;
                [controllers addObject:controller];
            }else{
                [controllers addObject:[YXMineMyCollectionViewController new]];
            }
        }
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
        _segmentedPageViewController.categoryView.titleNomalFont = [UIFont systemFontOfSize:14];
        _segmentedPageViewController.categoryView.titleSelectedFont = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        _segmentedPageViewController.pageViewControllers = controllers.copy;
        _segmentedPageViewController.categoryView.titles = titles;
        _segmentedPageViewController.categoryView.originalIndex = self.selectedIndex;
        _segmentedPageViewController.delegate = self;
    }
    return _segmentedPageViewController;
}



#pragma mark ========== 数据 ==========
-(void)setViewData{
    kWeakSelf(self);
    //  YES为其他人 NO为自己
    if (self.whereCome) {
        self.headerView.backBtn.hidden = NO;
        [YX_MANAGER requestGetUserothers:self.userId success:^(id object) {
            [weakself personValue:object];
        }];
        
    }else{
        self.userInfo = curUser;
        

        
        [YX_MANAGER requestGetFind_user_id:user_id_BOOL ? self.userId : self.userInfo.id success:^(id object) {
            [weakself personValue:object];
        }];
        [YX_MANAGER requestLikesGET:@"4/0/1/" success:^(id object) {
            weakself.headerView.guanzhuCountLbl.text = kGetString(object[@"like_number"]);
            weakself.headerView.fensiCountLbl.text = kGetString(object[@"fans_number"]);
            weakself.headerView.tieshuCountLbl.text = kGetString(object[@"pubulish_number"]);
        }];
    }
}

-(void)personValue:(id)object{
    NSString * str = [(NSMutableString *)object[@"photo"] replaceAll:@" " target:@"%20"];
    if (self.userInfo) {
        YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
        NSDictionary *dic = [self.userInfo modelToJSONObject];
        [dic setValue:str forKey:@"photo"];
        [cache setObject:dic forKey:KUserModelCache];
    }
    
    
    [self.headerView.mineImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
    self.navigationItem.title = kGetString(object[@"username"]);
    self.headerView.mineTitle.text =kGetString(object[@"username"]);
    self.headerView.mineAdress.text = kGetString(object[@"site"]);
    if (self.whereCome) {
            self.headerView.guanzhuCountLbl.text = kGetString(object[@"likes_number"]);
            self.headerView.fensiCountLbl.text = kGetString(object[@"fans_number"]);
            self.headerView.tieshuCountLbl.text = kGetString(object[@"publish_number"]);
    }

    NSInteger tag = [object[@"is_like"] integerValue];
    
    if (tag == 0) {
        [self.headerView.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
    }else{
        [self.headerView.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
    [self.headerView.guanzhuBtn setTitleColor:A_COlOR forState:0];
    [self.headerView.guanzhuBtn setBackgroundColor:KClearColor];
    ViewBorderRadius(self.headerView.guanzhuBtn, 5, 1,A_COlOR);

    
    
    
    NSString * islike = tag == 1 ? @"互相关注" : tag == 2 ? @"已关注" : @"关注";
    [self.headerView.guanzhuBtn setTitle:islike forState:UIControlStateNormal];
    
    self.userInfoDic = [NSDictionary dictionaryWithDictionary:object];
}





@end

