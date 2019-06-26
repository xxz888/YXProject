//
//  YXShaiTuModel.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/19.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXShaiTuModel : NSObject
@property (nonatomic, strong)NSString * coustomId;//自定义的id,用来区别草稿的内容


@property (nonatomic, strong)NSString * post_id;
@property (nonatomic, strong)NSString * detail;
@property (nonatomic, strong)NSString * publish_site;

@property (nonatomic, strong)NSString * obj;
@property (nonatomic, strong)NSString * title;
@property (nonatomic, strong)NSString * tag;
@property (nonatomic, strong)NSString * photo_list;
@property (nonatomic, strong)NSString * cover;



/*
 detail = "\u6652\u56fe\u8349\u7a3f",
 post_id = "",
 publish_site = "",
 obj = "1",
 title = "",
 tag = "#我是",
 photo_list = "3_image_1561527887000.jpg,3_image_1561527888000.jpg",
 cover = "",
 */
@end

NS_ASSUME_NONNULL_END
