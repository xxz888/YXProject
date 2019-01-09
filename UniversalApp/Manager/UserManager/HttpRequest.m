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
        [weakself setCommonRespone:sucess pi:pi responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)httpRequestGetPi:(NSString *)pi sucess:(SucessBlock)sucess failure:(FailureBlock)failure{
    kWeakSelf(self);
    NSString * url = [API_ROOT_URL_HTTP_FORMAL append:pi];
    [[self commonAction] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself setCommonRespone:sucess pi:pi responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@",error);
        failure(error);
    }];
}
#pragma mark ========== 请求成功处理参数的共同方法 ==========
+(void)setCommonRespone:(SucessBlock)sucess pi:(NSString *)pi responseObject:(id)responseObject{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    //返回情况分为两种情况，第一种是NSInlineData 字符串类型， 一种是json字典
    if (dic) {
        //如果解析器是AFHTTPRequestSerializer类型，则要先把数据转换成字典
        NSLog(@"参数 = 【%@】 \n 返回结果 = 【%@】",pi,dic);
        sucess(dic);
    }else{
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *response = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:enc];
        sucess(response);
    }
}
+(AFHTTPSessionManager *)commonAction{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    UserInfo *userInfo = curUser;
    if (curUser && userInfo.token && ![userInfo.token isEqualToString:@""]) {
        NSLog(@"身份信息-----%@",[@"JWT " append:userInfo.token]);
        [manager.requestSerializer setValue:[@"JWT " append:userInfo.token] forHTTPHeaderField:@"Authorization"];
    }
    //允许非权威机构颁发的证书
    manager.securityPolicy.allowInvalidCertificates=YES;
    //也不验证域名一致性
    manager.securityPolicy.validatesDomainName=NO;
    //关闭缓存避免干扰测试
    manager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/plain",nil];
    return manager;
}

#pragma mark ========== 设置公共请求参数 ==========
+(void)setCommonRequestParameters{
    
}



@end
