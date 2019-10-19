//
//  YZLiaoTianModel.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/18.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZLiaoTianModel : NSObject
//own_id = 7,
//aim_id = 50,
//content = "嗯！好了，你是个不错吧",
//id = 15,
//date = "2019-10-17",
//type = 1,
//is_read = 0,

@property (nonatomic, strong)NSString * own_id;
@property (nonatomic, strong)NSString * aim_id;
@property (nonatomic, strong)NSString * content;
@property (nonatomic, strong)NSString * id;
@property (nonatomic, strong)NSString * date;
@property (nonatomic, strong)NSString * type;
@property (nonatomic, strong)NSString * is_read;


@end

NS_ASSUME_NONNULL_END
