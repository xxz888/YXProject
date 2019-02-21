//
//  ViewController.h
//  LocationSend
//
//  Created by ShaoFeng on 16/9/6.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^locationStringBlock)(NSString *);
@interface YXGaoDeMapViewController : RootViewController
@property (nonatomic,copy) locationStringBlock block;

@end

