//
//  YXZhiNan5Cell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/10.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXZhiNan5Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
//180
-(void)setCellData:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight5;
+(CGFloat)jisuanCellHeight5:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
