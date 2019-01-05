//
//  YXPublishImageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/5.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishImageViewController.h"
#import "LLImagePickerView.h"

@interface YXPublishImageViewController ()

@end

@implementation YXPublishImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initImagePhontoView];
}
-(void)initImagePhontoView{
    LLImagePickerView *pickerV = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, 0, self.photoImageView.bounds.size.width, 0) CountOfRow:3];
    pickerV.type = LLImageTypeAll;
    pickerV.maxImageSelected = 8;
    pickerV.allowPickingVideo = YES;
    [self.photoImageView addSubview:pickerV];
    [pickerV observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        NSLog(@"%@",list);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
