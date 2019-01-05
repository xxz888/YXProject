//
//  YXMineViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface YXMineViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIImageView *mineImageView;
@property (weak, nonatomic) IBOutlet UILabel *mineTitle;
@property (weak, nonatomic) IBOutlet UILabel *mineAdress;

@property (weak, nonatomic) IBOutlet UILabel *guanzhuCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *fensiCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *tieshuCountLbl;

- (IBAction)guanzhuAction:(id)sender;
- (IBAction)fensiAction:(id)sender;
- (IBAction)tieshuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
- (IBAction)guanzhuAction:(id)sender;

@end
