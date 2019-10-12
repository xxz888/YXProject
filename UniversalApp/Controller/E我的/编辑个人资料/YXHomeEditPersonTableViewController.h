//
//  YXHomeEditPersonTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/24.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeEditPersonTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)finishAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeTitleImg;
- (IBAction)changeTitleImgAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
- (IBAction)sexBtnAction:(id)sender;
- (IBAction)addressBtnAction:(id)sender;
- (IBAction)birthBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIButton *adressBtn;
@property (weak, nonatomic) IBOutlet UIButton *birthBtn;
@property(nonatomic, strong) NSDictionary *userInfoDic;//用户信息
@property (weak, nonatomic) IBOutlet UIButton *qianMingBtn;


@end

NS_ASSUME_NONNULL_END
