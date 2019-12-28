//
//  YXPingLunHeader.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/28.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SeeCellAllPingLunBlock)(void);
@interface YXPingLunHeader : UIView
@property (weak, nonatomic) IBOutlet UIButton *seeAllBtn;
- (IBAction)sellAllAction:(id)sender;
@property(nonatomic,copy)SeeCellAllPingLunBlock block;
@end

NS_ASSUME_NONNULL_END
