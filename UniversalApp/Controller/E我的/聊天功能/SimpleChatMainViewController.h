//
//  SimpleChatMainViewController.h
//  SimpleChatPage
//
//  Created by 李海群 on 2018/6/15.
//  Copyright © 2018年 Gorilla. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^backVCClickIndexBlock)(NSInteger);

@interface SimpleChatMainViewController : UIViewController
@property(nonatomic, strong) NSDictionary *userInfoDic;//用户信息
@property(nonatomic, strong) NSDictionary * requestObject;//用户信息
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property(nonatomic, assign) NSInteger clickIndex;//用户信息
@property(nonatomic, copy) backVCClickIndexBlock backVCClickIndexblock;//用户信息


@end
