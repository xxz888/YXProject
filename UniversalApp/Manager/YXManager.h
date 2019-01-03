//
//  YXManager.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessdBlockType)();
typedef void(^FailBlockType)();
typedef void(^SuccessdBlockTypeParameter)(id object);

#define YX_BLOCK (id)dic success:(SuccessdBlockTypeParameter)successBlock

@interface YXManager : NSObject
+ (instancetype)sharedInstance;

@property(nonatomic,strong)NSMutableArray * advertisingArray;


#pragma mark ========== GET请求模版 ==========
-(void)requestGET:AD_BLOCK paramters:(NSString *)paramters;
#pragma mark ========== POST请求模版 ==========
-(void)requestPOST:AD_BLOCK;


#pragma mark ========== 请求广告 ==========
-(void)requestGETAdvertising:YX_BLOCK;

@end
