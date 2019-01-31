//
//  YXPublishFootViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/29.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeQuestionFaBuViewController.h"
typedef void(^dismissBlock) ();
NS_ASSUME_NONNULL_BEGIN

@interface YXPublishFootViewController : RootViewController
//block声明属性
@property (nonatomic, copy) dismissBlock mDismissBlock;
//block声明方法
-(void)toDissmissSelf:(dismissBlock)block;



@property (weak, nonatomic) IBOutlet UIView * questionMainView;
@property (weak, nonatomic) IBOutlet UIView * questionImageView;
@property (weak, nonatomic) IBOutlet UIButton *xinhuatiBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
- (IBAction)xinhuatiAction:(id)sender;
- (IBAction)moreAction:(id)sender;
@property(nonatomic,strong)NSString * cigar_id;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
- (IBAction)locationBtnAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
