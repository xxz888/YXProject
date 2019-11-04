//
//  SimpleChatMainViewController.m
//  SimpleChatPage
//
//  Created by 李海群 on 2018/6/15.
//  Copyright © 2018年 Gorilla. All rights reserved.
//

#import "SimpleChatMainViewController.h"
#import "MessageModel.h"
#import "MessageFrameModel.h"
#import "MessageCell.h"
#import "JQFMDB.h"


@interface SimpleChatMainViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property (nonatomic, assign) int iPhoneX;

@property (nonatomic, strong) UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) NSMutableDictionary * mDic;

/**
 消息数组
 */
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *dbArray;
@property (nonatomic, strong) NSMutableArray *bendiArray;

/**
 自动回复数组
 */
@property (nonatomic, strong) NSDictionary *autoResentDic;

@end

@implementation SimpleChatMainViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(KAppShow:) name:KAPP_SHOW object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self requestWeiDuMessage];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[IQKeyboardManager sharedManager] setEnable:YES];

}
-(void)KAppShow:(NSNotification*)notice{
    [self requestWeiDuMessage];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.titleLbl.text = self.userInfoDic[@"username"];
    if (kScreenHeight > 810) {self.iPhoneX = 10; }else{self.iPhoneX = 0;}
    [self createTableView];
    self.mDic = [[NSMutableDictionary alloc]init];
    self.dbArray = [[NSMutableArray alloc]init];
    //本地数组储存的id
    self.bendiArray = [[NSMutableArray alloc]init];
 
    
  
    
    [self jumpBottomLiaoTian];
}
//未读信息的处理
-(void)requestWeiDuMessage{
    kWeakSelf(self);
    [YXPLUS_MANAGER requestChatting_ListoryGet:@"" success:^(id object) {
        for (NSArray * dataArray in  object[@"data"]) {
            for (NSDictionary * messNewDic in dataArray) {
                if ([kGetString(messNewDic[@"own_id"]) isEqualToString:self.userInfoDic[@"id"]] ||
                    [kGetString(messNewDic[@"aim_id"]) isEqualToString:self.userInfoDic[@"id"]]) {
                    [WP_TOOL_ShareManager receiveAllKindsMessage:messNewDic message:self.messages userInfoDic:self.userInfoDic type:1];
                    [weakself jumpBottomLiaoTian];
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
        if ([messNewDic[@"own_id"] integerValue]  == [self.userInfoDic[@"id"] integerValue] ||
            [messNewDic[@"aim_id"] integerValue]  == [self.userInfoDic[@"id"] integerValue]) {
            [WP_TOOL_ShareManager receiveAllKindsMessage:messNewDic
                                                 message:self.messages
                                             userInfoDic:self.userInfoDic
                                                    type:1
            ];
            [self jumpBottomLiaoTian];
        }
    }
}


-(NSMutableArray *)messages{
    if (_messages == nil) {
        JQFMDB *db = [JQFMDB shareDatabase];
        NSArray *dictArray = [db jq_lookupTable:YX_USER_LiaoTian dicOrModel:[MessageModel class] whereFormat:nil];
                
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];
        MessageModel *previousModel = nil;
        for (MessageModel * message in dictArray) {
            if ([WP_TOOL_ShareManager getOwnDbMessage:message.own_id aim_id:message.aim_id other:self.userInfoDic]) {
                    //只拿自己的
                    MessageFrameModel *frameM = [[MessageFrameModel alloc] init];
                    //判断是否显示时间
                    message.hiddenTime =  [message.time isEqualToString:previousModel.time];
                    frameM.message = message;
                    [models addObject:frameM];
                    previousModel = message;
                }
                self.messages = [models mutableCopy];
            }

        }
      return _messages;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSDictionary * dic = @{@"aim_id":kGetString(self.userInfoDic[@"id"]),@"type":@"1",@"content":textField.text};
     [YXPLUS_MANAGER requestChatting_ListoryPOST:dic success:^(id object) {
         
     }];
    //当前用户发送时间
    NSDate * date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSString *strDate = [formatter stringFromDate:date];
    NSString * content = textField.text;
    NSDictionary * userInfo = userManager.loadUserAllInfo;

    NSString * own_info= [ShareManager dicToString:@{@"photo":userInfo[@"photo"],@"username":userInfo[@"username"]}];
    NSString * aim_info= [ShareManager dicToString:@{@"photo":self.userInfoDic[@"photo"],@"username":self.userInfoDic[@"username"]}];

        NSDictionary * messNewDic = @{
                                          @"content":content,
                                          @"date":strDate,
                                          @"own_id":kGetString(userInfo[@"id"]),
                                          @"aim_id":self.userInfoDic[@"id"],
                                          @"own_info":own_info,
                                          @"aim_info":aim_info
                                    };
    
    [WP_TOOL_ShareManager receiveAllKindsMessage:messNewDic
                                               message:self.messages
                                           userInfoDic:self.userInfoDic
                                            type:0
            
     ];


    [self jumpBottomLiaoTian];
    self.inputTextField.text = @"";
    return YES;
}

-(void)jumpBottomLiaoTian{
    //刷新表格
    [self.mainTableView reloadData];
    if (self.messages.count > 0) {
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.mainTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}


















- (void) createTableView{
    self.mainTableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    self.mainTableView.dataSource=self;
    self.mainTableView.delegate=self;
    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.estimatedSectionHeaderHeight = 0;
    self.mainTableView.estimatedSectionFooterHeight = 0;
    self.mainTableView.separatorStyle=NO;
    self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth - 10, 35)];
    //给文本输入框添加左边视图
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.inputTextField.leftView = left;
    self.inputTextField.layer.cornerRadius = 8;
    self.inputTextField.returnKeyType = UIReturnKeySend;
    self.inputTextField.backgroundColor = KWhiteColor;
    self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.backView addSubview:self.inputTextField];
    //注册键盘显示通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //监听键盘sent点击
    self.inputTextField.delegate = self;
}
-(void)keyBoardWillChange:(NSNotification *) notification{
        //计算需要移动的距离
         NSDictionary *dict = notification.userInfo ;
         CGRect keyBoardFrame =  [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
         CGFloat keyboardY = keyBoardFrame.origin.y;
         CGFloat translationY = keyboardY - self.view.frame.size.height;
         //动画执行时间
         CGFloat time = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
         //键盘弹出的节奏和view动画节奏一致:7 << 16
         [UIView animateKeyframesWithDuration:time delay:0.0 options:7 << 16 animations:^{
             self.view.transform = CGAffineTransformMakeTranslation(0, translationY);
         } completion:^(BOOL finished) {}];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.userInfoDic) {
        cell.otherDic = [NSDictionary dictionaryWithDictionary:self.userInfoDic];
    }
    cell.messageFrame = self.messages[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageFrameModel *fm = [self.messages objectAtIndex:indexPath.row];
    return fm.cellHeight;
}
- (IBAction)backVc:(id)sender {
    if (self.backVCClickIndexblock) {
        self.backVCClickIndexblock(self.clickIndex);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
