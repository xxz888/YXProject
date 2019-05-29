//
//  YXZhiNanDetailHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IXAttributeTapLabel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^BackVCBlock)(void);
typedef void(^OpenBlock)(UIButton *);
@interface YXZhiNanDetailHeaderView : UIView
    @property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
    @property (weak, nonatomic) IBOutlet UILabel *titleLbl;
    @property (weak, nonatomic) IBOutlet UIButton *collBtn;
- (IBAction)collAction:(UIButton *)sender;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
    @property (weak, nonatomic) IBOutlet IXAttributeTapLabel *contentLbl;
    @property (nonatomic,copy) BackVCBlock backVCBlock;
@property (nonatomic,copy) OpenBlock openBlock;
-(void)setHeaderViewData:(NSDictionary *)dic;
@property (nonatomic,assign) BOOL is_collect;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (nonatomic,strong) NSDictionary * dic;

@end

NS_ASSUME_NONNULL_END
