//
//  UDPManage.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UDPManage : NSObject
+(instancetype)shareUDPManage;
-(void)broadcast;
@end

NS_ASSUME_NONNULL_END
