//
//  UserInfo.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/23.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameInfo;

typedef NS_ENUM(NSInteger,UserGender){
    UserGenderUnKnow = 0,
    UserGenderMale, //男
    UserGenderFemale //女
};

@interface UserInfo : NSObject

@property(nonatomic,assign)long long userid;//用户ID
@property (nonatomic,copy) NSString * idcard;//展示用的用户ID
@property (nonatomic,copy) NSString * nickname;//昵称
@property (nonatomic, assign) UserGender sex;//性别
@property (nonatomic,copy) NSString * imId;//IM账号
@property (nonatomic,copy) NSString * imPass;//IM密码
@property (nonatomic,assign) NSInteger  degreeId;//用户等级
@property (nonatomic,copy) NSString * signature;//个性签名
@property (nonatomic, strong) GameInfo *info;//游戏数据


@property (nonatomic, strong)NSString *  mobile;
@property (nonatomic, strong)NSString *  gender;
@property (nonatomic, strong)NSString *  country;
@property (nonatomic, strong)NSString *  id;
@property (nonatomic, strong)NSString *  city;
@property (nonatomic, strong)NSString *  ID_card;
@property (nonatomic, strong)NSString *  username;
@property (nonatomic, strong)NSString *  photo;
@property (nonatomic, strong)NSString *  token;
@property (nonatomic, strong)NSString *  province;
@property (nonatomic, strong)NSString *  birthday;

@property (nonatomic, strong)NSString *  site;

@end
