//
//  YXHomeXueJiaQuestionDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/16.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXHomeXueJiaQuestionDetailViewController : RootViewController
@property (nonatomic) Moment *moment;
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic,strong)NSDictionary * startDic;
@property (weak, nonatomic) IBOutlet UIButton *clickPingLunBtn;
@property (nonatomic,assign) CGFloat height;
@end

NS_ASSUME_NONNULL_END
