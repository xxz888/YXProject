//
//  YXPublishArticleViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXPublishArticleViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIButton *closeView;
- (IBAction)coseViewAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleTf;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *paizhaoBtn;
- (IBAction)paizhaoAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
