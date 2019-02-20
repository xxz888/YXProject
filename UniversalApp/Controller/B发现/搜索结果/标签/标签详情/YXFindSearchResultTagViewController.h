//
//  YXFindSearchResultTagViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchResultAllViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXFindSearchResultTagViewController : YXFindSearchResultAllViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)segmentAction:(UISegmentedControl *)sender;
@property (nonatomic,strong) NSString *key;

@end

NS_ASSUME_NONNULL_END
