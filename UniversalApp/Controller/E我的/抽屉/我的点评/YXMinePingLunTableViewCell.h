//
//  YXMinePingLunTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXMinePingLunTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *cnLbl;
@property (weak, nonatomic) IBOutlet UILabel *skLbl;
@property (weak, nonatomic) IBOutlet UILabel *hwLbl;
@property (weak, nonatomic) IBOutlet UILabel *plLbl;
@property (weak, nonatomic) IBOutlet UIView *outsideView;

@end

NS_ASSUME_NONNULL_END
