//
//  YXMineFindTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXMineFindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImv;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
- (IBAction)guanzhuAction:(id)sender;
- (IBAction)delAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
