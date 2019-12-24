//
//  YXSecondViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "HGSegmentedPageViewController.h"
#import "LZMenuButton.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^returnSecondVCBlock)(void);
@interface YXSecondViewController : RootViewController
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic,strong)LZMenuButton *menuBtn;
@property (nonatomic) BOOL isMineVcCome;//如果从我的界面进来，就要弹出发布界面
@end

NS_ASSUME_NONNULL_END
