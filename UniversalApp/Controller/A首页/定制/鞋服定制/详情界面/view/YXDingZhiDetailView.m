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
- (void)drawRect:(CGRect)rect {
    [ShareManager fiveStarView:5 view:self.starView];
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    [self.cellAdressBottomView addGestureRecognizer:aTapGR];
}
-(void)tapGRAction:(id)tap{
    kWeakSelf(self);
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:@"浙江省杭州市登云路108号" completionHandler:^(NSArray *placemarks, NSError *error) {
    double latitude = 0;double longitude = 0;
    if ([placemarks count] > 0 && error == nil) {
        CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
         latitude = firstPlacemark.location.coordinate.latitude;
         longitude = firstPlacemark.location.coordinate.longitude;
        if (latitude != 0 && longitude != 0) {
            [weakself.mapNavigationView showMapNavigationViewFormcurrentLatitude:0 currentLongitute:0 TotargetLatitude:latitude targetLongitute:longitude toName:@"浙江省杭州市登云路108号"];
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
