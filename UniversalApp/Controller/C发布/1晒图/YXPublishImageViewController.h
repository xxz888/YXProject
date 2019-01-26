//
//  YXPublishImageViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/5.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface YXPublishImageViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableview;
@property (weak, nonatomic) IBOutlet UIButton *cunCaogaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *fabuBtn;
- (IBAction)fabuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonFabuBtn;

@end
