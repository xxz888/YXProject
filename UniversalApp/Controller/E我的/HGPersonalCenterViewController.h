//
//  HGPersonalCenterViewController.h
//  HGPersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBaseViewController.h"
@interface HGPersonalCenterViewController : RootViewController
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) BOOL isEnlarge;

@property (nonatomic,assign) BOOL whereCome;// NO为自己  YES为其他人
@property (nonatomic,copy) NSString * userId;
@end
