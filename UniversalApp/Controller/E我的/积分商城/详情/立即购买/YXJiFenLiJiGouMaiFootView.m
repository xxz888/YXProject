//
//  YXJiFenLiJiGouMaiFootView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/10.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXJiFenLiJiGouMaiFootView.h"



@implementation YXJiFenLiJiGouMaiFootView

- (void)drawRect:(CGRect)rect {
    [self.querenzhifu setBackgroundColor:SEGMENT_COLOR];
}


- (IBAction)querenzhifuAction:(id)sender {
    self.lijigoumaiblock();
}
@end
