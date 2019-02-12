//
//  YXFindSearchHeadView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXFindSearchHeadView : UIView
@property (weak, nonatomic) IBOutlet UITextField *findTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
- (IBAction)cancleAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
