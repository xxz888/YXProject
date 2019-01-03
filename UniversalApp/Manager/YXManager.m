//
//  YXManager.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXManager.h"
#import "HttpRequest.h"

#define RREQUEST_POST(paramters)     [HTTP_POST(paramters) Parameters:dic sucess:^(id responseObject) {\
successBlock(responseObject);\
} failure:^(NSError *error) {\
}];


#define RREQUEST_GET(paramters)     [HTTP_GET(paramters)  sucess:^(id responseObject) {\
successBlock(responseObject);\
} failure:^(NSError *error) {\
}];

@interface YXManager ()

@end
#define HTTP_POST(pi) HttpRequest httpRequestPostPi:pi
#define HTTP_GET(pi)  HttpRequest httpRequestGetPi:pi

@implementation YXManager

/*单例*/
+ (instancetype)sharedInstance{
    static YXManager *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[YXManager alloc]init];
    });
    return s_instance;
}


#pragma mark ==========GET请求模版==========
-(void)requestGET:YX_BLOCK{

}
#pragma mark ==========POST请求模版==========
-(void)requestPOST:YX_BLOCK{

}

#pragma mark ========== 请求广告 ==========
-(void)requestGETAdvertising:YX_BLOCK{
    kWeakSelf(self);
    NSString * url = @"/pub/advertising/";
    [HTTP_GET([url append:dic])  sucess:^(id responseObject) {
        [weakself.advertisingArray removeAllObjects];
        [weakself.advertisingArray addObject:responseObject];
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}


- (instancetype)init{
    self.advertisingArray = [[NSMutableArray alloc]init];
    return  self;
}
@end
