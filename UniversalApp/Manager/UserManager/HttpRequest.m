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
@implementation HttpRequest

+ (void)httpRequestPostPi:(NSString *)pi Parameters:(id)parmeters sucess:(SucessBlock)sucess failure:(FailureBlock)failure{
    kWeakSelf(self);
    NSString * strURl = [API_ROOT_URL_HTTP_FORMAL stringByAppendingString:pi];
    [[self commonAction] POST:strURl  parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //如果解析器是AFHTTPRequestSerializer类型，则要先把数据转换成字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"pi = 【%@】 result = 【%@】",pi,dic);
        sucess(dic);
        //这里判断rid
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        failure(error);
    }];
}
+ (void)httpRequestGetPi:(NSString *)pi sucess:(SucessBlock)sucess failure:(FailureBlock)failure{
    kWeakSelf(self);
    NSString * url = [API_ROOT_URL_HTTP_FORMAL append:pi];
    [[self commonAction] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //如果解析器是AFHTTPRequestSerializer类型，则要先把数据转换成字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"pi = 【%@】 result = 【%@】",pi,dic);
        sucess(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure(error);
    }];
}
+(AFHTTPSessionManager *)commonAction{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    //允许非权威机构颁发的证书
    manager.securityPolicy.allowInvalidCertificates=YES;
    //也不验证域名一致性
    manager.securityPolicy.validatesDomainName=NO;
    //关闭缓存避免干扰测试
    manager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    return manager;
}

#pragma mark ========== 设置公共请求参数 ==========
+(void)setCommonRequestParameters{
    
}



@end
