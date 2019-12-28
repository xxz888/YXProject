//
//  YXPingLunTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/28.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SeeAllPingLunBlock)(NSInteger);
typedef void(^ZanBlock)(NSInteger);
typedef void(^PressLongChildCellBlock)(NSDictionary *);
typedef void(^DidCellCellPingLunBlock)(NSInteger);

@interface YXPingLunTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *plTitleImv;
@property (weak, nonatomic) IBOutlet UILabel *plUserName;
@property (weak, nonatomic) IBOutlet UILabel *plTime;
@property (weak, nonatomic) IBOutlet UIButton *plZan;
- (IBAction)plZanAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *plDetail;
@property (weak, nonatomic) IBOutlet UITableView *plTableView;
@property(nonatomic,copy)SeeAllPingLunBlock seeAllblock;

@property(nonatomic,copy)ZanBlock zanBlock;
@property(nonatomic,copy)PressLongChildCellBlock pressLongChildCellBlock;
@property(nonatomic,copy)DidCellCellPingLunBlock didCellCellPingLunBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plDetailHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plplViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plplViewToTopHeight;

+(CGFloat)cellDefaultHeight:(NSDictionary *)dic;
-(void)setCellData:(NSDictionary *)dic;

@property(nonatomic,assign)CGFloat cellTableViewHeight;
@end

NS_ASSUME_NONNULL_END
