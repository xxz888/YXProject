//
//  YXMineCommon1TableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ClickBtnDelegate <NSObject>
-(void)clickBtnAction:(NSInteger)common_id tag:(NSInteger)tag;
@end
@interface YXMineCommon1TableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *common1ImageView;
@property (weak, nonatomic) IBOutlet UILabel *common1NameLbl;
@property (weak, nonatomic) IBOutlet UIButton *common1GuanzhuBtn;
- (IBAction)common1GuanZhuAction:(id)sender;
@property (nonatomic,weak) id<ClickBtnDelegate> delegate;
@property(nonatomic)NSInteger tag;
@end

NS_ASSUME_NONNULL_END
