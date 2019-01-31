//
//  YXHomeXueJiaDetailTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/7.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaDetailTableViewCell.h"
#import "CatZanButton.h"


@interface YXHomeXueJiaDetailTableViewCell (){
    UIImage *_zanImage;
    UIImage *_unZanImage;
    BOOL isCollection;
}
@property (nonatomic , strong) UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UIStackView *stackView1;
@end
@implementation YXHomeXueJiaDetailTableViewCell

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
    //yes为足迹进来 no为正常进入  足迹进来
    self.stackView1.hidden = self.likeBtn.hidden = self.whereCome;
}


- (IBAction)likeBtnAction:(id)sender {
    isCollection = !isCollection;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLikeBtn:cigar_id:likeBtn:)]) {
        [self.delegate clickLikeBtn:isCollection cigar_id:self.cigar_id likeBtn:self.likeBtn];
    }
  
}

@end
