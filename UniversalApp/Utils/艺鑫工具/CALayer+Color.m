//
//  CALayer+Color.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/7.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "CALayer+Color.h"



@implementation CALayer (Color)
-(void)setBorderUIColor:(UIColor*)color

{

self.borderColor= color.CGColor;

}

-(UIColor*)borderUIColor

{

return [UIColor colorWithCGColor:self.borderColor];

}

@end
