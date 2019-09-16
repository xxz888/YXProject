//
//  YXMineShouHuoTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXMineShouHuoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *adressLbl;
@property (weak, nonatomic) IBOutlet UIButton *morenBtn;
- (IBAction)morenAction:(id)sender;
- (IBAction)editAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
