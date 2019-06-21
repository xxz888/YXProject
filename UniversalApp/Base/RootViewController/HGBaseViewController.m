//
//  HGBaseViewController.m
//  HGPersonalCenter
//
//  Created by Arch on 2017/6/19.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "HGBaseViewController.h"

@interface HGBaseViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) BOOL canScroll;
@end

@implementation HGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setBackgroundImage:[self drawPngImageWithAlpha:0] forBarMetrics:(UIBarMetricsDefault)];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.view addSubview:self.navigationBar];
//    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.mas_equalTo(NAVIGATION_BAR_HEIGHT);
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//        [self.navigationController setNavigationBarHidden:YES];
//    if (self.navigationController.viewControllers.count > 1) {
//        self.cancelButton.hidden = NO;
//    } else {
//        self.cancelButton.hidden = YES;
//    }
}

#pragma mark - Private Methods
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)drawPngImageWithAlpha:(CGFloat)alpha{
    UIColor *color = kRGBA(255, 126, 15, alpha);
    CGSize size = CGSizeMake(1, 1);
    UIGraphicsBeginImageContext(size);
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(content, color.CGColor);
    CGContextFillRect(content, CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Getters
- (UIView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc] init];
        _navigationBar.backgroundColor = KWhiteColor;
        [_navigationBar addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
    return _navigationBar;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancelButton.contentMode = UIViewContentModeScaleAspectFit;
        [_cancelButton setImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
        _cancelButton.adjustsImageWhenHighlighted = YES;
        [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelButton;
}
- (void)makePageViewControllerScroll:(BOOL)canScroll {
    self.canScroll = canScroll;
    self.scrollView.showsVerticalScrollIndicator = canScroll;
    if (!canScroll) {
        self.scrollView.contentOffset = CGPointZero;
    }
}

- (void)makePageViewControllerScrollToTop{
    [self.scrollView setContentOffset:CGPointZero];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        self.scrollView = scrollView;
        
        if (self.canScroll) {
            CGFloat offsetY = scrollView.contentOffset.y;
            if (offsetY <= 0) {
                [self makePageViewControllerScroll:NO];
                if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewControllerLeaveTop)]) {
                    [self.delegate pageViewControllerLeaveTop];
                }
            }
        } else {
            [self makePageViewControllerScroll:NO];
        }    
}
@end

