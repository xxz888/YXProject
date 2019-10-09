//
//  YXJiFenShopDetailHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/9.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXJiFenShopDetailHeaderView.h"

@implementation YXJiFenShopDetailHeaderView

 -(void)setHeaderView:(NSDictionary *)dic{

     
     //轮播图
     self.photoArray = [[NSMutableArray alloc]init];
     for (NSDictionary * dic1 in dic[@"photo_list"]) {
         [self.photoArray addObject:[IMG_URI append:dic1[@"photo"]]];
     }
     
     _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.lunboView.frame.size.width, self.lunboView.frame.size.height) shouldInfiniteLoop:NO imageNamesGroup:self.photoArray];
     _cycleScrollView3.delegate = self;
     [self.lunboView addSubview:_cycleScrollView3];
     _cycleScrollView3.delegate = self;
     _cycleScrollView3.bannerImageViewContentMode = 0;
     _cycleScrollView3.currentPageDotColor =  SEGMENT_COLOR;
     _cycleScrollView3.showPageControl = YES;
     _cycleScrollView3.autoScrollTimeInterval = 10000;
     _cycleScrollView3.pageDotColor = YXRGBAColor(239, 239, 239);
     _cycleScrollView3.backgroundColor = KWhiteColor;
     
     //
     self.title.text = dic[@"name"];
     self.jifen.text = kGetString(dic[@"integral"]);
     self.cankaojia.text = [NSString stringWithFormat:@"市场参考价: ￥%@",kGet2fDouble([dic[@"price"] doubleValue])];
       self.shengyufenshu.text = [NSString stringWithFormat:@"剩余%@份",kGetString(dic[@"inventory"])];
     
 }
@end
