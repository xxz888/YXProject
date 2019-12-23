//
//  RootTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/18.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

@interface RootTableViewController ()<UIGestureRecognizerDelegate>{
    UITableView * _yxTableView;
    CGPoint _center;

}
@property (nonatomic) BOOL isCanUseSideBack;

@end

@implementation RootTableViewController
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _StatusBarStyle;
}
//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle=StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =KWhiteColor;
    self.navigationController.navigationBar.translucent=NO;

    //是否显示返回按钮
    self.isShowLiftBack = YES;
    //默认导航栏样式：黑字
//    self.StatusBarStyle = 0;
//    [[UINavigationBar appearance] setTintColor:KBlackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.requestPage = 1;
    
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _center = self.view.center;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)backBtnClicked
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  是否显示返回按钮
 */
- (void) setIsShowLiftBack:(BOOL)isShowLiftBack
{
    _isShowLiftBack = isShowLiftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        [self addNavigationItemWithImageNames:@[@"A黑色返回"] isLeft:YES target:self action:@selector(backBtnClicked) tags:nil];
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    //调整按钮位置
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
//    spaceItem.width= -5;
    [items addObject:spaceItem];
    NSInteger i = 0;
    for (NSString * imageName in imageNames) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 4, 22, 22);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        if (isLeft) {
        }else{
            if (tags.count > 0 && [tags[0] integerValue] == 999) {
                [btn setImageEdgeInsets:UIEdgeInsetsMake(6.5, 30, 6.5, 4)];
                
            }else{
                [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
                
            }
            
        }
        
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:view];
        [items addObject:item];
        
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

- (void)addRefreshView:(UITableView *)yxTableView{
    _yxTableView = yxTableView;
    yxTableView.showsHorizontalScrollIndicator = YES;
    yxTableView.estimatedRowHeight = 0;
    yxTableView.estimatedSectionFooterHeight = 0;
    yxTableView.estimatedSectionHeaderHeight = 0;
    //头部刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    yxTableView.mj_header = header;
    
    //底部刷新
    yxTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}
-(void)headerRereshing{
    self.requestPage = 1;
    
}
-(void)footerRereshing{
    self.requestPage += 1;
    
}
-(NSMutableArray *)commonAction:(id)obj dataArray:(NSMutableArray *)dataArray{
    NSMutableArray * nnnArray = [NSMutableArray arrayWithArray:dataArray];
    if (self.requestPage == 1) {
        [nnnArray removeAllObjects];
        [nnnArray addObjectsFromArray:obj];
    }else{
        if ([obj count] == 0) {
            //            [QMUITips showInfo:REFRESH_NO_DATA inView:self.view hideAfterDelay:1];
            [_yxTableView.mj_footer endRefreshing];
        }
        nnnArray = [NSMutableArray arrayWithArray:[nnnArray arrayByAddingObjectsFromArray:obj]];
    }
    DO_IN_MAIN_QUEUE_AFTER(0.5f, ^{
        [_yxTableView.mj_header endRefreshing];
        [_yxTableView.mj_footer endRefreshing];
    });
    return nnnArray;
}
#pragma mark ————— 导航栏 添加文字按钮 —————
- (NSMutableArray<UIButton *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    //调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    
    NSMutableArray * buttonArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = SYSTEMFONT(16);
        [btn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        
        //设置偏移
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        [buttonArray addObject:btn];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
    return buttonArray;
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘高度 keyboardHeight
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    //当前屏幕高度，无论横屏竖屏
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    //主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //获取当前响应者
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    NSLog(@"firstResponder:%@",firstResponder);

  // Twitter 网络登录时上移问题
    Class clName = NSClassFromString(@"UIWebBrowserView");
    if ([firstResponder isKindOfClass:clName]) return;
    if (![firstResponder respondsToSelector:@selector(center)]) return;

    //当前响应者在其父视图的中点(x居中 y最下点)
    CGPoint firstCPoint = CGPointMake(firstResponder.center.x, CGRectGetMaxY(firstResponder.frame));
    //当前响应者在屏幕中的point
    CGPoint convertPoint = [keyWindow convertPoint:firstCPoint fromView:firstResponder.superview];
    //[firstResponder convertPoint:firstCPoint toView:keyWindow];
    //当前响应者的最大y值
    CGFloat firstRespHeight = convertPoint.y;
    
    //键盘最高点的y值
    CGFloat topHeighY = screenH - keyboardHeight;//顶部高度的Y值
    if (topHeighY < firstRespHeight) { //键盘挡住了当前响应的控件 需要上移
        CGFloat spaceHeight = firstRespHeight - topHeighY;
        self.tableView.center = CGPointMake(self.tableView.center.x, self.tableView.center.y - spaceHeight);
        
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
        
    }else{
        NSLog(@"键盘未挡住输入框");
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //结束编辑
    [self.view endEditing:YES];
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification *)notification{
    self.tableView.center = _center;
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(void)dealloc{
    [kNotificationCenter removeObserver:self];
}
@end
