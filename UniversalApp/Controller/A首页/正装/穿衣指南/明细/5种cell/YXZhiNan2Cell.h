//
//  YXZhiNan2Cell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXZhiNan2Cell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UILabel *contentLbl;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
    //180
    -(void)setCellData:(NSDictionary *)dic;
+(CGFloat)jisuanCellHeight:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
