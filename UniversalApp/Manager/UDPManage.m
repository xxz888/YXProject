//
//  UDPManage.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "UDPManage.h"

#import "UDPManage.h"
#import "GCDAsyncUdpSocket.h"

#define udpPort 8001

@interface UDPManage () <GCDAsyncUdpSocketDelegate>
@property (strong, nonatomic)GCDAsyncUdpSocket * udpSocket;
@end

static UDPManage *myUDPManage = nil;

@implementation UDPManage

+(instancetype)shareUDPManage{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myUDPManage = [[UDPManage alloc]init];
        [myUDPManage createClientUdpSocket];
    });
    return myUDPManage;
}

-(void)createClientUdpSocket{
    //创建udp socket
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    //banding一个端口(可选),如果不绑定端口,那么就会随机产生一个随机的电脑唯一的端口
    NSError * error = nil;
    [self.udpSocket bindToPort:udpPort error:&error];
    
    //启用广播
    [self.udpSocket enableBroadcast:YES error:&error];
    
    if (error) {//监听错误打印错误信息
        NSLog(@"error:%@",error);
    }else {//监听成功则开始接收信息
        [self.udpSocket beginReceiving:&error];
    }
}

//广播
-(void)broadcast{
    
    NSString *str = @"ios";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //此处如果写成固定的IP就是对特定的server监测
    NSString *host = @"192.168.0.12";
    
    //发送数据（tag: 消息标记）
    [self.udpSocket sendData:data toHost:host port:udpPort withTimeout:-1 tag:100];
    
}
#pragma mark GCDAsyncUdpSocketDelegate
//发送数据成功
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    if (tag == 100) {
        NSLog(@"标记为100的数据发送完成了");
    }
}

//发送数据失败
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"标记为%ld的数据发送失败，失败原因：%@",tag, error);
}

//接收到数据
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到服务端的响应 [%@:%d] %@", ip, port, str);
}
@end
