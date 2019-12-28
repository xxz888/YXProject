//
//  YXMineImageDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/23.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "YXBaseFaXianDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXMineImageDetailViewController : YXBaseFaXianDetailViewController
@property (nonatomic,assign) CGFloat headerViewHeight;
@property (strong, nonatomic)  UIWebView *webView;
@property (nonatomic, strong) UILabel * nodataImg;
@property (nonatomic, strong) NSDictionary * currentCellDic;

@end

NS_ASSUME_NONNULL_END
