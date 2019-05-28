//
//  YXZhiNanDetailHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BackVCBlock)(void);
@interface YXZhiNanDetailHeaderView : UIView
    @property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
    @property (weak, nonatomic) IBOutlet UILabel *titleLbl;
    @property (weak, nonatomic) IBOutlet UIButton *collBtn;
- (IBAction)collAction:(UIButton *)sender;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
    @property (weak, nonatomic) IBOutlet UILabel *contentLbl;
    @property (nonatomic,copy) BackVCBlock backVCBlock;
-(void)setHeaderViewData:(NSDictionary *)dic;
@property (nonatomic,assign) BOOL is_collect;
@end

NS_ASSUME_NONNULL_END
