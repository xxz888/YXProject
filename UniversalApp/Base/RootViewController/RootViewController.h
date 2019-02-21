//
//  RootViewController.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import "UIViewController+AlertViewAndActionSheet.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>
#import "IQKeyboardManager.h"
#import "FCXRefreshFooterView.h"
#import "FCXRefreshHeaderView.h"
#import "UIScrollView+FCXRefresh.h"
#import "YXFindSearchHeadView.h"
typedef void (^ListenChangeIndexBlock)(NSInteger);

/**
 VC 基类
 */
@interface RootViewController : UIViewController

/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;

@property (nonatomic,copy) ListenChangeIndexBlock getIndex;
@property (nonatomic,strong) YXFindSearchHeadView * searchHeaderView;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) FCXRefreshHeaderView * refreshHeaderView;
@property (nonatomic, strong) FCXRefreshFooterView * refreshFooterView;
@property (nonatomic,assign) NSInteger requestPage;
-(NSMutableArray *)commonAction:(id)obj dataArray:(NSMutableArray *)dataArray;
-(NSMutableArray *)addCollectionViewRefreshView:(id)obj dataArray:(NSMutableArray *)dataArray;
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0);
/**
 *  显示没有数据页面
 */
-(void)showNoDataImage;

/**
 *  移除无数据页面
 */
-(void)removeNoDataImage;

/**
 *  加载视图
 */
- (void)showLoadingAnimation;

/**
 *  停止加载
 */
- (void)stopLoadingAnimation;

/**
 *  是否显示返回按钮,默认情况是YES
 */
@property (nonatomic, assign) BOOL isShowLiftBack;

/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHidenNaviBar;

/**
 导航栏添加文本按钮

 @param titles 文本数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

/**
 导航栏添加图标按钮

 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

/**
 *  默认返回按钮的点击事件，默认是返回，子类可重写
 */
- (void)backBtnClicked;

//取消网络请求
- (void)cancelRequest;
#pragma mark ==========  搜索相关 ==========
-(void)setNavSearchView;
@property (nonatomic,weak) ZXSegmentController* segmentController;
-(void)setSegmentControllersArray:(NSArray *)controllers title:(NSArray *)titlesArray defaultIndex:(NSInteger)index top:(CGFloat)top view:(UIView *)view;
- (void)closeKeyboard:(UITapGestureRecognizer *)recognizer;
-(void)fiveStarView:(CGFloat)score view:(UIView *)view;
- (void)addRefreshView:(UITableView *)yxTableView;
- (void)addCollectionViewRefreshView:(UICollectionView *)yxCollectionView;
-(void)headerRereshing;
-(void)footerRereshing;
-(NSMutableArray *)commonCollectionAction:(id)obj dataArray:(NSMutableArray *)dataArray;
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
- (void)cancleAction;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
@end
