//
//  SYBaseHttpConnection.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/28.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "SYBaseHttpConnection.h"
#import "AFHTTPSessionManager.h"

static AFHTTPSessionManager *manager;
@implementation SYBaseHttpConnection

+(AFHTTPSessionManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer =  [AFJSONRequestSerializer serializer];
        manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
        UserInfo *userInfo = curUser;
        if (curUser && userInfo.token && ![userInfo.token isEqualToString:@""]) {
            NSLog(@"身份信息-----%@", [@"JWT " append:userInfo.token]);
            [manager.requestSerializer setValue:[@"JWT " append:userInfo.token] forHTTPHeaderField:@"Authorization"];
        }
        [manager.requestSerializer setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
        //允许非权威机构颁发的证书
        manager.securityPolicy.allowInvalidCertificates=YES;
        //也不验证域名一致性
        manager.securityPolicy.validatesDomainName=NO;
        //关闭缓存避免干扰测试
        manager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;
        manager.requestSerializer.timeoutInterval = 10;
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/plain",nil];
    });
    return manager;
}
@end
