//
//  YXFindSearchTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXFindSearchTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellLbl;
@property (weak, nonatomic) IBOutlet UILabel *cellAutherLbl;
@end

NS_ASSUME_NONNULL_END
