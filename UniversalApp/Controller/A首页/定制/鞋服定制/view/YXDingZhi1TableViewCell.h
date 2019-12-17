//
//  YXDingZhi1TableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXDingZhi1TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImv;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellAdress;
@property (weak, nonatomic) IBOutlet UILabel *cellFar;

@end

NS_ASSUME_NONNULL_END
