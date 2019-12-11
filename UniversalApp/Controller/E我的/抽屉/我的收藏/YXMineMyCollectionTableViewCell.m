//
//  YXMineMyCollectionTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/29.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineMyCollectionTableViewCell.h"

@implementation YXMineMyCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewRadius(self.leftImgView, 5);
    
    
    
}
-(void)setCellData:(NSDictionary *)dic{
    NSInteger sort = [dic[@"sort"] integerValue];
    //图片
   
    switch (sort) {
        case 1:{//雪茄明细
            NSDictionary * dic1 = [NSDictionary dictionaryWithDictionary:dic[@"detail"]];
            NSString * photo = [dic1[@"photo_list"] count] > 0 ? dic1[@"photo_list"][0][@"photo_url"] : @"";
            NSString * str = [(NSMutableString *)photo replaceAll:@" " target:@"%20"];
            [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
            self.titleLbl.text = dic1[@"cigar_name"];
            self.contentLbl.text = dic1[@"argument"];
        }
            break;
        case 2:{//雪茄品牌
            NSDictionary * dic2 = [NSDictionary dictionaryWithDictionary:dic[@"detail"]];
            NSString * str = [(NSMutableString *)dic2[@"photo"] replaceAll:@" " target:@"%20"];
            [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
            self.titleLbl.text = dic2[@"cigar_brand"];
            self.contentLbl.text = dic2[@"intro"];
        }
            break;
        case 3:{//指南
            NSString * str = [(NSMutableString *)dic[@"photo_detail"] replaceAll:@" " target:@"%20"];
            [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
            self.titleLbl.text = dic[@"name"];
            self.contentLbl.text = dic[@"intro"];
            NSString * collNum = [dic[@"detail"] count] > 0 ? kGetString(dic[@"detail"][0][@"collect_number"]) : @"0";
        }
            break;
        default:
            break;
    }

    
    
    
    //标题
//    NSString * title = 
//    self.titleLbl.text = dic[@""];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
