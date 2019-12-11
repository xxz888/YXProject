//
//  YXWanShanXinXiViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/10.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXWanShanXinXiViewController : UIViewController
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *upLoadView;
@property (weak, nonatomic) IBOutlet UIImageView *upLoadImageView;
@property (weak, nonatomic) IBOutlet UILabel *upLoadLbl;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UIImageView *nvImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nanImageView;
@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;
- (IBAction)birthdayAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
- (IBAction)addressAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *qianmingTf;
- (IBAction)makeSureAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *maskSureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
- (IBAction)tiaoguoAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
