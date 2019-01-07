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
#import "ZZYPhotoHelper.h"

@interface YXPublishImageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray * _photoImageList;
}

@end

@implementation YXPublishImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.yxTableview registerNib:[UINib nibWithNibName:@"YXPublishImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXPublishImageTableViewCell"];
    
    //各种控件样式
    [self initControl];
    //初始化选择图片
    [self initImagePhontoView];
}
-(void)initControl{
    UIColor * color1 = [UIColor darkGrayColor];
    [self.cunCaogaoBtn setTitleColor:color1 forState:UIControlStateNormal];
    ViewBorderRadius(self.cunCaogaoBtn, 5, 1, color1);
    
    [self.fabuBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [self.fabuBtn setBackgroundColor:color1];
    ViewBorderRadius(self.fabuBtn, 5, 1, color1);

    [self.buttonFabuBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [self.buttonFabuBtn setBackgroundColor:color1];

    _photoImageList = [[NSMutableArray alloc]init];
}
-(void)initImagePhontoView{
    kWeakSelf(self);
    LLImagePickerView *pickerV = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, 0, KScreenWidth, 0) CountOfRow:3];
    pickerV.type = LLImageTypeAll;
    pickerV.maxImageSelected = 8;
    pickerV.allowPickingVideo = YES;
    weakself.yxTableview.tableHeaderView = pickerV;
    [pickerV observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        [_photoImageList removeAllObjects];
        for (LLImagePickerModel * model in list) {
            [_photoImageList addObject:model.image];
        }
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
- (IBAction)cunCaoGaoAction:(id)sender {
}

#pragma mark ========== 发布 ==========
- (IBAction)fabuAction:(id)sender {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    if (_photoImageList.count == 0) {
        [QMUITips showError:@"请上传图片" inView:self.view hideAfterDelay:2];
        return;
    }else if (_photoImageList.count == 1){
        [dic setValue:[self inImageOutString:_photoImageList[0]] forKey:@"photo1"];
    }else if (_photoImageList.count == 2){
        [dic setValue:[self inImageOutString:_photoImageList[0]] forKey:@"photo1"];
        [dic setValue:[self inImageOutString:_photoImageList[1]] forKey:@"photo2"];
    }else if (_photoImageList.count == 3){
        [dic setValue:[self inImageOutString:_photoImageList[0]] forKey:@"photo1"];
        [dic setValue:[self inImageOutString:_photoImageList[1]] forKey:@"photo2"];
        [dic setValue:[self inImageOutString:_photoImageList[2]] forKey:@"photo3"];
    }
   
    [dic setValue:@"风景图片" forKey:@"describe"];//描述
    [dic setValue:@"杭州市海底捞火锅" forKey:@"publish_site"];//地点
    [dic setValue:@"0" forKey:@"tag"];//标签

    [YX_MANAGER requestFaBuImagePOST:dic success:^(id object) {
        
    }];
}
-(NSString *)inImageOutString:(UIImage *)image{
      NSString *strTopper = [NSString stringWithFormat:@"%@", [UIImageJPEGRepresentation(image, 0.1f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return strTopper;
}
@end
