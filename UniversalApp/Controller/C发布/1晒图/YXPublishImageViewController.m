//
//  YXPublishImageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/5.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishImageViewController.h"
#import "LLImagePickerView.h"
#import "YXPublishImageTableViewCell.h"
@interface YXPublishImageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YXPublishImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.yxTableview registerNib:[UINib nibWithNibName:@"YXPublishImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXPublishImageTableViewCell"];

    [self initImagePhontoView];
}
-(void)initImagePhontoView{
    kWeakSelf(self);
    LLImagePickerView *pickerV = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, 0, KScreenWidth, 0) CountOfRow:3];
    pickerV.type = LLImageTypeAll;
    pickerV.maxImageSelected = 8;
    pickerV.allowPickingVideo = YES;
    weakself.yxTableview.tableHeaderView = pickerV;
    [pickerV observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        NSLog(@"%@",list);
        weakself.yxTableview.tableHeaderView = pickerV;

        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXPublishImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXPublishImageTableViewCell" forIndexPath:indexPath];
    return cell;
}
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
