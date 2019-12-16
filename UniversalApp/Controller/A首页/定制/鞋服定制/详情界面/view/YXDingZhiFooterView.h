//
//  YXDingZhiFooterView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^AllBtnBlock)(void);
@interface YXDingZhiFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
- (IBAction)allBtnAction:(id)sender;
@property(nonatomic,copy)AllBtnBlock allBtnBlock;
@end

NS_ASSUME_NONNULL_END
