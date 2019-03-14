//
//  YXMineAndFindBaseTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineAndFindBaseTableViewCell.h"

@implementation YXMineAndFindBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)childCellCommonActionValue:(NSDictionary *)dic{
    
}
-(void)openAndCloseAction:(NSDictionary *)dic openBtn:(UIButton *)openBtn layout:(NSLayoutConstraint *)layout text:(NSString *)text{
    if ([dic[@"isShowMoreText"] isEqualToString:@"1"]){
        CGSize size = [YXMineAndFindBaseTableViewCell cellAutoHeight:text];
        layout.constant = size.height + 10;
//        [openBtn setTitle:@"收起" forState:UIControlStateNormal];
    }
    else{
//        [openBtn setTitle:@"展开" forState:UIControlStateNormal];
        layout.constant = 30;
    }
}

-(void)cellValueDic:(NSDictionary *)dic searchBtn:(UIButton *)searchBtn pl1NameLbl:(UILabel *)pl1NameLbl pl2NameLbl:(UILabel *)pl2NameLbl pl1ContentLbl:(UILabel *)pl1ContentLbl pl2ContentLbl:(UILabel *)pl2ContentLbl titleImageView:(UIImageView *)titleImageView addPlImageView:(UIImageView *)addPlImageView talkCount:(UILabel *)talkCount titleLbl:(UILabel *)titleLbl timeLbl:(UILabel *)timeLbl mapBtn:(UIButton *)mapBtn likeBtn:(UIButton *)likeBtn zanCount:(UILabel *)zanCount plLbl:(nonnull UILabel *)plLbl{
    

    
    NSString * talkNum = dic[@"comment_number"] ? kGetString(dic[@"comment_number"]) :kGetString(dic[@"answer_number"]);
    NSString * praisNum = kGetString(dic[@"praise_number"]);
    //查看多少评论按钮
//    NSString * allString = [NSString stringWithFormat:@"查看全部%@条评论",talkNum];
//    allString = [allString isEqualToString:@"查看全部(null)条评论"] || [allString isEqualToString:@"查看全部0条评论"] ? @"查看全部评论" : allString;
//    [searchBtn setTitle:allString forState:UIControlStateNormal];

    
    
    



    
//    if (commentArray.count >= 1) {
//        pl1NameLbl.text = [[commentArray[0][@"user_name"] UnicodeToUtf8] append:@":"];
//        pl2NameLbl.text = [commentArray[0][@"comment"] UnicodeToUtf8]  ?
//            [commentArray[0][@"comment"] UnicodeToUtf8] :
//            [commentArray[0][@"answer"] UnicodeToUtf8];
//
//    }
//    if (commentArray.count >= 2){
//        pl1ContentLbl.text = [[commentArray[1][@"user_name"] UnicodeToUtf8] append:@":"];
//        pl2ContentLbl.text = [commentArray[1][@"comment"] UnicodeToUtf8] ? [commentArray[1][@"comment"] UnicodeToUtf8]: [commentArray[1][@"answer"] UnicodeToUtf8];
//    }
    //cell的头图片
    NSString * str1 = [(NSMutableString *)(dic[@"user_photo"] ? dic[@"user_photo"] : dic[@"photo"]) replaceAll:@" " target:@"%20"];
    [titleImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    //自己的头图像
    UserInfo *userInfo = curUser;
    NSString * str2 = [(NSMutableString *)userInfo.photo replaceAll:@" " target:@"%20"];
    [addPlImageView sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    //评论数量
    talkCount.text = talkNum;
    zanCount.text = praisNum;
    //头名字
    titleLbl.text = dic[@"user_name"];
    //头时间
    timeLbl.text = [ShareManager updateTimeForRow:[dic[@"publish_time"] longLongValue]];
    //地点button
    [mapBtn setTitle:dic[@"publish_site"] forState:UIControlStateNormal];
    //赞
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    
    if ([talkNum isEqualToString:@"0"] || [talkNum isEqualToString:@"(null)"]) {
        talkCount.text = @"";
    }
    if ([praisNum isEqualToString:@"0"] || [praisNum isEqualToString:@"(null)"]) {
        zanCount.text = @"";
    }
    
}


@end
