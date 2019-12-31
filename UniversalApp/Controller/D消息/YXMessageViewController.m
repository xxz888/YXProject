//
//  YXMessageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMessageViewController.h"
#import "YXMessageThreeDetailViewController.h"
#import "YXMessageLiaoTianTableViewCell.h"
#import "SimpleChatMainViewController.h"
#import "JQFMDB.h"
#import "MessageModel.h"
#import "MessageFrameModel.h"
@interface YXMessageViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic) BOOL isCanBack;
@property (nonatomic) BOOL isEnable;
@property (weak, nonatomic) IBOutlet UITableViewCell *runCell;
@property(nonatomic, strong) NSMutableArray * dbMessageArray;//用户信息
/**
 消息数组
 */
- (IBAction)yiduAction:(id)sender;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *dbArray;
@property (nonatomic, strong) NSMutableArray *bendiArray;
@property (nonatomic, strong) NSDictionary * requestObject;

@property (nonatomic, strong) NSDictionary * userInfoDic;
@property (nonatomic, strong) NSMutableArray * yiduArray;
@property (nonatomic, strong) UIImageView * noMessageImV;

@end

@implementation YXMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"我的消息";
    self.yiduArray = [[NSMutableArray alloc]init];
   for (NSInteger i = 0; i< 100; i++) {
            [self.yiduArray  addObject:@"0"];
   }
    [self setUI];
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tuisongxiaoxi:) name:@"tuisongxiaoxi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(KAppShow:) name:KAPP_SHOW object:nil];
    [self refreshVC];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[AppDelegate shareAppDelegate].mainTabBar.axcTabBar setBadge:NSIntegerToNSString(0) index:2];
}
-(void)KAppShow:(NSNotification*)notice{
    [self requestWeiDuMessage];
}

-(void)refreshVC{
    [self getNewMessageNumeber];
    self.isEnable = [self isUserNotificationEnable];
    [self requestWeiDuMessage];
}
- (void)loginStateChange:(NSNotification *)notification{
    [self requestWeiDuMessage];
}
//未读信息的处理
-(void)requestWeiDuMessage{
    kWeakSelf(self);
    [YXPLUS_MANAGER requestChatting_ListoryGet:@"" success:^(id object) {
        
        
        
           for (NSArray * dataArray in  object[@"data"]) {
                 for (NSDictionary * defineDic in dataArray) {
            NSDictionary * messNewDic = defineDic;
            NSString * ownId = kGetString(messNewDic[@"own_id"]);
            NSString * aimId = kGetString(messNewDic[@"aim_id"]);

            if ([WP_TOOL_ShareManager getOwnListDbMessage:messNewDic[@"own_id"] aim_id:messNewDic[@"aim_id"]]) {
                for (NSInteger i = 0; i<self.dbMessageArray.count; i++) {
                    for (MessageFrameModel * dictModel in self.dbMessageArray[i]) {
                          if ([dictModel.message.aim_id isEqualToString:ownId] && [dictModel.message.own_id isEqualToString:aimId]) {
                                [self.yiduArray  replaceObjectAtIndex:i withObject:@"1"];
                                break;
                            }
                            if ([dictModel.message.aim_id isEqualToString:aimId] && [dictModel.message.own_id isEqualToString:ownId]) {
                                [self.yiduArray  replaceObjectAtIndex:i withObject:@"1"];
                                break;
                            }
                    }
                }
            }
                 }
        }
        
        for (NSArray * dataArray in  object[@"data"]) {
            for (NSDictionary * messNewDic in dataArray) {
                if ([WP_TOOL_ShareManager getOwnListDbMessage:messNewDic[@"own_id"] aim_id:messNewDic[@"aim_id"]]) {
                    [WP_TOOL_ShareManager receiveAllKindsMessage:messNewDic message:self.messages userInfoDic:self.userInfoDic type:1];
                }
            }
        }
        //先请求完未读的，在看看不在这个界面时候，有没有未读的
        [weakself getSocketWeiDuMessage];
    }];
}
//在线，在本界面,接受到socket信息的处理,就是看那个接受消息的数组
- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    [self getSocketWeiDuMessage];
}
//在线，在不在本页面,同一个方法，都是接收到socket信息处理
-(void)getSocketWeiDuMessage{
    

    for (NSDictionary * defineDic in YX_MANAGER.socketMessageArray) {
        NSDictionary * messNewDic = defineDic[@"message"][@"data"];
        NSString * ownId = kGetString(messNewDic[@"own_id"]);
        NSString * aimId = kGetString(messNewDic[@"aim_id"]);

        if ([WP_TOOL_ShareManager getOwnListDbMessage:messNewDic[@"own_id"] aim_id:messNewDic[@"aim_id"]]) {
            for (NSInteger i = 0; i<self.dbMessageArray.count; i++) {
                for (MessageFrameModel * dictModel in self.dbMessageArray[i]) {
                      if ([dictModel.message.aim_id isEqualToString:ownId] && [dictModel.message.own_id isEqualToString:aimId]) {
                            [self.yiduArray  replaceObjectAtIndex:i withObject:@"1"];
                            break;
                        }
                        if ([dictModel.message.aim_id isEqualToString:aimId] && [dictModel.message.own_id isEqualToString:ownId]) {
                            [self.yiduArray  replaceObjectAtIndex:i withObject:@"1"];
                            break;
                        }
                }
            }
        }
    }
    
    for (NSDictionary * defineDic in YX_MANAGER.socketMessageArray) {
        
        NSDictionary * messNewDic = defineDic[@"message"][@"data"];
             if ([WP_TOOL_ShareManager getOwnListDbMessage:messNewDic[@"own_id"] aim_id:messNewDic[@"aim_id"]]) {
                 [WP_TOOL_ShareManager receiveAllKindsMessage:messNewDic
                                                 message:self.messages
                                             userInfoDic:self.userInfoDic
                                                    type:1
            ];
        }
    }
    [self makeSamePersonInfo:self.messages];
    
    
}
-(void)makeSamePersonInfo:(NSArray *)ownArray{
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    //先得到自己的id
    NSString * ownId = kGetString(userInfo[@"id"]);
    //自己数据拿出来后，开始取出不同的好友分组
    NSMutableArray * ownFriendIdArray = [[NSMutableArray alloc]init];
    for (MessageFrameModel * dictModel in ownArray) {
        //如果aimid是自己，就取ownid
        if ([dictModel.message.aim_id isEqualToString:ownId]) {
            [ownFriendIdArray addObject:dictModel.message.own_id];
        }
        //如果ownid是自己，就取aimid
        if ([dictModel.message.own_id isEqualToString:ownId]) {
            [ownFriendIdArray addObject:dictModel.message.aim_id];
        }
    }
    //然后给好友分组的数组去重
    NSSet *set = [NSSet setWithArray:ownFriendIdArray];
    //得到有多少好友id的数组，就是这个界面显示几行
    NSMutableArray * rowIdArry = [NSMutableArray arrayWithArray:[set allObjects]];


    [self.dbMessageArray removeAllObjects];
    //然后根据id来分组
    for (NSString * rowId in rowIdArry) {
        NSMutableArray * resultArray = [[NSMutableArray alloc]init];
        for (MessageFrameModel * dictModel in ownArray) {
                if ([dictModel.message.aim_id isEqualToString:ownId] && [dictModel.message.own_id isEqualToString:rowId]) {
                     [resultArray addObject:dictModel];
                }
                if ([dictModel.message.aim_id isEqualToString:rowId] && [dictModel.message.own_id isEqualToString:ownId]) {
                    [resultArray addObject:dictModel];
                }
         }
        [self.dbMessageArray addObject:resultArray];
    }

    [self.tableView reloadData];

}
- (IBAction)yiduAction:(id)sender {
    self.zanjb.hidden = YES;
    self.fensijb.hidden = YES;
    self.hdjb.hidden = YES;
    [[AppDelegate shareAppDelegate].mainTabBar.axcTabBar setBadge:NSIntegerToNSString(0) index:2];
    
    [self.yiduArray removeAllObjects];
     for (NSInteger i = 0; i< 100; i++) {
        [self.yiduArray addObject:@"0"];
    }
    [self.tableView reloadData];
}
-(UIImageView *)noMessageImV{
    if (!_noMessageImV) {
        
    }
    return _noMessageImV;
}
-(NSMutableArray *)messages{
//    if (_messages == nil) {
        JQFMDB *db = [JQFMDB shareDatabase];
        NSArray *dictArray = [db jq_lookupTable:YX_USER_LiaoTian dicOrModel:[MessageModel class] whereFormat:nil];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];
        MessageModel *previousModel = nil;
        if (dictArray.count == 0) {
            [_messages removeAllObjects];
        }
        for (MessageModel * message in dictArray) {
            if ([WP_TOOL_ShareManager getOwnListDbMessage:message.own_id aim_id:message.aim_id]) {
                    //只拿自己的
                    MessageFrameModel *frameM = [[MessageFrameModel alloc] init];
                    //判断是否显示时间
                    message.hiddenTime =  abs([message.time intValue] - [previousModel.time intValue] < 60);
                    frameM.message = message;
                    frameM.isRead = YES;
                    [models addObject:frameM];
                    previousModel = message;
                }
                _messages = [models mutableCopy];
            }
//        }
      return _messages;
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


-(void)tuisongxiaoxi:(NSNotification *)notice{
    [self.tableView reloadData];
}
-(void)setUI{
    self.dbMessageArray = [[NSMutableArray alloc]init];
    self.dbArray = [[NSMutableArray alloc]init];
    self.bendiArray = [[NSMutableArray alloc]init];
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
    ViewBorderRadius(self.tuisongBtn, 2, 1, SEGMENT_COLOR);
    ViewBorderRadius(self.yiduBtn, 13, 1, kRGBA(238, 238, 238, 1));
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YXMessageLiaoTianTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMessageLiaoTianTableViewCell"];

    [self addRefreshView:self.tableView];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4) {
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
    }else if(indexPath.section == 3){
        return self.dbMessageArray.count == 0 ? 370 : 0;
    }
    
    else  if (indexPath.section == 4) {
        return 80;
    }
    else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(4 == indexPath.section){//爱好 （动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:3]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        YXMessageLiaoTianTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMessageLiaoTianTableViewCell" forIndexPath:indexPath];
        MessageFrameModel * model = [self.dbMessageArray[indexPath.row] lastObject];
        cell.ltContent.text = model.message.text;
        NSDictionary * userInfo = userManager.loadUserAllInfo;
        NSString * photo = @"";
        NSString * username = @"";
        if ([kGetString(userInfo[@"id"]) isEqualToString:model.message.own_id]) {
            photo = [ShareManager stringToDic:model.message.aim_info][@"photo"];
            username = [ShareManager stringToDic:model.message.aim_info][@"username"];
        }else{
            photo = [ShareManager stringToDic:model.message.own_info][@"photo"];
            username = [ShareManager stringToDic:model.message.own_info][@"username"];
        }
        cell.ltTitle.text = username;
        [cell.ltImv sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:photo]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
        cell.ltTime.text = [ShareManager ChatingTime:model.message.time];
        //新消息提示
        
        cell.messageLbl.hidden = [self.yiduArray[indexPath.row] integerValue] == 0;
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        kWeakSelf(self);
          MessageFrameModel * model = [self.dbMessageArray[indexPath.row] lastObject];
          SimpleChatMainViewController * vc = [[SimpleChatMainViewController alloc]init];
          vc.clickIndex = indexPath.row;
          NSDictionary * userInfo = userManager.loadUserAllInfo;
          NSString * photo = @"";
          NSString * username = @"";
          NSString * otherId = @"";

              if ([kGetString(userInfo[@"id"]) isEqualToString:model.message.own_id]) {
                  photo = [ShareManager stringToDic:model.message.aim_info][@"photo"];
                  username = [ShareManager stringToDic:model.message.aim_info][@"username"];
                  otherId = model.message.aim_id;
              }else{
                  photo = [ShareManager stringToDic:model.message.own_info][@"photo"];
                  username = [ShareManager stringToDic:model.message.own_info][@"username"];
                  otherId = model.message.own_id;
              }
          vc.userInfoDic = @{@"photo":photo,@"username":username,@"id":otherId};
         
         
         vc.backVCClickIndexblock = ^(NSInteger clickIndex) {
        
             [weakself.yiduArray replaceObjectAtIndex:clickIndex withObject:@"0"];
             [weakself.tableView reloadData];
         };
         
          [weakself.navigationController pushViewController:vc animated:YES];
    }
  
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.section == 4) {
//            UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"聊天置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//                // 收回侧滑
//                [tableView setEditing:NO animated:YES];
//            }];


            UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

                    
                     MessageFrameModel * model = [self.dbMessageArray[indexPath.row] lastObject];
                     MessageModel * mesModel = model.message;
                     JQFMDB *db = [JQFMDB shareDatabase];
                NSString * aim_id = mesModel.aim_id;
                NSString * own_id = mesModel.own_id;
                for (NSArray * array in self.dbMessageArray) {
                    for (MessageFrameModel * model2 in array) {
                        MessageModel * model1 = model2.message;
                        if ([model1.aim_id integerValue] == [aim_id integerValue] && [model1.own_id integerValue] == [own_id integerValue]) {
                            NSString * sql = [@"WHERE aim_id = " append:model1.aim_id];
                            [db jq_deleteTable:YX_USER_LiaoTian whereFormat:sql];
                        }else  if ([model1.aim_id integerValue] == [own_id integerValue] && [model1.own_id integerValue] == [aim_id integerValue]) {
                           NSString * sql = [@"WHERE aim_id = " append:model1.aim_id];
                           [db jq_deleteTable:YX_USER_LiaoTian whereFormat:sql];
                        }
                    }
                }
                
                
                // 删除cell: 必须要先删除数据源，才能删除cell
                [self.dbMessageArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                     
        }];

        return @[deleteAction];
    }else{
        return @[];
    }

}
-(void)tapAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    YXMessageThreeDetailViewController * VC = [[YXMessageThreeDetailViewController alloc]init];
    switch (tag) {
        case 1001:
            VC.title = @"收到的赞";
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

//
//
//
//
//- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
//    //收到服务端发送过来的消息
//    NSString * message = note.object;
//    NSDictionary * messageDic = [ShareManager stringToDic:message];
//    NSDictionary * messNewDic = messageDic[@"message"][@"data"];
//    if (messNewDic) {
//        NSString * content = [messNewDic[@"content"] UnicodeToUtf81];
//        NSString * date = messNewDic[@"date"];
//
//        NSString * own_id= kGetString(messNewDic[@"own_id"]);
//        NSString * aim_id= kGetString(messNewDic[@"aim_id"]);
//        NSString * myid= kGetString(messNewDic[@"id"]);
//
//
//         NSString * photo = @"";
//         NSString * username = @"";
//         NSString * otherId = @"";
//         UserInfo * userInfo = curUser;
//
//         if ([userInfo.id isEqualToString:own_id]) {
//             photo =    messNewDic[@"aim_info"][@"photo"];
//             username = messNewDic[@"aim_info"][@"username"];
//             otherId =  aim_id;
//         }else{
//             photo =    messNewDic[@"own_info"][@"photo"];
//             username = messNewDic[@"own_info"][@"username"];
//             otherId =  own_id;
//         }
//
//
//        self.userInfoDic = @{@"id":otherId,@"photo":photo,@"username":username};
//        NSInteger refreshCellIndex = 0;
//        for (NSInteger i = 0; i < self.dbMessageArray.count ;i++) {
//
//            MessageModel * model = self.dbMessageArray[i][0];
//            if ([model.own_id isEqualToString:otherId] || [model.aim_id isEqualToString:otherId]) {
//                refreshCellIndex = i;
//                break;
//            }
//        }
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:refreshCellIndex inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
//        //这里开始看是哪个cell，显示小红点
//
//        [self addMessage:@{@"content":content,@"date":date,@"own_id":own_id,@"aim_id":aim_id,@"xxzid":myid,@"own_info":messNewDic[@"own_info"],@"aim_info":messNewDic[@"aim_info"]}  type:MessageModelTypeOther];
//    }
//}
//-(void)insertCommonAction:(NSDictionary *) messNewDic{
//    JQFMDB *db = [JQFMDB shareDatabase];
//    MessageModel *compareM = (MessageModel *)[[_messages lastObject] message];
//    MessageModel * noHaveModel = [[MessageModel alloc]init];
//     noHaveModel.type = 1;//这个数组里面的元素，都是别人给我发的，都是1
//     noHaveModel.text = messNewDic[@"content"];
//     noHaveModel.time = messNewDic[@"date"];
//     noHaveModel.photo = self.userInfoDic[@"photo"];
//     noHaveModel.aim_id = messNewDic[@"aim_id"];
//     noHaveModel.own_id = messNewDic[@"own_id"];
//     noHaveModel.xxzid = messNewDic[@"id"];
//    if (messNewDic[@"aim_info"]) {
//        noHaveModel.aim_info = [[ShareManager dicToString:messNewDic[@"aim_info"]]  replaceAll:@"\n" target:@""];;
//    }
//    if (messNewDic[@"own_info"]) {
//        noHaveModel.own_info = [[ShareManager dicToString:messNewDic[@"own_info"]]  replaceAll:@"\n" target:@""];;
//    }
//     noHaveModel.hiddenTime = [messNewDic[@"date"] isEqualToString:compareM.time];
//      [db jq_inDatabase:^{
//          [db jq_insertTable:YX_USER_LiaoTian dicOrModel:noHaveModel];
//      }];
//}
//-(NSMutableArray *)messages{
//    if (_messages == nil) {
//        JQFMDB *db = [JQFMDB shareDatabase];
//        NSArray *dictArray = [db jq_lookupTable:YX_USER_LiaoTian dicOrModel:[MessageModel class] whereFormat:nil];
//        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];
//
//        //数据库消息的id
//        [self.dbArray removeAllObjects];
//        for (MessageModel * dictModel in dictArray) {
//            [self.dbArray addObject:dictModel.xxzid];
//        }
//        //本地消息的id
//        [self.bendiArray removeAllObjects];
//        for (NSDictionary * defineDic in YX_MANAGER.socketMessageArray) {
//           NSDictionary * messNewDic = defineDic[@"message"][@"data"];
//           [self.bendiArray addObject:kGetString(messNewDic[@"id"])];
//        }
//        NSArray *data1Array = [self.bendiArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.dbArray]];
//
//        //如果数据库里面没有这条数据，那就先把这数据插入里面
//        if (dictArray.count == 0) {
//            for (NSDictionary * defineDic in YX_MANAGER.socketMessageArray) {
//                [self insertCommonAction:defineDic[@"message"][@"data"]];
//            }
//        }else{
//            //找出不同元素后，把不同的元素的id找出来加进去
//            for (NSDictionary * defineDic in YX_MANAGER.socketMessageArray) {
//                NSDictionary * messNewDic = defineDic[@"message"][@"data"];
//                for (NSString * xxzid in data1Array) {
//                    if ([xxzid isEqualToString:kGetString(messNewDic[@"id"])]) {
//                        [self insertCommonAction:messNewDic];
//                    }
//                }
//            }
//        }
//        //然后再请求最新的消息看有没有
//        NSMutableArray * resultArray = [[NSMutableArray alloc]init];
//        for (NSArray * dataArray in  self.requestObject[@"data"]) {
//            for (NSDictionary * dataDic in dataArray) {
//                if ([kGetString(dataDic[@"own_id"]) isEqualToString:kGetString(self.userInfoDic[@"id"])]) {
//                    [resultArray addObjectsFromArray:dataArray];
//                    break;
//                }
//            }
//        }
//        for (NSDictionary * dic in resultArray) {
//            [self insertCommonAction:dic];
//        }
//
//        //把没有插入过数据库的数据，插入进去后再开始显示
//           NSArray * dictNewArray = [db jq_lookupTable:YX_USER_LiaoTian dicOrModel:[MessageModel class] whereFormat:nil];
//           for (MessageModel * dictModel in dictNewArray) {
//               UserInfo * userInfo = curUser;
//               MessageModel *previousModel = nil;
//               //先取出自己的记录
//               BOOL messageBool1 = [userInfo.id isEqualToString:dictModel.own_id] || [userInfo.id isEqualToString:dictModel.aim_id];
//               BOOL messageBool2 = [kGetString(self.userInfoDic[@"id"]) isEqualToString:dictModel.own_id] || [kGetString(self.userInfoDic[@"id"]) isEqualToString:dictModel.aim_id];
//                 if (messageBool1 && messageBool2) {
//                       MessageFrameModel *frameM = [[MessageFrameModel alloc] init];
//                       //判断是否显示时间
//                       dictModel.hiddenTime =  [dictModel.time isEqualToString:previousModel.time];
//                       frameM.message = dictModel;
//                       [models addObject:frameM];
//                       previousModel = dictModel;
//                   }
//
//               self.messages = [models mutableCopy];
//
//           }
//
//
//
//
//    }
//    return _messages;
//}
//-(void) addMessage:(NSDictionary *)dic type:(MessageModelType) type
//{
//    MessageModel *compareM = (MessageModel *)[[self.messages lastObject] message];
//    //修改模型并且将模型保存数组
//    MessageModel * message = [[MessageModel alloc] init];
//    message.type = type;
//    message.text = dic[@"content"];
//    message.time = dic[@"date"];
//    message.photo = self.userInfoDic[@"photo"];
//    message.aim_id = dic[@"aim_id"];
//    message.own_id = dic[@"own_id"];
//    message.xxzid = dic[@"xxzid"];
//    UserInfo * userInfo = curUser;
//
//    if (type ==1) {
//        message.aim_info = [[ShareManager dicToString:dic[@"aim_info"]] replaceAll:@"\n" target:@""];
//        message.own_info = [[ShareManager dicToString:dic[@"own_info"]] replaceAll:@"\n" target:@""];
//    }else{
//        NSDictionary * aim_info = @{@"photo":self.userInfoDic[@"photo"],@"username":self.userInfoDic[@"username"]};
//        message.aim_info = [[ShareManager dicToString:aim_info] replaceAll:@"\n" target:@""];
//
//        NSDictionary * own_info = @{@"photo":userInfo.photo,@"username":userInfo.username};
//        message.own_info = [[ShareManager dicToString:own_info] replaceAll:@"\n" target:@""];
//    }
//    message.hiddenTime = [message.time isEqualToString:compareM.time];
//
//      MessageFrameModel *mf = [[MessageFrameModel alloc] init];
//      mf.message = message;
//      //只插入messagemodel
//      JQFMDB *db = [JQFMDB shareDatabase];
//      [db jq_inDatabase:^{
//
//      //判断数据库是否有这条数据
////           BOOL isHave = NO;
////           for (NSDictionary * defineDic in YX_MANAGER.socketMessageArray) {
////                 NSString * xxzid = kGetString(defineDic[@"message"][@"data"][@"id"]);
////                 if ([xxzid isEqualToString:message.xxzid]) {
////                     isHave = YES;
////                     break;
////                 }
////           }
////           if (!isHave) {
//               [db jq_insertTable:YX_USER_LiaoTian dicOrModel:message];
////           }
//      }];
//     [self.messages addObject:mf];
//     [self refreshVC];
//}
@end
