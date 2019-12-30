//
//  YXZhiNan2Cell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tapLinkString)(NSString *);

NS_ASSUME_NONNULL_BEGIN
@interface YXZhiNan2Cell : UITableViewCell
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIView * midContentView;
//180
-(void)setCellData:(NSDictionary *)dic linkData:(NSArray *)linkArray;
+(CGFloat)jisuanCellHeight:(NSDictionary *)dic;
@property (nonatomic,copy) tapLinkString linkBlock;
@property (nonatomic,strong)YYLabel * contentLbl;



@end

NS_ASSUME_NONNULL_END
