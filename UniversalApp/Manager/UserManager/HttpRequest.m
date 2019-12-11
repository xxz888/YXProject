//
//  HttpRequest.m
//  YMJFSC
//
//  Created by mazg on 16/1/11.
//  Copyright © 2016年 mazg. All rights reserved.
//

#import "HttpRequest.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "XLDouYinLoading.h"
#import "SYBaseHttpConnection.h"
#import "SYBaseHttpConnection1.h"

@implementation HttpRequest

+ (void)httpRequestPostPi:(NSString *)pi Parameters:(id)parmeters sucess:(SucessBlock)sucess failure:(FailureBlock)failure{

    kWeakSelf(self);
    NSString * strURl = [API_ROOT_URL_HTTP_FORMAL stringByAppendingString:pi];
//    NSLog(@"getUrl-:%@",strURl);
    
        AFHTTPSessionManager * manager = [SYBaseHttpConnection sharedManager];
        NSDictionary * userInfo = userManager.loadUserAllInfo;
        if (userInfo) {
            [manager.requestSerializer setValue:[@"JWT " append:userInfo[@"token"]] forHTTPHeaderField:@"Authorization"];
        }
   

    
    [manager POST:strURl  parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [QMUITips hideAllTips];
        [weakself setCommonRespone:sucess pi:pi responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [QMUITips hideAllTips];
        failure(error);
    }];
}
+ (void)httpRequestGetPi:(NSString *)pi sucess:(SucessBlock)sucess failure:(FailureBlock)failure{
    kWeakSelf(self);
    NSString * url = [API_ROOT_URL_HTTP_FORMAL append:pi];
//    NSLog(@"getUrl-:%@",url);
       AFHTTPSessionManager * manager = [SYBaseHttpConnection sharedManager];
     
      NSDictionary * userInfo = userManager.loadUserAllInfo;
      if (userInfo) {
          if ([pi contains:@"/pub/option/"]) {
              
          }else{
              [manager.requestSerializer setValue:[@"JWT " append:userInfo[@"token"]] forHTTPHeaderField:@"Authorization"];
          }
      }


    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [QMUITips hideAllTips];
        [weakself setCommonRespone:sucess pi:pi responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [QMUITips hideAllTips];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
}

/*
var a = "a"
var b = "b"

if(isHave){
    a = "aa";
}else{
    a = "aaaaaa"
}
var c = a + b
*/

#pragma mark ========== 请求成功处理参数的共同方法 ==========
+(void)setCommonRespone:(SucessBlock)sucess pi:(NSString *)pi responseObject:(id)responseObject{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    UIView * view;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
        view = [[UIApplication sharedApplication].windows firstObject];
    } else {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    if ([pi isEqualToString:@"/pub/tag/"]) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        sucess(result);
        return;
    }
    //返回情况分为两种情况，第一种是NSInlineData 字符串类型， 一种是json字典
    if ([obj isKindOfClass:[NSArray class]]) {
        sucess(obj);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        if ([((NSDictionary *)obj).allKeys containsObject:@"status"] && [((NSDictionary *)obj).allKeys containsObject:@"message"]) {
            if ([obj[@"status"] integerValue] == 1) {
                sucess(obj);
            }else{
                if ([obj[@"status"] integerValue] == 0) {
                    [QMUITips showError:obj[@"message"] inView:view hideAfterDelay:0.5];
                }else{
                    if ([obj[@"status"] integerValue] == -1){
                                       
                      }else{
                          [QMUITips showError:obj[@"message"] inView:view hideAfterDelay:0.5];
                      }
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                });
                return;
            }
        }else{
            sucess(obj);
        }
    }else{
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *response = [[NSString alloc] initWithBytes:[obj bytes] length:[responseObject length] encoding:enc];
        if (response) {
            sucess(response);
        }else{
            NSString * str = [NSString stringWithFormat:@"请求接口为:%@\n返回数据为:%@",pi,response];
            [QMUITips showError:@"返回类型未知,无法解析" inView:view hideAfterDelay:0.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [QMUITips showError:str inView:view hideAfterDelay:2];
            });
        }
    }
    

}
#pragma mark ========== 设置公共请求参数 ==========
+(void)setCommonRequestParameters{
    
}


@end
