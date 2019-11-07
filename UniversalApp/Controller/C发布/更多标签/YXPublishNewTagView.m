//
//  YXPublishNewTagView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/7.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXPublishNewTagView.h"

@implementation YXPublishNewTagView


- (IBAction)closeAction:(id)sender {
    self.closeblock();
}
- (IBAction)fabuAction:(id)sender {
    [self.huatiTf resignFirstResponder];
    self.fabublock();
}

- (IBAction)makeSureAction:(id)sender {
    self.makeSureblock();
}
@end
