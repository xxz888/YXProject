//
//  YXPlusManager.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/17.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessdBlockType)();
typedef void(^FailBlockType)();
typedef void(^SuccessdBlockTypeParameter)(id object);
#define YX_BLOCK (id)dic success:(SuccessdBlockTypeParameter)successBlock

@interface YXPlusManager : NSObject
+ (instancetype)sharedInstance;
-(void)requestZhiNan1Get:YX_BLOCK;
@end

