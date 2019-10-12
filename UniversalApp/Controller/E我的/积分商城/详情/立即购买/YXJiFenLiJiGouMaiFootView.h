//
//  YXJiFenLiJiGouMaiFootView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/10.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^lijigoumaiBlock)(void);
@interface YXJiFenLiJiGouMaiFootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *jifen;
- (IBAction)querenzhifuAction:(id)sender;
@property (nonatomic,copy) lijigoumaiBlock  lijigoumaiblock;

@property (weak, nonatomic) IBOutlet UIButton *querenzhifu;

@end

NS_ASSUME_NONNULL_END
