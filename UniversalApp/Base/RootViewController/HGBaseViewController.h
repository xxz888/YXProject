//
//  HGBaseViewController.h
//  HGPersonalCenter
//
//  Created by Arch on 2017/6/19.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "HGCategoryView.h"

@protocol HGPageViewControllerDelegate <NSObject>
- (void)pageViewControllerLeaveTop;
@end

@interface HGBaseViewController : RootViewController
@property (nonatomic, strong, readonly) UIView *navigationBar;


- (void)scrollViewDidScroll:(UIScrollView *)scrollView;




@property (nonatomic, weak) id<HGPageViewControllerDelegate> delegate;
@property (nonatomic) NSInteger pageIndex;

- (void)makePageViewControllerScroll:(BOOL)canScroll;
- (void)makePageViewControllerScrollToTop;
@end
