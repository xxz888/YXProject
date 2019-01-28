//
//  YXFindQuestionTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindQuestionTableViewCell.h"

@implementation YXFindQuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addPlImageView.layer.masksToBounds = YES;
    self.addPlImageView.layer.cornerRadius = self.addPlImageView.frame.size.width / 2.0;
    self.titleImageView.layer.masksToBounds = YES;
    self.titleImageView.layer.cornerRadius = self.titleImageView.frame.size.width / 2.0;
    
    ViewRadius(self.midImageView1, 3);
    ViewRadius(self.midImageView2, 3);
    ViewRadius(self.midImageView3, 3);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellValue:(NSDictionary *)dic{
    
    self.titleTagLbl1.text = dic[@"title"];
    self.titleTagLbl2.text = dic[@"question"];
    [self.midImageView1 sd_setImageWithURL:[NSURL URLWithString:dic[@"pic1"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.midImageView2 sd_setImageWithURL:[NSURL URLWithString:dic[@"pic2"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.midImageView3 sd_setImageWithURL:[NSURL URLWithString:dic[@"pic3"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        
    NSArray * commentArray = dic[@"answer"];
    if (commentArray.count > 0) {
        self.pl1NameLbl.text = commentArray[0][@"user_name"];
        self.pl1ContentLbl.text = commentArray[0][@"comment"];
    }else if (commentArray.count > 1){
        self.pl2NameLbl.text = commentArray[0][@"user_name"];
        self.pl2ContentLbl.text = commentArray[0][@"comment"];
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"user_photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.titleLbl.text = dic[@"user_name"];
    self.timeLbl.text = [ShareManager timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@""];
    [self.mapBtn setTitle:dic[@"publish_site"] forState:UIControlStateNormal];
  
    
   
     
    
    [self.addPlImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo1"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
}
@end
