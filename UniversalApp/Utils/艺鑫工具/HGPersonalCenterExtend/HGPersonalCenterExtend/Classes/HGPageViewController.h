//
//  HGPageViewController.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGCategoryView.h"

@protocol HGPageViewControllerDelegate1 <NSObject>
- (void)pageViewControllerLeaveTop;
@end

@interface HGPageViewController : UIViewController
@property (nonatomic, weak) id<HGPageViewControllerDelegate1> delegate;
@property (nonatomic) NSInteger pageIndex;

- (void)makePageViewControllerScroll:(BOOL)canScroll;
- (void)makePageViewControllerScrollToTop;
@end
