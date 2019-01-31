//
//  YXPublishImageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/5.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishImageViewController.h"
#import "YXGaoDeMapViewController.h"
#import "YXPublishMoreTagsViewController.h"
#import "LLImagePickerView.h"
#import "YXPublishImageTableViewCell.h"
#import "ZZYPhotoHelper.h"
#import "QiniuLoad.h"


#import<QiniuSDK.h>
#import<AFNetworking.h>
#import<QN_GTM_Base64.h>
#import<QNConfiguration.h>
#import "CBGroupAndStreamView.h"


#define kQNinterface @"官网获取外链域名"
static NSString *accessKey = @"官网获取";
static NSString *secretKey = @"官网获取";



@interface YXPublishImageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray * _photoImageList;
    NSString * _textViewInput;
    NSString * _locationString;
}
@property (strong, nonatomic) CBGroupAndStreamView * menueView;
@property (weak, nonatomic) IBOutlet UIView *floatView;
@property(nonatomic,strong)NSMutableDictionary * caoGaoDic;
@property(nonatomic,strong)NSMutableArray * tagArray;

@end

@implementation YXPublishImageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.yxTableview registerNib:[UINib nibWithNibName:@"YXPublishImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXPublishImageTableViewCell"];
    _tagArray = [[NSMutableArray alloc]init];
    self.caoGaoDic = [[NSMutableDictionary alloc]init];
    self.caoGaoDic = UserDefaultsGET(YX_USER_FaBuCaoGao);

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
    pickerV.maxImageSelected = 3;
    pickerV.allowPickingVideo = NO;
    
    NSMutableArray * preArray = [[NSMutableArray alloc]init];
    if (self.caoGaoDic) {
        if (self.caoGaoDic[@"photo1"]) {
            [preArray addObject:self.caoGaoDic[@"photo1"]];
        }else  if (self.caoGaoDic[@"photo2"]) {
            [preArray addObject:self.caoGaoDic[@"photo2"]];
        }else if (self.caoGaoDic[@"photo3"]) {
            [preArray addObject:self.caoGaoDic[@"photo3"]];
        }
    }
    pickerV.preShowMedias = [NSArray arrayWithArray:preArray];
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
    return 280;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXPublishImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXPublishImageTableViewCell" forIndexPath:indexPath];
    _textViewInput = cell.textView.textView.text;
    _locationString = cell.locationBtn.titleLabel.text;
    kWeakSelf(self);
    //新话题
    cell.block = ^(NSString * tagString) {
        [weakself.tagArray addObject:tagString];
        if (weakself.menueView) {
            [_menueView setContentView:@[_tagArray] titleArr:@[]];
        }else{
            [weakself addNewTags];
        }
    };
    //位置
    cell.locationblock = ^(YXPublishImageTableViewCell * cell) {
        YXGaoDeMapViewController * VC = [[YXGaoDeMapViewController alloc]init];
        VC.block = ^(NSString * locationString) {
            _locationString = locationString;
            [cell.locationBtn setTitle:locationString forState:0];
            [weakself dismissViewControllerAnimated:YES completion:nil];
        };
        RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
        [weakself presentViewController:nav animated:YES completion:nil];
    };
    //更多标签
    cell.moreBlock = ^{
        YXPublishMoreTagsViewController * VC = [[YXPublishMoreTagsViewController alloc]init];
        RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
        VC.tagBlock = ^(NSDictionary * dic) {
            [_tagArray addObject:[@"#" append:dic[@"tag"]]];
            if (weakself.menueView) {
                [_menueView setContentView:@[_tagArray] titleArr:@[]];
            }else{
                [weakself addNewTags];
            }
        };
        [weakself presentViewController:nav animated:YES completion:nil];
    };
    
    return cell;
}
- (IBAction)closeView:(id)sender {
    [self finishPublish];
}
#pragma mark - 完成发布
//完成发布
-(void)finishPublish{
    //2.block传值
    if (self.mDismissBlock != nil) {
        self.mDismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//block声明方法
-(void)toDissmissSelf:(dismissBlock)block{
    self.mDismissBlock = block;
}
#pragma mark ========== 发布1 和 存草稿0  ==========
- (IBAction)fabuAction:(UIButton *)btn {
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
        
        
        
        NSString * publish_site = [_locationString isEqualToString:@"你的位置"] ? @"" : _locationString;
        [dic setValue:publish_site forKey:@"publish_site"];//地点
        if (_tagArray.count == 0) {
            [dic setValue:@"" forKey:@"tag"];//标签
        }else{
            NSString *string = [_tagArray componentsJoinedByString:@","];
            [dic setValue:string forKey:@"tag"];//标签
        }
        
        if (btn.tag == 0) {
            UserDefaultsSET(dic, YX_USER_FaBuCaoGao);
            [QMUITips showSucceed:@"存草稿成功" inView:weakself.view hideAfterDelay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            [weakself requestFabu:dic];
        }
    } failure:^(NSString *error) {
        NSLog(@"%@",error);
    }];
}
-(void)requestFabu:(NSMutableDictionary *)dic{
    kWeakSelf(self);
    //发布按钮
    [YX_MANAGER requestFaBuImagePOST:dic success:^(id object) {
            [QMUITips showSucceed:@"发布成功" inView:weakself.view hideAfterDelay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself finishPublish];
            });
    }];
}
-(void)dismissVC{
}
-(void)addNewTags{
    NSArray * titleArr = @[@""];
    NSArray *contentArr = @[_tagArray];
    CBGroupAndStreamView * silde = [[CBGroupAndStreamView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.floatView.bounds.size.height)];
    silde.isSingle = YES;
    silde.radius = 5;
    silde.font = [UIFont systemFontOfSize:12];
    silde.titleTextFont = [UIFont systemFontOfSize:18];
    [silde setContentView:contentArr titleArr:titleArr];
    [self.floatView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.floatView addSubview:silde];
    _menueView = silde;
    kWeakSelf(self);
    silde.cb_selectCurrentValueBlock = ^(NSString *value, NSInteger index, NSInteger groupId) {
        NSMutableArray * array = [NSMutableArray arrayWithArray:weakself.tagArray];
        [array removeObjectAtIndex:index];
        [weakself.tagArray removeAllObjects];
        [weakself.tagArray addObjectsFromArray:array];
        [_menueView setContentView:@[weakself.tagArray] titleArr:@[]];
    };
}



@end
