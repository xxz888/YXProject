//
//  YXMineMyCaoGaoViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineMyCaoGaoViewController.h"
#import "YXFaBuBaseViewController.h"
#import "JQFMDB.h"
#import "YXShaiTuModel.h"
#import "YXWenZhangEditorViewController.h"
#import "YXHomeXueJiaTableViewCell.h"
@interface YXMineMyCaoGaoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic,strong)NSArray * caoGaoArray;
@property(nonatomic,strong)NSMutableDictionary * caoGaoDic;

@end

@implementation YXMineMyCaoGaoViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    JQFMDB *db = [JQFMDB shareDatabase];
    self.caoGaoArray = [db jq_lookupTable:YX_USER_FaBuCaoGao dicOrModel:[YXShaiTuModel class] whereFormat:nil];
    [self.yxTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationItemWithTitles:@[@"清空所有"] isLeft:NO target:self action:@selector(clearCachae) tags:@[@1000]];

    self.title = @"我的草稿";
    self.caoGaoDic = [[NSMutableDictionary alloc]init];
    self.yxTableView.backgroundColor = KWhiteColor;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaTableViewCell"];
    self.yxTableView.delegate= self;
    self.yxTableView.dataSource = self;
    self.yxTableView.tableFooterView = [[UIView alloc]init];
    self.yxTableView.separatorStyle = 0;

    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clearAll:(id)sender {
    [self clearCachae];
}

-(void)clearCachae{
    kWeakSelf(self);
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        JQFMDB *db = [JQFMDB shareDatabase];
        if ([db jq_isExistTable:YX_USER_FaBuCaoGao]) {
            [db jq_deleteAllDataFromTable:YX_USER_FaBuCaoGao];
        }
        weakself.caoGaoArray = [db jq_lookupTable:YX_USER_FaBuCaoGao dicOrModel:[YXShaiTuModel class] whereFormat:nil];
        [weakself.yxTableView reloadData];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
    
    
 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.caoGaoArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YXHomeXueJiaTableViewCell";
    YXHomeXueJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[YXHomeXueJiaTableViewCell alloc]initWithStyle:0 reuseIdentifier:identify];
    }
    cell.selectionStyle = 0;
    cell.cellAutherLbl.hidden = YES;
    YXShaiTuModel * model =  self.caoGaoArray[indexPath.row];
    if ([model.obj integerValue] == 1) {
        NSArray * photo_list = [model.photo_list split:@","];
        NSString * showCoverImg = @"";
        if (photo_list.count > 0) {
            showCoverImg = [IMG_URI append:photo_list[0]];
        }
        NSString * str = [(NSMutableString *)showCoverImg replaceAll:@" " target:@"%20"];
        [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        cell.cellLbl.text = model.detail;
        cell.cellDataLbl.text = @"晒图";
    }else{
        if (model.cover) {
            NSString * str = [(NSMutableString *)[IMG_URI append:model.cover] replaceAll:@" " target:@"%20"];
                  [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        }else{
              [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        }
      
          cell.cellLbl.text = model.title;
          cell.cellDataLbl.text = @"文章";

    }


    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXShaiTuModel * model = self.caoGaoArray[indexPath.row];
    if ([model.obj integerValue] == 1) {
            YXFaBuBaseViewController * imageVC = [[YXFaBuBaseViewController alloc]init];
            imageVC.model =model;
            imageVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:imageVC animated:YES completion:nil];
    }else{
             YXWenZhangEditorViewController * wenzhangVC = [[YXWenZhangEditorViewController alloc]init];
             wenzhangVC.model = model;
             wenzhangVC.modalPresentationStyle = UIModalPresentationFullScreen;
             [self presentViewController:wenzhangVC animated:YES completion:nil];
    }
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    YXShaiTuModel * model = self.caoGaoArray[indexPath.row];
    kWeakSelf(self);
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        JQFMDB *db = [JQFMDB shareDatabase];
        NSString * sql = [@"WHERE coustomId = " append:kGetString(model.coustomId)];
        [db jq_deleteTable:YX_USER_FaBuCaoGao whereFormat:sql];
        completionHandler (YES);
        weakself.caoGaoArray = [db jq_lookupTable:YX_USER_FaBuCaoGao dicOrModel:[YXShaiTuModel class] whereFormat:nil];
        [weakself.yxTableView reloadData];
    }];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}
@end
