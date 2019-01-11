//
//  YXHomeQuestionFaBuViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeQuestionFaBuViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *questionTitleTf;
@property (weak, nonatomic) IBOutlet UIView *questionMainView;
@property (weak, nonatomic) IBOutlet UIView *questionImageView;
@property (weak, nonatomic) IBOutlet UIButton *xinhuatiBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
- (IBAction)xinhuatiAction:(id)sender;
- (IBAction)moreAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
