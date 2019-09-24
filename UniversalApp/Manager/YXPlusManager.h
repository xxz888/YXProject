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
-(void)requestCollect_optionGet:YX_BLOCK;
-(void)requestAll_optionGet:YX_BLOCK;

#pragma mark ==========增加收货地址==========
-(void)requestAddressAddPOST:YX_BLOCK;
#pragma mark ==========更改收货地址==========
-(void)requestAddressChangePOST:YX_BLOCK;
#pragma mark ==========删除收货地址==========
-(void)requestAddressDelPOST:YX_BLOCK;
#pragma mark ==========查询收货地址==========
-(void)requestAddressListGet:YX_BLOCK;
@end

