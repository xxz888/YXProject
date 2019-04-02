//
//  YXHomeXueJiaWenHuaTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXHomeXueJiaWenHuaTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *wenhuaImageView;
@property (weak, nonatomic) IBOutlet UILabel *wenhuaLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *talkNumLbl;
- (IBAction)zanAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *zanNumLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
-(void)setCellData:(NSDictionary *)dic;
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic;


typedef void(^zanBlock)(YXHomeXueJiaWenHuaTableViewCell *);
@property (nonatomic,copy) zanBlock zanblock;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;

@end

NS_ASSUME_NONNULL_END
