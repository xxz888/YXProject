//
//  YXDingZhiPingLunViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXDingZhiPingLunViewController : UIViewController
- (IBAction)fabiaoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fabuTitle;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *starLbl;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIView *threeImgView;
@property (weak, nonatomic) IBOutlet UITextField *xiaofeiTf;
@property (weak, nonatomic) IBOutlet UIButton *nimingBtn;
- (IBAction)nimingAction:(id)sender;



@end

NS_ASSUME_NONNULL_END
