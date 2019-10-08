//
//  YXFaBuNewVCViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/6.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXFaBuNewVCViewController.h"
#import "YXPublishImageViewController.h"
#import "EditorViewController.h"
@interface YXFaBuNewVCViewController ()

@end

@implementation YXFaBuNewVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = KClearColor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shaituAction:(id)sender {
    YXPublishImageViewController * imageVC = [[YXPublishImageViewController alloc]init];
    kWeakSelf(self);
    imageVC.closeNewVcblock = ^{
        weakself.block();
    };
    imageVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imageVC animated:YES completion:nil];
}

- (IBAction)wenzhangAction:(id)sender {
    EditorViewController * pinpaiVC = [[EditorViewController alloc]init];
    kWeakSelf(self);

    pinpaiVC.closeNewVcblock = ^{
          weakself.block();
      };
    pinpaiVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pinpaiVC animated:YES completion:nil];
}

- (IBAction)closeAction:(id)sender {
    self.block();
}

@end
