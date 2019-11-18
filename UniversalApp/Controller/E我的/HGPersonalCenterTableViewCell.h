//
//  HGPersonalCenterTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/18.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGPersonalCenterTableViewCell : UITableViewCell
//高度不变的
@property (weak, nonatomic) IBOutlet UILabel *cellDayLbl;
@property (weak, nonatomic) IBOutlet UILabel *cellRiQiLbl;
- (IBAction)fenxiangAction:(id)sender;
- (IBAction)pinglunAction:(id)sender;
- (IBAction)dianzanAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cellDianzanLbl;
//高度变的
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellContentLblHeight;
@property (weak, nonatomic) IBOutlet UILabel *cellContentLbl;


@property (weak, nonatomic) IBOutlet UIView *cellMidView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellMidViewHeight;

@property (weak, nonatomic) IBOutlet UIView *cellTagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTagViewHeight;


@end

NS_ASSUME_NONNULL_END
