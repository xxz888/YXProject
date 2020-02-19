//
//  YXDingZhiHeadView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/11.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiHeadView.h"

@implementation YXDingZhiHeadView

- (void)drawRect:(CGRect)rect {
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Action:)];
    [self.view1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Action:)];
    [self.view2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3Action:)];
    [self.view3 addGestureRecognizer:tap3];
    
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap4Action:)];
    [self.view4 addGestureRecognizer:tap4];
}
-(void)tap1Action:(id)tap{
    self.tapview1block(kGetNSInteger(self.view1.tag));
}
-(void)tap2Action:(id)tap{
    self.tapview2block(kGetNSInteger(self.view2.tag));
}
-(void)tap3Action:(id)tap{
    self.tapview3block(kGetNSInteger(self.view3.tag));
}
-(void)tap4Action:(id)tap{
    self.tapview4block();
}
@end
