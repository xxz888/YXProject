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
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天";
    if (kScreenHeight > 810) {
        self.iPhoneX = 10;
    }
    else
    {
        self.iPhoneX = 0;
    }
    [self createTableView];
    self.mDic = [[NSMutableDictionary alloc]init];
     self.dbArray = [[NSMutableArray alloc]init];
    //本地数组储存的id
    self.bendiArray = [[NSMutableArray alloc]init];
    //接受socket通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketDidCloseNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];

   JQFMDB *db = [JQFMDB shareDatabase];
   if (![db jq_isExistTable:YX_USER_LiaoTian]) {
       [db jq_createTable:YX_USER_LiaoTian dicOrModel:[MessageModel class]];
   }
    
    [self jumpBottomLiaoTian];
}
- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    //在成功后需要做的操作。。。
    
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSString * message = note.object;
    NSDictionary * messageDic = [ShareManager stringToDic:message];
    NSDictionary * messNewDic = messageDic[@"message"][@"data"];
    if (messNewDic) {
        NSString * content = [messNewDic[@"content"] UnicodeToUtf81];
        NSString * date = messNewDic[@"date"];
    
        NSString * own_id= kGetString(messNewDic[@"own_id"]);
        NSString * aim_id= kGetString(messNewDic[@"aim_id"]);
        NSString * myid= kGetString(messNewDic[@"id"]);

        [self addMessage:@{@"content":content,@"date":date,@"own_id":own_id,@"aim_id":aim_id,@"xxzid":myid,@"own_info":messNewDic[@"own_info"],@"aim_info":messNewDic[@"aim_info"]}  type:MessageModelTypeOther];
    }
}
-(void)insertCommonAction:(NSDictionary *) messNewDic{
    JQFMDB *db = [JQFMDB shareDatabase];
    MessageModel *compareM = (MessageModel *)[[_messages lastObject] message];
    MessageModel * noHaveModel = [[MessageModel alloc]init];
     noHaveModel.type = 1;//这个数组里面的元素，都是别人给我发的，都是1
     noHaveModel.text = messNewDic[@"content"];
     noHaveModel.time = messNewDic[@"date"];
     noHaveModel.photo = self.userInfoDic[@"photo"];
     noHaveModel.aim_id = messNewDic[@"aim_id"];
     noHaveModel.own_id = messNewDic[@"own_id"];
     noHaveModel.xxzid = messNewDic[@"id"];
    if (messNewDic[@"aim_info"]) {
        noHaveModel.aim_info = [[ShareManager dicToString:messNewDic[@"aim_info"]]  replaceAll:@"\n" target:@""];;
    }
    if (messNewDic[@"own_info"]) {
        noHaveModel.own_info = [[ShareManager dicToString:messNewDic[@"own_info"]]  replaceAll:@"\n" target:@""];;
    }
     noHaveModel.hiddenTime = [messNewDic[@"date"] isEqualToString:compareM.time];
      [db jq_inDatabase:^{
          [db jq_insertTable:YX_USER_LiaoTian dicOrModel:noHaveModel];
      }];
}
-(NSMutableArray *)messages{
    if (_messages == nil) {
        JQFMDB *db = [JQFMDB shareDatabase];
        NSArray *dictArray = [db jq_lookupTable:YX_USER_LiaoTian dicOrModel:[MessageModel class] whereFormat:nil];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];
        
        //数据库消息的id
        [self.dbArray removeAllObjects];
        for (MessageModel * dictModel in dictArray) {
            [self.dbArray addObject:dictModel.xxzid];
        }
        //本地消息的id
        [self.bendiArray removeAllObjects];
        for (NSDictionary * defineDic in YX_MANAGER.socketMessageArray) {
           NSDictionary * messNewDic = defineDic[@"message"][@"data"];
           [self.bendiArray addObject:kGetString(messNewDic[@"id"])];
        }
        NSArray *data1Array = [self.bendiArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.dbArray]];
        
        //如果数据库里面没有这条数据，那就先把这数据插入里面
        if (dictArray.count == 0) {
            for (NSDictionary * defineDic in YX_MANAGER.socketMessageArray) {
                [self insertCommonAction:defineDic[@"message"][@"data"]];
            }
        }else{
            //找出不同元素后，把不同的元素的id找出来加进去
            for (NSDictionary * defineDic in YX_MANAGER.socketMessageArray) {
                NSDictionary * messNewDic = defineDic[@"message"][@"data"];
                for (NSString * xxzid in data1Array) {
                    if ([xxzid isEqualToString:kGetString(messNewDic[@"id"])]) {
                        [self insertCommonAction:messNewDic];
                    }
                }
            }
        }
        //然后再请求最新的消息看有没有
        NSMutableArray * resultArray = [[NSMutableArray alloc]init];
        for (NSArray * dataArray in  self.requestObject[@"data"]) {
            for (NSDictionary * dataDic in dataArray) {
                if ([kGetString(dataDic[@"own_id"]) isEqualToString:kGetString(self.userInfoDic[@"id"])]) {
                    [resultArray addObjectsFromArray:dataArray];
                    break;
                }
            }
        }
        for (NSDictionary * dic in resultArray) {
            [self insertCommonAction:dic];
        }
            
        //把没有插入过数据库的数据，插入进去后再开始显示
           NSArray * dictNewArray = [db jq_lookupTable:YX_USER_LiaoTian dicOrModel:[MessageModel class] whereFormat:nil];
           for (MessageModel * dictModel in dictNewArray) {
               UserInfo * userInfo = curUser;
               MessageModel *previousModel = nil;
               //先取出自己的记录
               BOOL messageBool1 = [userInfo.id isEqualToString:dictModel.own_id] || [userInfo.id isEqualToString:dictModel.aim_id];
               BOOL messageBool2 = [kGetString(self.userInfoDic[@"id"]) isEqualToString:dictModel.own_id] || [kGetString(self.userInfoDic[@"id"]) isEqualToString:dictModel.aim_id];
                 if (messageBool1 && messageBool2) {
                       MessageFrameModel *frameM = [[MessageFrameModel alloc] init];
                       //判断是否显示时间
                       dictModel.hiddenTime =  [dictModel.time isEqualToString:previousModel.time];
                       frameM.message = dictModel;
                       [models addObject:frameM];
                       previousModel = dictModel;
                   }
               
               self.messages = [models mutableCopy];
          
           }
  

   

    }
    return _messages;
}
-(void)jisuanCommonAction:(MessageModel *)dictModel  models:(NSMutableArray *)models{


}
- (IBAction)backVc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) createTableView
{
    
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
//    self.inputTextField.layer.borderWidth = 0.5f;
    self.inputTextField.layer.cornerRadius = 8;
    self.inputTextField.returnKeyType = UIReturnKeySend;
//    self.inputTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputTextField.backgroundColor = KWhiteColor;
    self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.backView addSubview:self.inputTextField];
    
    //注册键盘显示通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //监听键盘sent点击
    self.inputTextField.delegate = self;
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
    UserInfo * userInfo = curUser;
    NSString * aim_id = self.userInfoDic[@"id"];
    [self addMessage:@{@"content":content,@"date":strDate,@"own_id":userInfo.id,@"aim_id":aim_id,@"xxzid":@"00000"}  type:MessageModelTypeMe];

    [self jumpBottomLiaoTian];
    self.inputTextField.text = @"";
    
 
    
    return YES;
}
-(void) addMessage:(NSDictionary *)dic type:(MessageModelType) type
{
    MessageModel *compareM = (MessageModel *)[[self.messages lastObject] message];
    //修改模型并且将模型保存数组
    MessageModel * message = [[MessageModel alloc] init];
    message.type = type;
    message.text = dic[@"content"];
    message.time = dic[@"date"];
    message.photo = self.userInfoDic[@"photo"];
    message.aim_id = dic[@"aim_id"];
    message.own_id = dic[@"own_id"];
    message.xxzid = dic[@"xxzid"];
    UserInfo * userInfo = curUser;

    if (type ==1) {
        message.aim_info = [[ShareManager dicToString:dic[@"aim_info"]] replaceAll:@"\n" target:@""];
        message.own_info = [[ShareManager dicToString:dic[@"own_info"]] replaceAll:@"\n" target:@""];
    }else{
        NSDictionary * aim_info = @{@"photo":self.userInfoDic[@"photo"],@"username":self.userInfoDic[@"username"]};
        message.aim_info = [[ShareManager dicToString:aim_info] replaceAll:@"\n" target:@""];
        
        NSDictionary * own_info = @{@"photo":userInfo.photo,@"username":userInfo.username};
        message.own_info = [[ShareManager dicToString:own_info] replaceAll:@"\n" target:@""];
    }
    message.hiddenTime = [message.time isEqualToString:compareM.time];
    
      MessageFrameModel *mf = [[MessageFrameModel alloc] init];
      mf.message = message;
      //只插入messagemodel
      JQFMDB *db = [JQFMDB shareDatabase];
      [db jq_inDatabase:^{
          
      //判断数据库是否有这条数据
           BOOL isHave = NO;
           for (NSDictionary * defineDic in YX_MANAGER.socketMessageArray) {
                 NSString * xxzid = kGetString(defineDic[@"message"][@"data"][@"id"]);
                 if ([xxzid isEqualToString:message.xxzid]) {
                     isHave = YES;
                     break;
                 }
           }
           if (!isHave) {
               [db jq_insertTable:YX_USER_LiaoTian dicOrModel:message];
           }
      }];
     [self.messages addObject:mf];

//    //如果是自己，就不用判断别的，直接添加
//    if (type == 0) {
//        [self insertCommonAction:message];
//    }else{
//    //判断数据库是否有这条数据
//         BOOL isHave = NO;
//         for (NSDictionary * defineDic in YX_MANAGER.socketMessageArray) {
//               NSString * xxzid = kGetString(defineDic[@"message"][@"data"][@"id"]);
//               if ([xxzid isEqualToString:message.xxzid]) {
//                   isHave = YES;
//                   break;
//               }
//         }
//         if (!isHave) {
//             [self insertCommonAction:message];
//         }
//    }
//
 


    
    [self jumpBottomLiaoTian];
    
}
-(void)jumpBottomLiaoTian{
    //刷新表格
    [self.mainTableView reloadData];
    if (self.messages.count > 0) {
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.mainTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}
-(void)keyBoardWillChange:(NSNotification *) notification
{
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
    } completion:^(BOOL finished) {
        
    }];
    
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
