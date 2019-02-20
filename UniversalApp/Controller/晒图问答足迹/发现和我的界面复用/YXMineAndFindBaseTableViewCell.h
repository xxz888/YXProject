//
//  YXMineAndFindBaseTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXMineAndFindBaseTableViewCell : UITableViewCell
+(CGSize)cellAutoHeight:(NSString *)string;
-(void)openAndCloseAction:(NSDictionary *)dic openBtn:(UIButton *)openBtn layout:(NSLayoutConstraint *)layout text:(NSString *)text;
-(void)cellValueDic:(NSDictionary *)dic searchBtn:(UIButton *)searchBtn pl1NameLbl:(UILabel *)pl1NameLbl pl2NameLbl:(UILabel *)pl2NameLbl pl1ContentLbl:(UILabel *)pl1ContentLbl pl2ContentLbl:(UILabel *)pl2ContentLbl titleImageView:(UIImageView *)titleImageView addPlImageView:(UIImageView *)addPlImageView talkCount:(UILabel *)talkCount titleLbl:(UILabel *)titleLbl timeLbl:(UILabel *)timeLbl mapBtn:(UIButton *)mapBtn likeBtn:(UIButton *)likeBtn;
-(CGFloat)getPl1HeightPlArray:(NSDictionary *)dic;
-(CGFloat)getPl2HeightPlArray:(NSDictionary *)dic;
-(CGFloat)getPlAllHeightPlArray:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
