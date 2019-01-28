//
//  YXFindImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindImageTableViewCell.h"

@implementation YXFindImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleImageView.layer.masksToBounds = YES;
    self.titleImageView.layer.cornerRadius = self.titleImageView.frame.size.width / 2.0;
    self.addPlImageView.layer.masksToBounds = YES;
    self.addPlImageView.layer.cornerRadius = self.addPlImageView.frame.size.width / 2.0;
    
    ViewRadius(self.midImageView, 3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)searchAllPlBtnAction:(id)sender{
}



-(void)setCellValue:(NSDictionary *)dic{
    
    [self.midImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo1"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.titleTagtextView.text = [dic[@"describe"] append:dic[@"index"]];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.titleLbl.text = dic[@"user_name"];
    self.timeLbl.text = [ShareManager timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@""];
    self.titleTagLbl.text = dic[@"user_name"];

    [self.mapBtn setTitle:dic[@"publish_site"] forState:UIControlStateNormal];
    self.pl1NameLbl.text = dic[@"max_hot_comment"][@"user_name"];
    self.pl1ContentLbl.text = dic[@"max_hot_comment"][@"comment"];
    /*
    NSArray * commentArray = dic[@"max_hot_comment"];
    if (commentArray.count > 0) {
        self.pl1NameLbl.text = commentArray[0][@"user_name"];
        self.pl1ContentLbl.text = commentArray[0][@"comment"];
    }else if (commentArray.count > 1){
        self.pl2NameLbl.text = commentArray[0][@"user_name"];
        self.pl2ContentLbl.text = commentArray[0][@"comment"];
    }

     */
    [self.addPlImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo1"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
}
@end
