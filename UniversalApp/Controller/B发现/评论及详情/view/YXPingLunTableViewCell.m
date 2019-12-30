//
//  YXPingLunTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/28.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXPingLunTableViewCell.h"
#import "YXPingLunCellTableViewCell.h"
#import "YXPingLunHeader.h"
@interface YXPingLunTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSDictionary * cellDataDic;
@end
@implementation YXPingLunTableViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return  self;
}
-(void)setup{
    self.cellDataDic = [[NSDictionary alloc]init];

}
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic{
    CGFloat plDetailHeight =   [YXPingLunTableViewCell getPlDetailHeight:dic];
    CGFloat plplToTopHeight =  [YXPingLunTableViewCell getPlplToTopHeight:dic];
    CGFloat plplViewHeight =   [YXPingLunTableViewCell getPlplViewHeight:dic];
    return 16 + 40 + 10 + plDetailHeight + plplToTopHeight + plplViewHeight + 16 + 0.5;
}
+(CGFloat)getPlDetailHeight:(NSDictionary *)dic{
    CGFloat height =
    [ShareManager inAllContentOutHeight:dic[@"comment"] contentWidth:KScreenWidth-87 lineSpace:9 font:SYSTEMFONT(14)];
    return height;
}
+(CGFloat)getPlplToTopHeight:(NSDictionary *)dic{
    return [dic[@"child_list"] count] == 0 ? 0 : 16;
}
+(CGFloat)getPlplViewHeight:(NSDictionary *)dic{
    NSMutableArray * threeDataArray = [NSMutableArray arrayWithArray:dic[@"child_list"]];
    if (threeDataArray.count == 0) {
        return 0;
    }
    CGFloat totalTablViewHeight = 0;
    for (NSDictionary * childDic in threeDataArray) {
        totalTablViewHeight += [YXPingLunCellTableViewCell getPlDetailHeight:childDic];
    }
    return totalTablViewHeight + ([threeDataArray count] * 8) +
    [YXPingLunTableViewCell getPlplToTopHeight:dic] +
    [YXPingLunTableViewCell getFootViewHeight:dic];
}
+(CGFloat)getFootViewHeight:(NSDictionary *)dic{
    CGFloat height =  [dic[@"child_number"] integerValue] - [dic[@"child_list"] count] <= 0 ? 0 : 25;
    return height;
}
-(void)setCellData:(NSDictionary *)dic{
     [self.plTitleImv sd_setImageWithURL:[NSURL URLWithString:[WP_TOOL_ShareManager addImgURL:dic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.plUserName.text = dic[@"user_name"];
    self.plTime.text = [ShareManager updateTimeForRow:[dic[@"update_time"] longLongValue]];
    //F蓝色已点赞 F灰色未点赞
    [self.plZan setImage:[dic[@"is_praise"] integerValue] == 0 ? IMAGE_NAMED(@"F灰色未点赞") : IMAGE_NAMED(@"F蓝色已点赞") forState:0];
    //评论的内容
    self.plDetail.text = dic[@"comment"];
    self.plDetailHeight.constant = [YXPingLunTableViewCell getPlDetailHeight:dic];
    //评论的tableview
    self.plplViewToTopHeight.constant = [YXPingLunTableViewCell getPlplToTopHeight:dic];
    [ShareManager setAllContentAttributed:9 inLabel:self.plDetail font:SYSTEMFONT(14)];
    self.plplViewHeight.constant = [YXPingLunTableViewCell getPlplViewHeight:dic];
    
    if ([dic[@"child_list"] count] == 0) {
        
    }else{
        self.cellDataDic = [NSDictionary dictionaryWithDictionary:dic];
        [self.plTableView reloadData];
    }

}
#pragma --------------cell上的tableview--------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cellDataDic[@"child_list"] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [YXPingLunCellTableViewCell cellDefaultHeight:self.cellDataDic[@"child_list"][indexPath.row]];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXPingLunHeader" owner:self options:nil];
    YXPingLunHeader * footView = [nib objectAtIndex:0];
    NSString * allText = [NSString stringWithFormat:@"查看全部%@条回复 >",self.cellDataDic[@"child_number"]];
    [footView.seeAllBtn setTitle:allText forState:0];
    kWeakSelf(self);
    footView.block = ^{
        if ([YXPingLunTableViewCell getFootViewHeight:self.cellDataDic] != 0) {
            weakself.seeAllblock(self.tag);
        }
    };
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [YXPingLunTableViewCell getFootViewHeight:self.cellDataDic];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXPingLunCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXPingLunCellTableViewCell" forIndexPath:indexPath];
    [cell setCellData:self.cellDataDic[@"child_list"][indexPath.row]];
    
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction1:)];
    cell.plLbl.userInteractionEnabled = YES;
    [cell.plLbl addGestureRecognizer:aTapGR];
    
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    longPressGesture.minimumPressDuration=1.0f;//设置长按 时间
    [cell addGestureRecognizer:longPressGesture];
    return cell;
}
-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        CGPoint location = [longRecognizer locationInView:self.plTableView];
        NSIndexPath * indexPath = [self.plTableView indexPathForRowAtPoint:location];
        self.pressLongChildCellBlock(self.cellDataDic[@"child_list"][indexPath.row]);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.plTableView registerNib:[UINib nibWithNibName:@"YXPingLunCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXPingLunCellTableViewCell"];
    self.plTableView.delegate = self;
    self.plTableView.dataSource = self;

//    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
//    self.plDetail.userInteractionEnabled = YES;
//    [self.plDetail addGestureRecognizer:aTapGR];
    
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitleImvAction:)];
    self.plTitleImv.userInteractionEnabled = YES;
    [self.plTitleImv addGestureRecognizer:aTapGR];
}
//-(void)tapGRAction:(id)tap{
//    self.seeAllblock(self.tag);
//}
-(void)tapTitleImvAction:(id)tap{
    self.tagTitleImvCellBlock(kGetString(self.cellDataDic[@"user_id"]));
}

-(void)tapGRAction1:(id)tap{
      if ([YXPingLunTableViewCell getFootViewHeight:self.cellDataDic] != 0) {
              self.seeAllblock(self.tag);
      }
}



- (IBAction)plZanAction:(UIButton *)btn{
    self.zanBlock(self.tag);
}
@end
