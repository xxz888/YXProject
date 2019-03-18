//
//  YXMineHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/29.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineHeaderView.h"

@implementation YXMineHeaderView

- (void)drawRect:(CGRect)rect {

}
- (IBAction)editPersonAction:(id)sender{
    self.editPersionblock();
}
- (IBAction)guanzhuAction:(id)sender{
    self.guanzhublock();
}
- (IBAction)fensiAction:(id)sender{
    self.fensiblock();
    
}
- (IBAction)tieshuAction:(id)sender{
    self.tieshublock();
}
-(void)setViewUI{

}
- (IBAction)guanZhuOtherAction:(id)sender {
    self.guanZhuOtherblock();
}
@end
