//
//  YXGEFPinPaiDetailTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/18.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXGEFPinPaiDetailTableViewCell.h"
@interface YXGEFPinPaiDetailTableViewCell (){
    UIImage *_zanImage;
    UIImage *_unZanImage;
    BOOL isCollection;
}

@end
@implementation YXGEFPinPaiDetailTableViewCell
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //[self setLayoutCol];
        _zanImage=[UIImage imageNamed:@"Zan"];
        _unZanImage=[UIImage imageNamed:@"UnZan"];
    }
    return self;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // [self setLayoutCol];
        _zanImage=[UIImage imageNamed:@"Zan"];
        _unZanImage=[UIImage imageNamed:@"UnZan"];
    }
    return self;
}
-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    //[self setLayoutCol];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeAction:(id)sender {
    isCollection = !isCollection;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLikeBtn:golf_id:likeBtn:)]) {
        [self.delegate clickLikeBtn:isCollection golf_id:self.golf_id likeBtn:self.likeBtn];
    }
}
@end
