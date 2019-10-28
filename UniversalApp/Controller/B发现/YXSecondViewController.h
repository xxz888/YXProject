//
//  YXSecondViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "HGSegmentedPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXSecondViewController : RootViewController
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;

@property (nonatomic, strong) UIButton * findjiahao;
@end

NS_ASSUME_NONNULL_END
