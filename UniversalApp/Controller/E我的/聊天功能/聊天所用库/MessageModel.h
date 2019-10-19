//
//  MessageModel.h
//  QQPage
//
//  Created by 李海群 on 2017/7/4.
//  Copyright © 2017年 李海群. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    MessageModelTypeMe = 0,
    MessageModelTypeOther
} MessageModelType;

@interface MessageModel : NSObject

@property (nonatomic, strong)NSString  * aim_id;
@property (nonatomic, strong)NSString  * own_id;
@property (nonatomic, strong)NSString  * aim_info;
@property (nonatomic, strong)NSString  * own_info;

/**
 id
 */
@property (nonatomic, strong)NSString  * xxzid;
/**
 other
 */
@property (nonatomic, strong)NSString  * photo;
/**
 正文
 */
@property (nonatomic, copy)NSString *text;

/**
 时间
 */
@property (nonatomic, copy) NSString *time;

/**
 消息类型
 */
@property (nonatomic, assign) MessageModelType type;


/**
 是否显示时间
 */
@property (nonatomic, assign) BOOL hiddenTime;



HQInitH(messageModel)

@end
