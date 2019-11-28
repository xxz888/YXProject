//
//  HGPersonal1TableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGPersonal1TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *yinyingView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImv;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *collectLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopHeight;
-(void)setCellData:(NSDictionary *)dic type:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
