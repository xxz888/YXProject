//
//  QiniuLoad.m
//  Yomika
//
//  Created by Administrator on 2017/5/25.
//  Copyright © 2017年 tion_Z. All rights reserved.
//

#import "QiniuLoad.h"
#import <QiniuSDK.h>
#include <CommonCrypto/CommonCrypto.h>
#import <AFNetworking.h>
#import <QN_GTM_Base64.h>
#import "ZLPhotoAssets.h"
#import <QNEtag.h>
#import <QNConfiguration.h>


#define kQNinterface @"http://pl05cmwlt.bkt.clouddn.com/"
static NSString *accessKey = @"ybwGKYoTnJ_9O4AEqcIBc64w1RUd52IUCR59ZkjQ";
static NSString *secretKey = @"l516o_86yRbBdiOkJIz-TKEyjH7a2KM_E16vcPLv";
static NSString *QiniuBucketName       = @"storeios";


//static NSString *accessKey = @"rpLW8CzqDzdgK27Mdp6fdrFjjdJRR-jBmfC1m8P0";
//static NSString *secretKey = @"m6t4wu-bTuHJBmw4h-H99JiogkmfKNfj2N0nvG-K";
//static NSString *QiniuBucketName  = @"thegdlife";

@interface QiniuLoad ()

@end

@implementation QiniuLoad

//获取token

+ (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey{
    
    const char *secretKeyStr = [secretKey UTF8String];
    NSString *policy = [QiniuLoad marshal];
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedPolicy = [QN_GTM_Base64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    NSString *encodedDigest = [QN_GTM_Base64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
    
    return token;//得到了token
}

+ (NSString *)marshal{
    
    NSInteger _expire = 0;
    time_t deadline;
    time(&deadline);//返回当前系统时间
    //@property (nonatomic , assign) int expires; 怎么定义随你...
    deadline += (_expire > 0) ? _expire : 3600; // +3600秒,即默认token保存1小时.
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:QiniuBucketName forKey:@"scope"];//根据
    [dic setObject:deadlineNumber forKey:@"deadline"];
    NSString *json = [QiniuLoad convertToJsonData:dic ];
    
    return json;
}


-(void)download{
    
    NSString *path = @"自己查看一下文档，这里填你需要下载的文件的url";
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:1 timeoutInterval:15.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"response = %@",response);
        
        //得到了JSON文件 解析就好了。
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        NSLog(@"%@", result);
        
    }];
}

+(void)uploadImageToQNFilePath:(NSArray *)photos success:(QNSuccessBlock)success failure:(QNFailureBlock)failure{
    /*
    NSMutableArray *imageAry =[NSMutableArray arrayWithArray:photos];
    NSMutableArray *imageAdd = [NSMutableArray new];
    //华东
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNFixedZone zone0];
    }];
    
    
//        UserInfo *userInfo = curUser;
//        NSString * userId = userInfo.id;
        NSString * key = [NSString stringWithFormat:@"%@_image_%@.jpg/",curUser.id,[ShareManager getNowTimeTimestamp3]];
//        [YX_MANAGER requestQiniu_tokenGET:key success:^(id object) {
//            NSString * token = object[@"token"];
            NSString * token = [QiniuLoad makeToken:accessKey secretKey:secretKey];
            NSString * filePath = [QiniuLoad getImagePath:imageAry[0]];
            QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
            QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) { }
                     params:nil  checkCrc:NO cancellationSignal:nil];
            [upManager putFile:filePath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.isOK) {
                    success(resp[@"key"]);
                }
            }option:uploadOption];
//        }];
    */
    
    NSMutableArray *imageAry =[NSMutableArray new];
    NSMutableArray *imageAdd = [NSMutableArray new];
    //主要是把图片或者文件转成nsdata类型就可以了
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNFixedZone zone0];}];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil
                                                        progressHandler:^(NSString *key, float percent) {}
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%ld",idx);
        NSData *data;
        if (UIImagePNGRepresentation(obj) == nil){
            data = UIImageJPEGRepresentation(obj, 1);
        } else {
            data = UIImagePNGRepresentation(obj);
        }
        UserInfo *userInfo = curUser;
        NSString * userId = userInfo.id;
        sleep(1);
        NSString * key = [NSString stringWithFormat:@"%@_image_%@.jpg/",userId,[ShareManager getNowTimeTimestamp3]];
        [upManager putData:data key:key token:[QiniuLoad makeToken:accessKey secretKey:secretKey] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.isOK) {
                [imageAdd addObject:[NSString stringWithFormat:@"%@%@",kQNinterface,resp[@"key"]]];
            }else{
                //[imageAdd addObject:[NSString stringWithFormat:@"%ld",idx]];
            }
            if (imageAdd.count == photos.count) {
                if (success) {
                    success([imageAdd componentsJoinedByString:@";"]);
                }
            }
        }
                    option:uploadOption];
    }];
}
+ (NSString *)qnImageFilePatName{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *now = [formatter stringFromDate:[NSDate date]];
    NSString *number = [QiniuLoad generateTradeNO];
    //当前时间
    NSInteger interval = (NSInteger)[[NSDate date]timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"Picture/%@/%ld%@.jpg",now,interval,number];
    NSLog(@"name__%@",name);
    
    return name;
}

+(NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

+ (NSString *)generateTradeNO {
    
    static int kNumber = 8;
    NSString *sourceStr = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    NSLog(@"%@",resultStr);
    return resultStr;
    
}


//照片获取本地路径转换
+ (NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}
@end
