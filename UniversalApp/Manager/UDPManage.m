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
//首先导入头文件信息
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"



@interface UDPManage () <GCDAsyncUdpSocketDelegate>
@property (strong, nonatomic)GCDAsyncUdpSocket * udpSocket;
@end

static UDPManage *myUDPManage = nil;

@implementation UDPManage

+(instancetype)shareUDPManage{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myUDPManage = [[UDPManage alloc]init];
    });
    return myUDPManage;
}

-(void)createClientUdpSocket{
    //创建udp socket
    if (!_udpSocket){
        _udpSocket=nil;
    }
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_udpSocket bindToPort:6666 error:nil];
    [_udpSocket receiveOnce:nil];
}
//接收到数据
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到服务端的响应 [%@:%d] %@", ip, port, str);
    [self getNewMessageNumeber];
}
-(void)getNewMessageNumeber{
    kWeakSelf(self);
    [YX_MANAGER requestGETNewMessageNumber:@"" success:^(id object) {
        NSInteger count = [object[@"fans_number"] integerValue] +
        [object[@"comment_number"] integerValue] +
        [object[@"praise_number"] integerValue];
        if (count > 0) {
            [[AppDelegate shareAppDelegate].mainTabBar.axcTabBar setBadge:NSIntegerToNSString(count) index:3];
        }
    }];
}


























//获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
- (NSDictionary *)getIPAddresses{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
@end
