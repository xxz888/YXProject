//
//  YXMineImageTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "TableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXMineImageTableViewCell : TableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mineImageView;
@property (weak, nonatomic) IBOutlet UILabel *mineImageLbl;
@property (weak, nonatomic) IBOutlet UIButton *mineImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *mineTimeLbl;

@end

NS_ASSUME_NONNULL_END
