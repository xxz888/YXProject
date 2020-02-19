//
//  YXDingZhiDetailView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiDetailView.h"

@implementation YXDingZhiDetailView
- (JXMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[JXMapNavigationView alloc]init];
    }
    return _mapNavigationView;
}


-(void)setCellData{
    //图片
     NSString * url = [IMG_URI append:[self.startDic[@"photo_list"] split:@","][0]];
     [self.cellImv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    //共几张图片
    self.countLbl.text = [NSString stringWithFormat:@"共%lu张",[[self.startDic[@"photo_list"] split:@","] count]];
    //title
    self.cellTitle.text = self.startDic[@"name"];
    //营业时间
    self.cellTime.text = [YXPLUS_MANAGER inYingYeTimeOutChangeTime:self.startDic[@"business_days"] business_hours:self.startDic[@"business_hours"]];
    //地址
    self.cellAdress.text = [self.startDic[@"city"] append:self.startDic[@"site"]];
    //距离
    self.cellFar.text =  [NSString stringWithFormat:@"距你%dkm",[self.startDic[@"distance"] intValue] / 1000] ;
    //评分
     [self.starView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     [ShareManager fiveStarView:[self.startDic[@"grade"] qmui_CGFloatValue] view:self.starView];
}

- (void)drawRect:(CGRect)rect {
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    [self.cellAdressBottomView addGestureRecognizer:aTapGR];
    
    
    UITapGestureRecognizer * aTapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction1:)];
    [self.countView addGestureRecognizer:aTapGR1];
    
    self.countView.backgroundColor = kRGBA(0, 0, 0, 0.5);
    self.countView.layer.cornerRadius = 4;
}
//点击数量的view
-(void)tapGRAction1:(id)tap{
    self.clickCountViewBlock();
}
//点击星星
-(void)tapGRAction:(id)tap{
    kWeakSelf(self);
    NSString * address = [self.startDic[@"city"] append:self.startDic[@"site"]];
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
    double latitude = 0;double longitude = 0;
    if ([placemarks count] > 0 && error == nil) {
        CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
         latitude = firstPlacemark.location.coordinate.latitude;
         longitude = firstPlacemark.location.coordinate.longitude;
        if (latitude != 0 && longitude != 0) {
            [weakself.mapNavigationView showMapNavigationViewFormcurrentLatitude:0 currentLongitute:0 TotargetLatitude:latitude targetLongitute:longitude toName:address];
            [weakself addSubview:_mapNavigationView];
        }
    }else if ([placemarks count] == 0 && error == nil) {
        NSLog(@"Found no placemarks.");
        [QMUITips showError:@"地址错误, 请手工导航"];
    }else if (error != nil) {
        NSLog(@"An error occurred = %@", error);
        [QMUITips showError:@"地址错误, 请手工导航"];
    }
        
       
    }];
    

}

- (IBAction)pinglunAction:(id)sender {
    self.pingLunBlock();
}


@end
