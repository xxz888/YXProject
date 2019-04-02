//
//  YXHomeXueJiaWenHuaTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaWenHuaTableViewCell.h"
//280+titleHeight
@implementation YXHomeXueJiaWenHuaTableViewCell
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic{
    //内容
    CGFloat height_size = [ShareManager inTextOutHeight:dic[@"title"] lineSpace:9 fontSize:20];
    return 320 + height_size;
}

-(void)setCellData:(NSDictionary *)dic{
    NSString * str = [dic[@"picture"] replaceAll:@" " target:@"%20"];
    [self.wenhuaImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.wenhuaLbl.text = dic[@"title"];
    self.titleHeight.constant = [ShareManager inTextOutHeight:dic[@"title"] lineSpace:9 fontSize:20];
    
    self.talkNumLbl.text = kGetString(dic[@"comment_number"]);
    self.zanNumLbl.text = kGetString(dic[@"praise_number"]);

    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    self.wenhuaImageView.layer.masksToBounds = YES;
    self.wenhuaImageView.layer.cornerRadius = 3;
}

@end
