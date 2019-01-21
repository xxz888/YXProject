//
//  YXHomeGolfScoreHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeGolfScoreHeaderView.h"
#import "CBGroupAndStreamView.h"

@interface YXHomeGolfScoreHeaderView ()<CBGroupAndStreamDelegate>
@property (strong, nonatomic) CBGroupAndStreamView * menueView;
@end
@implementation YXHomeGolfScoreHeaderView

- (void)drawRect:(CGRect)rect {

    [self setUI];
}
-(void)setUI{
    NSArray * titleArr = @[@"",@""];
    NSArray *contentArr = @[@[@"    A场    ",@"    B场    "],@[@"    A场    ",@"    B场    "]];
    
    CBGroupAndStreamView * silde = [[CBGroupAndStreamView alloc] initWithFrame:CGRectMake(0, -3, [UIScreen mainScreen].bounds.size.width, self.twoView.bounds.size.height)];
    silde.delegate = self;
    silde.isDefaultSel = YES;
    silde.isSingle = YES;
    silde.font = [UIFont systemFontOfSize:12];
    silde.titleTextFont = [UIFont systemFontOfSize:18];
    silde.selColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0];
    [silde setContentView:contentArr titleArr:titleArr];
    [self.twoView addSubview:silde];
    _menueView = silde;
    silde.cb_confirmReturnValueBlock = ^(NSArray *valueArr, NSArray *groupIdArr) {
        NSLog(@"valueArr = %@ \ngroupIdArr = %@",valueArr,groupIdArr);
    };
    silde.cb_selectCurrentValueBlock = ^(NSString *value, NSInteger index, NSInteger groupId) {
        NSLog(@"value = %@----index = %ld------groupId = %ld",value,index,groupId);
    };

}

- (void)resetSelt{
    [_menueView reset];
}

- (void)confirmSelt{
    [_menueView confirm];
}


#pragma mark---delegate
- (void)cb_confirmReturnValue:(NSArray *)valueArr groupId:(NSArray *)groupIdArr{
    NSLog(@"valueArr = %@ \ngroupIdArr = %@",valueArr,groupIdArr);
}

- (void)cb_selectCurrentValueWith:(NSString *)value index:(NSInteger)index groupId:(NSInteger)groupId{
    NSLog(@"value = %@----index = %ld------groupId = %ld",value,index,groupId);
}
@end
