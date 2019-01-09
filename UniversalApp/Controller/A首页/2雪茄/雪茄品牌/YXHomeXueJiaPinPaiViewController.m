//
//  YXHomeXueJiaPinPaiViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiViewController.h"
#import "PYSearchViewController.h"
#import "PYSearch.h"
#import "PYTempViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>

#import "YXHomeXueJiaGuBaViewController.h"
@interface YXHomeXueJiaPinPaiViewController() <PYSearchViewControllerDelegate>
    {
        YXHomeXueJiaGuBaViewController * VC1;
        YXHomeXueJiaGuBaViewController * VC2;
        YXHomeXueJiaGuBaViewController * VC3;
        YXHomeXueJiaGuBaViewController * VC4;
    }
@property (nonatomic,weak) ZXSegmentController* segmentController;
@end
@implementation YXHomeXueJiaPinPaiViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewDidLoad{
    [self setNavSearchView];
    [self setInitCollection];
}





-(void)setInitCollection{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    
    if (!VC1) {
        VC1 = [stroryBoard instantiateViewControllerWithIdentifier:@"YXHomeXueJiaGuBaViewController"];
    }
    if (!VC2) {
        VC2 = [stroryBoard instantiateViewControllerWithIdentifier:@"YXHomeXueJiaGuBaViewController"];
    }
    
    if (!VC3) {
        VC3 = [stroryBoard instantiateViewControllerWithIdentifier:@"YXHomeXueJiaGuBaViewController"];
    }
    if (!VC4) {
        VC4 = [stroryBoard instantiateViewControllerWithIdentifier:@"YXHomeXueJiaGuBaViewController"];
    }
    
    
    NSArray* names = @[@"古巴",@"非古",@"我的关注",@"筛选"];
    NSArray* controllers = @[VC1,VC2,VC3,VC4];
    
    
    /*
     *   controllers长度和names长度必须一致，否则将会导致cash
     *   segmentController在一个屏幕里最多显示6个按钮，如果超过6个，将会自动开启滚动功能，如果不足6个，按钮宽度=父view宽度/x  (x=按钮个数)
     */
    ZXSegmentController* segmentController = [[ZXSegmentController alloc] initWithControllers:controllers
                                                                               withTitleNames:names
                                                                             withDefaultIndex:1
                                                                               withTitleColor:[UIColor grayColor]
                                                                       withTitleSelectedColor:YXRGBAColor(88, 88, 88)
                                                                              withSliderColor:YXRGBAColor(88, 88, 88)];
    [self addChildViewController:(_segmentController = segmentController)];
    [self.view addSubview:segmentController.view];
    [segmentController didMoveToParentViewController:self];
    [self createAutolayout];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [segmentController scrollToIndex:1 animated:YES];
}
- (void)createAutolayout{
    /*
     高度自由化的布局，可以根据需求，把segmentController布局成你需要的样子.(面对不同的场景，设置不同的top距离)
     */
    [_segmentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(84);
        make.left.right.bottom.mas_equalTo(0);
    }];
}




#pragma mark ==========  搜索相关 ==========
-(void)setNavSearchView{
    UIColor *color =  YXRGBAColor(239, 239, 239);
    UITextField * searchBar = [[UITextField alloc] init];
    searchBar.frame = CGRectMake(50, 0, KScreenWidth - 50, 35);
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 10;
    searchBar.layer.masksToBounds = YES;
   
    searchBar.placeholder = @"   🔍 搜索";
    
    
    [searchBar addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingDidBegin];
    
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = searchBar;

}
-(void)textField1TextChange:(UITextField *)tf{
    [self clickSearchBar];
}



- (void)clickSearchBar
{
    // 1. Create an Array of popular search
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"PYExampleSearchPlaceholderText", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        [searchViewController.navigationController pushViewController:[[PYTempViewController alloc] init] animated:YES];
    }];
    // 3. Set style for popular search and search history

        searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
        searchViewController.searchHistoryStyle = 1;

    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present(Modal) or push search view controller
    // Present(Modal)
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    //    [self presentViewController:nav animated:YES completion:nil];
    // Push
    // Set mode of show search view controller, default is `PYSearchViewControllerShowModeModal`
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    //    // Push search view controller
    [self.navigationController pushViewController:searchViewController animated:YES];
}
@end
