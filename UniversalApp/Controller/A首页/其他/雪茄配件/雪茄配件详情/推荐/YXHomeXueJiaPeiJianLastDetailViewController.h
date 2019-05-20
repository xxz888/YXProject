//
//  YXHomeXueJiaPeiJianLastDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeXueJiaPeiJianLastDetailViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *shangpinxinxiLbl;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong)NSDictionary * dic;
@end

NS_ASSUME_NONNULL_END
