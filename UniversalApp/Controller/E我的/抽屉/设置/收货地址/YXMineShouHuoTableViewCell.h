//
//  YXMineShouHuoTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^btnClick)(NSInteger);
typedef void(^morenbtnClick)(NSInteger);

@interface YXMineShouHuoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *adressLbl;
@property (weak, nonatomic) IBOutlet UIButton *morenBtn;
- (IBAction)morenAction:(id)sender;
- (IBAction)editAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic,copy) btnClick btnblock;
@property (nonatomic,copy) morenbtnClick morenbtnblock;
@property (nonatomic,strong) NSDictionary * dic;


@end

NS_ASSUME_NONNULL_END
