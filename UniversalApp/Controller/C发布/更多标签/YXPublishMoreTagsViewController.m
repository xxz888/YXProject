//
//  YXPublishMoreTagsViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishMoreTagsViewController.h"
#import "YXGridView.h"
#import "YXPublishNewTagView.h"
#import "BRStringPickerView.h"
@interface YXPublishMoreTagsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CBSegmentView * sliderSegmentView;
    UITextField * searchBar;
}
@property(nonatomic,strong)NSMutableArray * tagArray;
@property(nonatomic,strong)NSString * type;

@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic, strong) QMUIGridView *gridView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * tagIdArray;

@property(nonatomic,strong)YXPublishNewTagView * contentView;
@property(nonatomic,strong)NSString  * tag_type;
@end

@implementation YXPublishMoreTagsViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.yxTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.topview addSubview: [self headerView]];
    self.yxTableView.separatorColor = YXRGBAColor(239, 239, 239);

    [self setNavSearchView];
    self.tagArray = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
    self.tagIdArray = [[NSMutableArray alloc]init];
    [self addRefreshView:self.yxTableView];
    //    [self requestGetTag];
    [self requestFindTag];
    self.yxTableView.tableFooterView = [[UIView alloc]init];
    
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestGetTagLIst:self.type];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestGetTagLIst:self.type];

}
#pragma mark ========== 先请求tag列表,获取发现页标签数据 ==========
-(void)requestFindTag{
    kWeakSelf(self);
    [self.tagArray removeAllObjects];
    [self.tagIdArray removeAllObjects];
    [YX_MANAGER requestGet_users_find_tag:@"" success:^(id object) {
        

        for (NSDictionary * dic in object) {
            [weakself.tagArray addObject:dic[@"type"]];
            [weakself.tagIdArray addObject:kGetString(dic[@"id"])];
        }
        [sliderSegmentView setTitleArray:weakself.tagArray withStyle:CBSegmentStyleSlider];
        weakself.type = kGetString(weakself.tagIdArray[0]);
        [weakself requestGetTagLIst:kGetString(weakself.tagIdArray[0])];
    }];
}
#pragma mark ========== 根据标签请求列表 ==========
-(void)requestGetTagLIst:(NSString *)page{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",page,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGetTagList:par success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
-(UIView *)headerView{
    kWeakSelf(self);
    sliderSegmentView = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    sliderSegmentView.titleChooseReturn = ^(NSInteger x) {
        
        weakself.type = weakself.tagIdArray[x];
        [weakself requestGetTagLIst:weakself.type];
    };
    return sliderSegmentView;
}

#pragma mark ========== 搜索标签 ==========
-(void)searchTagResult:(NSString *)text{
    kWeakSelf(self);
    [YX_MANAGER requestGetTagList_Tag:@{@"type":self.type,@"key":text,@"page":@"1"} success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self searchTagResult:text];
    return YES;
}









-(void)textField1TextChange:(UITextField *)tf{
    if (tf.text.length == 0) {
        [self requestGetTagLIst:self.type];
    }
}
-(void)closeView{
    [self dismissViewControllerAnimated:YES completion:nil ];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.textLabel.text =  [NSString stringWithFormat:@"#%@",self.dataArray[indexPath.row][@"tag"]];
    cell.textLabel.textColor = kRGBA(68, 68, 68, 1);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    [self dismissViewControllerAnimated:YES completion:^{
        weakself.tagBlock(weakself.dataArray[indexPath.row]);
    }];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (IBAction)newHuatiAction:(id)sender {
    [self handleShowContentView];
}
- (void)handleShowContentView {
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXPublishNewTagView" owner:self options:nil];
    _contentView = [nib objectAtIndex:0];
    _contentView.frame = CGRectMake(20, 110, KScreenWidth-40, 403);
    _contentView.backgroundColor = KClearColor;
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = _contentView;
    [modalViewController showWithAnimated:YES completion:nil];
    kWeakSelf(self);

    
    
    //关闭
    _contentView.closeblock = ^{
        [modalViewController hideWithAnimated:YES completion:nil];;
    };
    //发布到哪
    _contentView.fabublock = ^{
        [BRStringPickerView showStringPickerWithTitle:@"发布到" dataSource:weakself.tagArray defaultSelValue:@"" resultBlock:^(id selectValue) {
            [weakself.contentView.fabuBtn setTitle:selectValue forState:UIControlStateNormal];
        }];
    };
    //确认
    _contentView.makeSureblock = ^{
        if ([weakself.contentView.fabuBtn.titleLabel.text isEqualToString:@"发布到"]) {
            [QMUITips showError:@"清选择发布的类目" inView:weakself.contentView hideAfterDelay:1.0];            
            return ;
        }
        if (weakself.contentView.huatiTf.text.length == 0) {
            [QMUITips showError:@"请填写话题内容" inView:weakself.contentView hideAfterDelay:1.0];

           return ;
        }
        [modalViewController hideWithAnimated:YES completion:nil];;
        NSDictionary * dic = @{@"tag":weakself.contentView.huatiTf.text,@"tag_type":weakself.type,@"tag_id":@"",@"type":@"1"};
        [YXPLUS_MANAGER requestAddIu_tagPOST:dic success:^(id object) {
            [weakself dismissViewControllerAnimated:YES completion:^{
                weakself.tagBlock(@{@"tag":weakself.contentView.huatiTf.text});
            }];
        }];
    };
    
  
    
}
@end
