//
//  YXMessageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMessageViewController.h"
#import "YXMessageThreeDetailViewController.h"
#import <UMAnalytics/MobClick.h>
#import "YXMessageLiaoTianTableViewCell.h"
#import "SimpleChatMainViewController.h"
#import "JQFMDB.h"
#import "MessageModel.h"
@interface YXMessageViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic) BOOL isCanBack;
@property (nonatomic) BOOL isEnable;
@property (weak, nonatomic) IBOutlet UITableViewCell *runCell;
@property(nonatomic, strong) NSMutableArray * dbMessageArray;//用户信息

@end

@implementation YXMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"我的消息";
    [self setUI];
    
}
-(void)refreshVC{
    [self getNewMessageNumeber];
       self.isEnable = [self isUserNotificationEnable];
       [self.dbMessageArray removeAllObjects];
       JQFMDB *db = [JQFMDB shareDatabase];
       NSArray *dictArray = [db jq_lookupTable:YX_USER_LiaoTian dicOrModel:[MessageModel class] whereFormat:nil];
       [self makeSamePersonInfo:dictArray];
       
       [self.tableView reloadData];
}
-(void)headerRereshing{
   [self refreshVC];

    
    kWeakSelf(self);
    DO_IN_MAIN_QUEUE_AFTER(0.5f, ^{
         [weakself.tableView.mj_header endRefreshing];
         [weakself.tableView.mj_footer endRefreshing];
     });
}
-(void)footerRereshing{
    kWeakSelf(self);
    DO_IN_MAIN_QUEUE_AFTER(0.5f, ^{
          [weakself.tableView.mj_header endRefreshing];
          [weakself.tableView.mj_footer endRefreshing];
      });
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tuisongxiaoxi:) name:@"tuisongxiaoxi" object:nil];
    [self refreshVC];
}
-(void)makeSamePersonInfo:(NSArray *)dictArray{
    UserInfo * userInfo = curUser;
    //先得到自己的id
    NSString * ownId = userInfo.id;
    //下面开始算法，把相同的放在一起
    NSMutableArray * ownArray = [[NSMutableArray alloc]init];
    //先取出自己的记录
    for (MessageModel * dictModel in dictArray) {
        //只要own_id 和 aim_id有一个是自己，那就说明这条信息和自己有关
        BOOL messageBool = [userInfo.id isEqualToString:dictModel.own_id] || [userInfo.id isEqualToString:dictModel.aim_id];
        //如果是自己，就把所有和自己相关的数据拿出来
        if (messageBool) {
            [ownArray addObject:dictModel];
        }
    }
    //自己数据拿出来后，开始取出不同的好友分组
    NSMutableArray * ownFriendIdArray = [[NSMutableArray alloc]init];
    for (MessageModel * dictModel in ownArray) {
        //如果aimid是自己，就取ownid
        if ([dictModel.aim_id isEqualToString:ownId]) {
            [ownFriendIdArray addObject:dictModel.own_id];
        }
        //如果ownid是自己，就取aimid
        if ([dictModel.own_id isEqualToString:ownId]) {
            [ownFriendIdArray addObject:dictModel.aim_id];
        }
    }
    //然后给好友分组的数组去重
    NSSet *set = [NSSet setWithArray:ownFriendIdArray];
    //得到有多少好友id的数组，就是这个界面显示几行
    NSMutableArray * rowIdArry = [NSMutableArray arrayWithArray:[set allObjects]];
    
    
    
    //然后根据id来分组
    for (NSString * rowId in rowIdArry) {
        NSMutableArray * resultArray = [[NSMutableArray alloc]init];
        for (MessageModel * dictModel in ownArray) {
                if ([dictModel.aim_id isEqualToString:ownId] && [dictModel.own_id isEqualToString:rowId]) {
                     [resultArray addObject:dictModel];
                }
                if ([dictModel.aim_id isEqualToString:rowId] && [dictModel.own_id isEqualToString:ownId]) {
                    [resultArray addObject:dictModel];
                }
         }
        [self.dbMessageArray addObject:resultArray];
    }
    

}
-(void)tuisongxiaoxi:(NSNotification *)notice{
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setUI{
    self.dbMessageArray = [[NSMutableArray alloc]init];
    ViewBorderRadius(self.zanjb, 8, 1, KWhiteColor);
    ViewBorderRadius(self.fensijb, 8, 1, KWhiteColor);
    ViewBorderRadius(self.hdjb, 8, 1, KWhiteColor);
    
    //view添加点击事件
    UITapGestureRecognizer *tapGesturRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    self.view1.tag = 1001;
    [self.view1 addGestureRecognizer:tapGesturRecognizer1];
    
    UITapGestureRecognizer *tapGesturRecognizer2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    self.view2.tag = 1002;
    [self.view2 addGestureRecognizer:tapGesturRecognizer2];
    
    UITapGestureRecognizer *tapGesturRecognizer3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    self.view3.tag = 1003;
    [self.view3 addGestureRecognizer:tapGesturRecognizer3];
    [self addShadowToView:self.stackView withColor:kRGBA(102, 102, 102, 0.3)];
    ViewBorderRadius(self.tuisongBtn, 2, 1, kRGBA(10, 36, 51, 1));
    ViewBorderRadius(self.yiduBtn, 11, 1, kRGBA(238, 238, 238, 1));
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YXMessageLiaoTianTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMessageLiaoTianTableViewCell"];
    
    [self addRefreshView:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return self.dbMessageArray.count;
    }else{
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==2&&indexPath.row==1) {
        if (_isEnable) {
            return 0;
        }else{
            if ([self isUserNotificationEnable]) {
                return 0;
            }else{
                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            }
        }
        return 0;
    }else  if (indexPath.section == 3) {
        return 80;
    }
    else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(3 == indexPath.section){//爱好 （动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:3]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        YXMessageLiaoTianTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMessageLiaoTianTableViewCell" forIndexPath:indexPath];
        MessageModel * model = [self.dbMessageArray[indexPath.row] lastObject];
        
     
        cell.ltContent.text = model.text;
        
        UserInfo * userInfo = curUser;

        
        NSString * photo = @"";
        NSString * username = @"";
        if ([userInfo.id isEqualToString:model.own_id]) {
            photo = [ShareManager stringToDic:model.aim_info][@"photo"];
            username = [ShareManager stringToDic:model.aim_info][@"username"];
        }else{
            photo = [ShareManager stringToDic:model.own_info][@"photo"];
            username = [ShareManager stringToDic:model.own_info][@"username"];
        }
        
        cell.ltTitle.text = username;
        [cell.ltImv sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:photo]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
        cell.ltTime.text = [ShareManager haomiaoNianYueRi:[ShareManager getOtherTimeStrWithString:model.time]];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    kWeakSelf(self);
        [YXPLUS_MANAGER requestChatting_ListoryGet:@"" success:^(id object) {
                 MessageModel * model = [self.dbMessageArray[indexPath.row] lastObject];
                 SimpleChatMainViewController * vc = [[SimpleChatMainViewController alloc]init];
            UserInfo * userInfo = curUser;

                 NSString * photo = @"";
                 NSString * username = @"";
                 NSString * otherId = @"";

                     if ([userInfo.id isEqualToString:model.own_id]) {
                         photo = [ShareManager stringToDic:model.aim_info][@"photo"];
                         username = [ShareManager stringToDic:model.aim_info][@"username"];
                         otherId = model.aim_id;
                     }else{
                         photo = [ShareManager stringToDic:model.own_info][@"photo"];
                         username = [ShareManager stringToDic:model.own_info][@"username"];
                         otherId = model.own_id;
                     }
            
                vc.userInfoDic = @{@"photo":photo,@"username":username,@"id":otherId};
                  vc.requestObject =[NSDictionary dictionaryWithDictionary:object];
                 [weakself.navigationController pushViewController:vc animated:YES];
          }];
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"聊天置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 收回侧滑
        [tableView setEditing:NO animated:YES];
    }];


    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    // 删除cell: 必须要先删除数据源，才能删除cell
//    [self.dataArray removeObjectAtIndex:indexPath.row];
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}];

return @[deleteAction, editAction];
}




/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 1;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    theView.layer.cornerRadius = 5;
    
}
-(void)tapAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    YXMessageThreeDetailViewController * VC = [[YXMessageThreeDetailViewController alloc]init];
    switch (tag) {
        case 1001:
            VC.title = @"点赞消息";
            VC.whereCome = 1;
            self.zanjb.hidden = YES;
            break;
        case 1002:
            VC.title = @"新增粉丝";
            VC.whereCome = 2;
            self.fensijb.hidden = YES;
            break;
        case 1003:
            VC.title = @"评论互动";
            VC.whereCome = 3;
            self.hdjb.hidden = YES;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)getNewMessageNumeber{
    kWeakSelf(self);
    [YX_MANAGER requestGETNewMessageNumber:@"" success:^(id object) {
        weakself.zanjb.text = kGetString(object[@"praise_number"]);
        weakself.fensijb.text = kGetString(object[@"fans_number"]);
        weakself.hdjb.text = kGetString(object[@"comment_number"]);
        
        weakself.zanjb.hidden = [weakself.zanjb.text isEqualToString:@"0"];
        weakself.fensijb.hidden = [weakself.fensijb.text isEqualToString:@"0"];
        weakself.hdjb.hidden = [weakself.hdjb.text isEqualToString:@"0"];
     
    }];
}




- (IBAction)tuisongAction:(id)sender {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    [self goToAppSystemSetting];
}

- (IBAction)closeTuiSong:(id)sender {
    _isEnable = YES;
    [self.tableView reloadData];
}

- (BOOL)isUserNotificationEnable { // 判断用户是否允许接收通知
    _isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        _isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    } else { // iOS版本 <8.0 处理逻辑
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        _isEnable = (UIRemoteNotificationTypeNone == type) ? NO : YES;
    }
    return _isEnable;
}
// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
- (void)goToAppSystemSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
    }
}
@end
