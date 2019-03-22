//
//  YXBindPhoneViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^bingFinishBlock)();
@interface YXBindPhoneViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UIButton *getMes_codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeAction:(id)sender;
- (IBAction)bindAction:(id)sender;
@property (nonatomic,strong) NSString *unique_id;
@property (weak, nonatomic) IBOutlet UILabel *tipTopLbl;
@property (weak, nonatomic) IBOutlet UIButton *bingBtn;

@property (nonatomic) BOOL whereCome;// yes 更换手机号
@property (nonatomic,copy) bingFinishBlock bindBlock;
@end

NS_ASSUME_NONNULL_END
