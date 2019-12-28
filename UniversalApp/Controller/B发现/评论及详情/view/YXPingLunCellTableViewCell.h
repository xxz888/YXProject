//
//  YXPingLunCellTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/28.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXPingLunCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *plLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plHeight;
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic;
-(void)setCellData:(NSDictionary *)dic;
@property(nonatomic,assign)NSInteger  startId;
+(CGFloat)getPlDetailHeight:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
