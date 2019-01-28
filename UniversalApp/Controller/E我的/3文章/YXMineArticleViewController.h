//
//  YXMineArticleViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface YXMineArticleViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (nonatomic,copy) NSString * userId;//我的界面 下边 如果是other，要传id请求，晒图和文章
@end
