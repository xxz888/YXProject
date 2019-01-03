//
//  HttpRequest.h
//  YMJFSC
//
//  Created by mazg on 16/1/11.
//  Copyright © 2016年 mazg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ResponseObject;

typedef void(^ProgressBlock)(NSProgress *downloadProgress);
typedef void(^SucessBlock)(id responseObject) ;
typedef void(^FailureBlock)(NSError *error) ;

@interface HttpRequest : NSObject

+ (void)httpRequestGetPi:(NSString *)pi sucess:(SucessBlock)sucess failure:(FailureBlock)failure;
+ (void)httpRequestPostPi:(NSString *)pi Parameters:(id)parmeters sucess:(SucessBlock)sucess failure:(FailureBlock)failure;
+ (void)httpRequestUpLoadFormDataImageParmeters:(id)parmeters sucess:(SucessBlock)sucess failure:(FailureBlock)failure;
+ (void)showLoading;
+ (void)hiddenLoading;
@end
