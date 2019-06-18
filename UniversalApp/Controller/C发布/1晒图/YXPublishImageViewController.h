//
//  YXPublishImageViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/5.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "YXFaBuBaseViewController.h"
#import "YXShaiTuModel.h"


@interface YXPublishImageViewController : YXFaBuBaseViewController
@property(nonatomic,strong)YXShaiTuModel * model;
@property(nonatomic,strong)NSMutableDictionary * startDic;

@end
