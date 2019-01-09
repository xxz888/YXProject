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
#import "QiniuLoad.h"

#import<QiniuSDK.h>
#import<AFNetworking.h>
//#import <ComminCrypto/CommonCrypto.h>
#import<QN_GTM_Base64.h>
//#import<QBEtag.h>
#import<QNConfiguration.h>


#define kQNinterface @"官网获取外链域名"
static NSString *accessKey = @"官网获取";
static NSString *secretKey = @"官网获取";


@interface YXPublishImageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray * _photoImageList;
    NSString * _textViewInput;
}

@end

@implementation YXPublishImageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}
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
    _textViewInput = cell.textView.textView.text;
    return cell;
}
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cunCaoGaoAction:(id)sender {
}

#pragma mark ========== 发布 ==========
- (IBAction)fabuAction:(id)sender {
    kWeakSelf(self);
    //先上传到七牛云图片  再提交服务器
    [QiniuLoad uploadImageToQNFilePath:_photoImageList success:^(NSString *reslut) {
        NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        if (qiniuArray.count == 0) {
            [QMUITips showError:@"请上传图片" inView:self.view hideAfterDelay:2];
            return;
        }else if (qiniuArray.count == 1){
            [dic setValue:qiniuArray[0] forKey:@"photo1"];
            [dic setValue:@"" forKey:@"photo2"];
            [dic setValue:@"" forKey:@"photo3"];

        }else if (qiniuArray.count == 2){
            [dic setValue:qiniuArray[0] forKey:@"photo1"];
            [dic setValue:qiniuArray[1] forKey:@"photo2"];
            [dic setValue:@"" forKey:@"photo3"];

        }else if (qiniuArray.count == 3){
            [dic setValue:qiniuArray[0] forKey:@"photo1"];
            [dic setValue:qiniuArray[1] forKey:@"photo2"];
            [dic setValue:qiniuArray[2] forKey:@"photo3"];
        }else if (_textViewInput.length == 0){
            [QMUITips showError:@"请输入描述!" inView:self.view hideAfterDelay:2];
            return;
        }
        [dic setValue:_textViewInput forKey:@"describe"];//描述
        [dic setValue:@"杭州市野风现代之星3楼海底捞火锅" forKey:@"publish_site"];//地点
        [dic setValue:@"0" forKey:@"tag"];//标签
        //发布按钮
        [YX_MANAGER requestFaBuImagePOST:dic success:^(id object) {
            if ([object isEqualToString:@"1"]) {
                [QMUITips showSucceed:@"发布成功" inView:weakself.view hideAfterDelay:2];
                [weakself dismissViewControllerAnimated:YES completion:nil];
            }else{
                [QMUITips showError:@"发布失败,请稍后重试" inView:weakself.view hideAfterDelay:2];
            }
        }];
    } failure:^(NSString *error) {
        NSLog(@"%@",error);
    }];
    
    
    

}
-(NSString *)inImageOutString:(UIImage *)image{
      NSString *strTopper = [NSString stringWithFormat:@"%@", [UIImageJPEGRepresentation(image, 0.1f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return strTopper;
}

//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}



@end
