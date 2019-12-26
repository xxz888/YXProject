//
//  GitHub: https://github.com/iphone5solo/PYSearch
//  Created by CoderKo1o.
//  Copyright © 2015 iphone5solo. All rights reserved.
//

#import "PYSearchViewController.h"
#import "PYSearchConst.h"
#import "PYSearchSuggestionViewController.h"

#define PYRectangleTagMaxCol 3
#define PYTextColor KBlackColor
#define PYSEARCH_COLORPolRandomColor self.colorPol[arc4random_uniform((uint32_t)self.colorPol.count)]

@interface PYSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, PYSearchSuggestionViewDataSource, UIGestureRecognizerDelegate,UITextFieldDelegate> {
    id <UIGestureRecognizerDelegate> _previousInteractivePopGestureRecognizerDelegate;
}

/**
 The header view of search view
 */
@property (nonatomic, weak) UIView *headerView;

/**
 The view of popular search
 */
@property (nonatomic, weak) UIView *hotSearchView;

/**
 The view of search history
 */
@property (nonatomic, weak) UIView *searchHistoryView;

/**
 The records of search
 */
@property (nonatomic, strong) NSMutableArray *searchHistories;

/**
 Whether keyboard is showing.
 */
@property (nonatomic, assign) BOOL keyboardShowing;

/**
 The height of keyborad
 */
@property (nonatomic, assign) CGFloat keyboardHeight;

/**
 The search suggestion view contoller
 */
@property (nonatomic, weak) PYSearchSuggestionViewController *searchSuggestionVC;

/**
 The content view of popular search tags
 */
@property (nonatomic, weak) UIView *hotSearchTagsContentView;

/**
 The tags of rank
 */
@property (nonatomic, copy) NSArray<UILabel *> *rankTags;

/**
 The text labels of rank
 */
@property (nonatomic, copy) NSArray<UILabel *> *rankTextLabels;

/**
 The view of rank which contain tag and text label.
 */
@property (nonatomic, copy) NSArray<UIView *> *rankViews;

/**
 The content view of search history tags.
 */
@property (nonatomic, weak) UIView *searchHistoryTagsContentView;

/**
 The base table view  of search view controller
 */
@property (nonatomic, strong) UITableView *baseSearchTableView;

/**
 Whether did press suggestion cell
 */
@property (nonatomic, assign) BOOL didClickSuggestionCell;

/**
 The current orientation of device
 */
@property (nonatomic, assign) UIDeviceOrientation currentOrientation;

/**
 The width of cancel button
 */
@property (nonatomic, assign) CGFloat cancelButtonWidth;

@end

@implementation PYSearchViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.currentOrientation != [[UIDevice currentDevice] orientation]) { // orientation changed, reload layout
        self.hotSearches = self.hotSearches;
        self.searchHistories = self.searchHistories;
        self.currentOrientation = [[UIDevice currentDevice] orientation];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self viewDidLayoutSubviews];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isShowLiftBack = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    if (self.cancelButtonWidth == 0) { // Just adapt iOS 11.2
        [self viewDidLayoutSubviews];
    }
    self.navigationController.navigationBar.translucent = YES;
    // Adjust the view according to the `navigationBar.translucent`
    if (NO == self.navigationController.navigationBar.translucent) {
        self.baseSearchTableView.contentInset = UIEdgeInsetsMake(0, 0, self.view.py_y, 0);
        self.searchSuggestionVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame) - self.view.py_y, self.view.py_width, self.view.py_height + self.view.py_y);
        if (!self.navigationController.navigationBar.barTintColor) {
            self.navigationController.navigationBar.barTintColor = PYSEARCH_COLOR(249, 249, 249);
        }
    }
    
    if (NULL == self.searchResultController.parentViewController) {
        [self.searchHeaderView.searchBar becomeFirstResponder];
    } else if (YES == self.showKeyboardWhenReturnSearchResult) {
        [self.searchHeaderView.searchBar becomeFirstResponder];
    }
    if (_searchViewControllerShowMode == PYSearchViewControllerShowModePush) {
        if (self.navigationController.viewControllers.count > 1) {
            _previousInteractivePopGestureRecognizerDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//    [self.searchHeaderView.searchBar resignFirstResponder];
//
//    if (_searchViewControllerShowMode == PYSearchViewControllerShowModePush) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = _previousInteractivePopGestureRecognizerDelegate;
//    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder
{
    PYSearchViewController *searchVC = [[self alloc] init];
    searchVC.hotSearches = hotSearches;
    searchVC.searchBar.placeholder = placeholder;
    return searchVC;
}

+ (instancetype)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder didSearchBlock:(PYDidSearchBlock)block
{
    PYSearchViewController *searchVC = [self searchViewControllerWithHotSearches:hotSearches searchBarPlaceholder:placeholder];
    searchVC.didSearchBlock = [block copy];
    return searchVC;
}

#pragma mark - Lazy
- (UITableView *)baseSearchTableView
{
    if (!_baseSearchTableView) {
        UITableView *baseSearchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KScreenWidth, KScreenHeight-kTopHeight) style:UITableViewStyleGrouped];
        baseSearchTableView.backgroundColor = [UIColor clearColor];
        baseSearchTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if ([baseSearchTableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) { // For the adapter iPad
            baseSearchTableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
        baseSearchTableView.delegate = self;
        baseSearchTableView.dataSource = self;
        [self.view addSubview:baseSearchTableView];
        _baseSearchTableView = baseSearchTableView;
    }
    return _baseSearchTableView;
}

- (PYSearchSuggestionViewController *)searchSuggestionVC
{
    if (!_searchSuggestionVC) {
        PYSearchSuggestionViewController *searchSuggestionVC = [[PYSearchSuggestionViewController alloc] initWithStyle:UITableViewStyleGrouped];
        __weak typeof(self) _weakSelf = self;
        searchSuggestionVC.didSelectCellBlock = ^(UITableViewCell *didSelectCell) {
            __strong typeof(_weakSelf) _weakSelf = _weakSelf;
            _weakSelf.searchHeaderView.searchBar.text = didSelectCell.textLabel.text;
            NSIndexPath *indexPath = [_weakSelf.searchSuggestionVC.tableView indexPathForCell:didSelectCell];
            
            if ([_weakSelf.delegate respondsToSelector:@selector(searchViewController:didSelectSearchSuggestionAtIndexPath:searchBar:)]) {
                [_weakSelf.delegate searchViewController:_weakSelf didSelectSearchSuggestionAtIndexPath:indexPath searchBar:_weakSelf.searchHeaderView.searchBar];
                [_weakSelf saveSearchCacheAndRefreshView];
            } else if ([_weakSelf.delegate respondsToSelector:@selector(searchViewController:didSelectSearchSuggestionAtIndex:searchText:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [_weakSelf.delegate searchViewController:_weakSelf didSelectSearchSuggestionAtIndex:indexPath.row searchText:_weakSelf.searchHeaderView.searchBar.text];
#pragma clang diagnostic pop
                [_weakSelf saveSearchCacheAndRefreshView];
            } else {
                [_weakSelf searchBarSearchButtonClicked:@""];
            }
        };
        searchSuggestionVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), PYScreenW, PYScreenH);
        searchSuggestionVC.view.backgroundColor = self.baseSearchTableView.backgroundColor;
        searchSuggestionVC.view.hidden = YES;
        _searchSuggestionView = (UITableView *)searchSuggestionVC.view;
        searchSuggestionVC.dataSource = self;
        [self.view addSubview:searchSuggestionVC.view];
        [self addChildViewController:searchSuggestionVC];
        _searchSuggestionVC = searchSuggestionVC;
    }
    return _searchSuggestionVC;
}
#pragma mark ========== 清空垃圾箱按钮 ==========
- (UIButton *)emptyButton
{
    if (!_emptyButton) {
        UIButton *emptyButton = [[UIButton alloc] init];
        emptyButton.titleLabel.font = self.searchHistoryHeader.font;
        [emptyButton setTitleColor:PYTextColor forState:UIControlStateNormal];
        [emptyButton setTitle:@"" forState:UIControlStateNormal];
        [emptyButton setImage:[NSBundle py_imageNamed:@"empty"] forState:UIControlStateNormal];
        [emptyButton addTarget:self action:@selector(emptySearchHistoryDidClick) forControlEvents:UIControlEventTouchUpInside];
        [emptyButton sizeToFit];
        emptyButton.py_width += PYSEARCH_MARGIN;
        emptyButton.py_height += PYSEARCH_MARGIN;
        emptyButton.py_centerY = self.searchHistoryHeader.py_centerY;
        emptyButton.py_x = self.searchHistoryView.py_width - emptyButton.py_width;
        emptyButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.searchHistoryView addSubview:emptyButton];
        _emptyButton = emptyButton;
    }
    return _emptyButton;
}

- (UIView *)searchHistoryTagsContentView
{
    if (!_searchHistoryTagsContentView) {
        UIView *searchHistoryTagsContentView = [[UIView alloc] init];
        searchHistoryTagsContentView.py_width = self.searchHistoryView.py_width;
        searchHistoryTagsContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        searchHistoryTagsContentView.py_y = CGRectGetMaxY(self.hotSearchTagsContentView.frame) + PYSEARCH_MARGIN;
        [self.searchHistoryView addSubview:searchHistoryTagsContentView];
        _searchHistoryTagsContentView = searchHistoryTagsContentView;
    }
    return _searchHistoryTagsContentView;
}
#pragma mark ========== 历史记录按钮 ==========
- (UILabel *)searchHistoryHeader
{
    if (!_searchHistoryHeader) {
        UILabel *titleLabel = [self setupTitleLabel:@"历史搜索"];
        
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [self.searchHistoryView addSubview:titleLabel];
        _searchHistoryHeader = titleLabel;
    }
    return _searchHistoryHeader;
}

- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        UIView *searchHistoryView = [[UIView alloc] init];
        searchHistoryView.py_x = self.hotSearchView.py_x;
        searchHistoryView.py_y = self.hotSearchView.py_y;
        searchHistoryView.py_width = self.headerView.py_width - searchHistoryView.py_x * 2;
        searchHistoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.headerView addSubview:searchHistoryView];
        _searchHistoryView = searchHistoryView;
    }
    return _searchHistoryView;
}

- (NSMutableArray *)searchHistories
{
    if (!_searchHistories) {
        _searchHistories = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath]];
    }
    return _searchHistories;
}


- (void)setup
{
    self.isShowLiftBack = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.baseSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    self.hotSearchStyle = PYHotSearchStyleDefault;
    self.searchHistoryStyle = PYHotSearchStyleDefault;
    self.searchResultShowMode = PYSearchResultShowModeDefault;
    self.searchViewControllerShowMode = PYSearchViewControllerShowDefault;
    self.searchSuggestionHidden = NO;
    self.searchHistoriesCachePath = PYSEARCH_SEARCH_HISTORY_CACHE_PATH;
    self.searchHistoriesCount = 20;
    self.showSearchHistory = YES;
    self.showHotSearch = YES;
    self.showSearchResultWhenSearchTextChanged = NO;
    self.showSearchResultWhenSearchBarRefocused = NO;
    self.showKeyboardWhenReturnSearchResult = YES;
    self.removeSpaceOnSearchString = YES;
    self.searchTextField.delegate = self;

    UIView *headerView = [[UIView alloc] init];
    headerView.py_width = PYScreenW;
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *hotSearchView = [[UIView alloc] init];
    hotSearchView.py_x = PYSEARCH_MARGIN * 1.5;
    hotSearchView.py_width = headerView.py_width - hotSearchView.py_x * 2;
    hotSearchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //热门
#pragma mark ========== 热门按钮 ==========

    UILabel *titleLabel = [self setupTitleLabel:@"热门"];
    self.hotSearchHeader = titleLabel;
    titleLabel.textColor = KBlackColor;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [hotSearchView addSubview:titleLabel];
    UIView *hotSearchTagsContentView = [[UIView alloc] init];
    hotSearchTagsContentView.py_width = KScreenWidth;
    hotSearchTagsContentView.py_y = CGRectGetMaxY(titleLabel.frame) + PYSEARCH_MARGIN;
    hotSearchTagsContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [hotSearchView addSubview:hotSearchTagsContentView];
    [headerView addSubview:hotSearchView];
    self.hotSearchTagsContentView = hotSearchTagsContentView;
    self.hotSearchView = hotSearchView;
    self.headerView = headerView;
    self.baseSearchTableView.tableHeaderView = headerView;
//    UIView * lineView = [[UIView alloc] init];
//    lineView.backgroundColor = YXRGBAColor(239, 239, 239);
//    lineView.
    
    
    UIView *footerView = [[UIView alloc] init];
    footerView.py_width = PYScreenW;
    UILabel *emptySearchHistoryLabel = [[UILabel alloc] init];
    emptySearchHistoryLabel.textColor = KDarkGaryColor;
    emptySearchHistoryLabel.font = [UIFont systemFontOfSize:13];
    emptySearchHistoryLabel.userInteractionEnabled = YES;

    emptySearchHistoryLabel.text = [NSBundle py_localizedStringForKey:PYSearchEmptySearchHistoryText];
    emptySearchHistoryLabel.textAlignment = NSTextAlignmentCenter;
    emptySearchHistoryLabel.py_height = 49;
    [emptySearchHistoryLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptySearchHistoryDidClick)]];
    emptySearchHistoryLabel.py_width = footerView.py_width;
    emptySearchHistoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.emptySearchHistoryLabel = emptySearchHistoryLabel;
    [footerView addSubview:emptySearchHistoryLabel];
    footerView.py_height = emptySearchHistoryLabel.py_height;
    self.baseSearchTableView.tableFooterView = footerView;
    
    self.hotSearches = nil;
    [self setNavSearchView];

}

- (UILabel *)setupTitleLabel:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.tag = 1;
    titleLabel.textColor = PYTextColor;
    [titleLabel sizeToFit];
    titleLabel.py_x = 0;
    titleLabel.py_y = 0;
    return titleLabel;
}

- (void)setupHotSearchNormalTags
{
    self.hotSearchTags = [self addAndLayoutTagsWithTagsContentView:self.hotSearchTagsContentView tagTexts:self.hotSearches];
    [self setHotSearchStyle:self.hotSearchStyle];
}

- (void)setupSearchHistoryTags
{
    self.baseSearchTableView.tableFooterView = nil;
    self.searchHistoryTagsContentView.py_y = PYSEARCH_MARGIN;
    self.emptyButton.py_y = self.searchHistoryHeader.py_y - PYSEARCH_MARGIN * 0.5;
    self.searchHistoryTagsContentView.py_y = CGRectGetMaxY(self.emptyButton.frame) + PYSEARCH_MARGIN;
    self.searchHistoryTags = [self addAndLayoutTagsWithTagsContentView:self.searchHistoryTagsContentView tagTexts:[self.searchHistories copy]];
}

- (NSArray *)addAndLayoutTagsWithTagsContentView:(UIView *)contentView tagTexts:(NSArray<NSString *> *)tagTexts;
{
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < tagTexts.count; i++) {
        UILabel *label = [self labelWithTitle:tagTexts[i]];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [contentView addSubview:label];
        [tagsM addObject:label];
    }
    
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    
    for (int i = 0; i < contentView.subviews.count; i++) {
        UILabel *subView = contentView.subviews[i];
        // When the number of search words is too large, the width is width of the contentView
        if (subView.py_width > contentView.py_width) subView.py_width = contentView.py_width;
        if (currentX + subView.py_width + PYSEARCH_MARGIN * countRow > contentView.py_width) {
            subView.py_x = 0;
            subView.py_y = (currentY += subView.py_height) + PYSEARCH_MARGIN * ++countCol;
            currentX = subView.py_width;
            countRow = 1;
        } else {
            subView.py_x = (currentX += subView.py_width) - subView.py_width + PYSEARCH_MARGIN * countRow;
            subView.py_y = currentY + PYSEARCH_MARGIN * countCol;
            countRow ++;
        }
    }
    
    contentView.py_height = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    if (self.hotSearchTagsContentView == contentView) { // popular search tag
        self.hotSearchView.py_height = CGRectGetMaxY(contentView.frame) + PYSEARCH_MARGIN * 2;
    } else if (self.searchHistoryTagsContentView == contentView) { // search history tag
        self.searchHistoryView.py_height = CGRectGetMaxY(contentView.frame) + PYSEARCH_MARGIN * 2;
    }
    
    [self layoutForDemand];
    self.baseSearchTableView.tableHeaderView.py_height = self.headerView.py_height = MAX(CGRectGetMaxY(self.hotSearchView.frame), CGRectGetMaxY(self.searchHistoryView.frame));
    self.baseSearchTableView.tableHeaderView.hidden = NO;
    
    // Note：When the operating system for the iOS 9.x series tableHeaderView height settings are invalid, you need to reset the tableHeaderView
    [self.baseSearchTableView setTableHeaderView:self.baseSearchTableView.tableHeaderView];
    return [tagsM copy];
}

- (void)layoutForDemand {
    if (NO == self.swapHotSeachWithSearchHistory) {
        self.hotSearchView.py_y = PYSEARCH_MARGIN * 2;
        self.searchHistoryView.py_y = self.hotSearches.count > 0 && self.showHotSearch ? CGRectGetMaxY(self.hotSearchView.frame) : PYSEARCH_MARGIN * 1.5;
    } else { // swap popular search whith search history
        self.searchHistoryView.py_y = PYSEARCH_MARGIN * 1.5;
        self.hotSearchView.py_y = self.searchHistories.count > 0 && self.showSearchHistory ? CGRectGetMaxY(self.searchHistoryView.frame) : PYSEARCH_MARGIN * 2;
    }
}

#pragma mark - setter
- (void)setRankTextLabels:(NSArray<UILabel *> *)rankTextLabels
{
    // popular search tagLabel's tag is 1, search history tagLabel's tag is 0.
    for (UILabel *rankLabel in rankTextLabels) {
        rankLabel.tag = 1;
    }
    _rankTextLabels= rankTextLabels;
}

- (void)setSearchBarCornerRadius:(CGFloat)searchBarCornerRadius
{
    _searchBarCornerRadius = searchBarCornerRadius;
    
    for (UIView *subView in self.searchTextField.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"_UISearchBarSearchFieldBackgroundView"]) {
            subView.layer.cornerRadius = searchBarCornerRadius;
            subView.clipsToBounds = YES;
            break;
        }
    }
}

- (void)setSwapHotSeachWithSearchHistory:(BOOL)swapHotSeachWithSearchHistory
{
    _swapHotSeachWithSearchHistory = swapHotSeachWithSearchHistory;
    
    self.hotSearches = self.hotSearches;
    self.searchHistories = self.searchHistories;
}

- (void)setHotSearchTitle:(NSString *)hotSearchTitle
{
    _hotSearchTitle = [hotSearchTitle copy];
    
    self.hotSearchHeader.text = _hotSearchTitle;
}

- (void)setSearchHistoryTitle:(NSString *)searchHistoryTitle
{
    _searchHistoryTitle = [searchHistoryTitle copy];
    
    if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
        [self.baseSearchTableView reloadData];
    } else {
        self.searchHistoryHeader.text = _searchHistoryTitle;
    }
}

- (void)setShowSearchResultWhenSearchTextChanged:(BOOL)showSearchResultWhenSearchTextChanged
{
    _showSearchResultWhenSearchTextChanged = showSearchResultWhenSearchTextChanged;
    
    if (YES == _showSearchResultWhenSearchTextChanged) {
        self.searchSuggestionHidden = YES;
    }
}

- (void)setShowHotSearch:(BOOL)showHotSearch
{
    _showHotSearch = showHotSearch;
    
    [self setHotSearches:self.hotSearches];
    [self setSearchHistoryStyle:self.searchHistoryStyle];
}

- (void)setShowSearchHistory:(BOOL)showSearchHistory
{
    _showSearchHistory = showSearchHistory;
    
    [self setHotSearches:self.hotSearches];
    [self setSearchHistoryStyle:self.searchHistoryStyle];
}

- (void)setCancelBarButtonItem:(UIBarButtonItem *)cancelBarButtonItem
{
//    _cancelBarButtonItem = cancelBarButtonItem;
//    self.navigationItem.rightBarButtonItem = cancelBarButtonItem;
}

- (void)setCancelButton:(UIButton *)cancelButton
{
//    _cancelButton = cancelButton;
//    self.navigationItem.rightBarButtonItem.customView = cancelButton;
}

- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath
{
    _searchHistoriesCachePath = [searchHistoriesCachePath copy];
    
    self.searchHistories = nil;
    if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
        [self.baseSearchTableView reloadData];
    } else {
        [self setSearchHistoryStyle:self.searchHistoryStyle];
    }
}

- (void)setHotSearchTags:(NSArray<UILabel *> *)hotSearchTags
{
    // popular search tagLabel's tag is 1, search history tagLabel's tag is 0.
    for (UILabel *tagLabel in hotSearchTags) {
        tagLabel.tag = 1;
    }
    _hotSearchTags = hotSearchTags;
}

- (void)setSearchBarBackgroundColor:(UIColor *)searchBarBackgroundColor
{
    _searchBarBackgroundColor = searchBarBackgroundColor;
    _searchTextField.backgroundColor = searchBarBackgroundColor;
}

- (void)setSearchSuggestions:(NSArray<NSString *> *)searchSuggestions
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:cellForRowAtIndexPath:)]) {
        // set searchSuggestion is nil when cell of suggestion view is custom.
        _searchSuggestions = nil;
        return;
    }
    
    _searchSuggestions = [searchSuggestions copy];
    self.searchSuggestionVC.searchSuggestions = [searchSuggestions copy];
    
    self.baseSearchTableView.hidden = !self.searchSuggestionHidden && [self.searchSuggestionVC.tableView numberOfRowsInSection:0];
    self.searchSuggestionVC.view.hidden = self.searchSuggestionHidden || ![self.searchSuggestionVC.tableView numberOfRowsInSection:0];
}

- (void)setRankTagBackgroundColorHexStrings:(NSArray<NSString *> *)rankTagBackgroundColorHexStrings
{
    if (rankTagBackgroundColorHexStrings.count < 4) {
        NSArray *colorStrings = @[@"#f14230", @"#ff8000", @"#ffcc01", @"#ebebeb"];
        _rankTagBackgroundColorHexStrings = colorStrings;
    } else {
        _rankTagBackgroundColorHexStrings = @[rankTagBackgroundColorHexStrings[0], rankTagBackgroundColorHexStrings[1], rankTagBackgroundColorHexStrings[2], rankTagBackgroundColorHexStrings[3]];
    }
    
    self.hotSearches = self.hotSearches;
}

- (void)setHotSearches:(NSArray *)hotSearches
{
    _hotSearches = hotSearches;
    if (0 == hotSearches.count || !self.showHotSearch) {
        self.hotSearchHeader.hidden = YES;
        self.hotSearchTagsContentView.hidden = YES;
        if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
            UIView *tableHeaderView = self.baseSearchTableView.tableHeaderView;
            tableHeaderView.py_height = PYSEARCH_MARGIN * 1.5;
            [self.baseSearchTableView setTableHeaderView:tableHeaderView];
        }
        return;
    };
    
    self.baseSearchTableView.tableHeaderView.hidden = NO;
    self.hotSearchHeader.hidden = NO;
    self.hotSearchTagsContentView.hidden = NO;
    if (PYHotSearchStyleDefault == self.hotSearchStyle
        || PYHotSearchStyleColorfulTag == self.hotSearchStyle
        || PYHotSearchStyleBorderTag == self.hotSearchStyle
        || PYHotSearchStyleARCBorderTag == self.hotSearchStyle) {
        [self setupHotSearchNormalTags];
    } else if (PYHotSearchStyleRankTag == self.hotSearchStyle) {

    } else if (PYHotSearchStyleRectangleTag == self.hotSearchStyle) {

    }
    [self setSearchHistoryStyle:self.searchHistoryStyle];
}

- (void)setSearchHistoryStyle:(PYSearchHistoryStyle)searchHistoryStyle
{
    _searchHistoryStyle = searchHistoryStyle;
    
//    if (!self.searchHistories.count || !self.showSearchHistory || UISearchBarStyleDefault == searchHistoryStyle) {
//        self.searchHistoryHeader.hidden = YES;
//        self.searchHistoryTagsContentView.hidden = YES;
//        self.searchHistoryView.hidden = YES;
//        self.emptyButton.hidden = YES;
//        return;
//    };
    
    self.searchHistoryHeader.hidden = NO;
    self.searchHistoryTagsContentView.hidden = NO;
    self.searchHistoryView.hidden = NO;
    self.emptyButton.hidden = NO;
    [self setupSearchHistoryTags];
    
    switch (searchHistoryStyle) {
        case PYSearchHistoryStyleColorfulTag:
            for (UILabel *tag in self.searchHistoryTags) {
                tag.textColor = [UIColor whiteColor];
                tag.layer.borderColor = nil;
                tag.layer.borderWidth = 0.0;
                tag.backgroundColor = PYSEARCH_COLORPolRandomColor;
            }
            break;
        case PYSearchHistoryStyleBorderTag:
            for (UILabel *tag in self.searchHistoryTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = PYSEARCH_COLOR(223, 223, 223).CGColor;
                tag.layer.borderWidth = 0.5;
            }
            break;
        case PYSearchHistoryStyleARCBorderTag:
            for (UILabel *tag in self.searchHistoryTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = PYSEARCH_COLOR(223, 223, 223).CGColor;
                tag.layer.borderWidth = 0.5;
                tag.layer.cornerRadius = tag.py_height * 0.5;
            }
            break;
        default:
            break;
    }
}

- (void)setHotSearchStyle:(PYHotSearchStyle)hotSearchStyle
{
    _hotSearchStyle = hotSearchStyle;
    
    switch (hotSearchStyle) {
        case PYHotSearchStyleColorfulTag:
            for (UILabel *tag in self.hotSearchTags) {
                tag.textColor = [UIColor whiteColor];
                tag.layer.borderColor = nil;
                tag.layer.borderWidth = 0.0;
                tag.backgroundColor = PYSEARCH_COLORPolRandomColor;
            }
            break;
        case PYHotSearchStyleBorderTag:
            for (UILabel *tag in self.hotSearchTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = PYSEARCH_COLOR(223, 223, 223).CGColor;
                tag.layer.borderWidth = 0.5;
            }
            break;
        case PYHotSearchStyleARCBorderTag:
            for (UILabel *tag in self.hotSearchTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = PYSEARCH_COLOR(223, 223, 223).CGColor;
                tag.layer.borderWidth = 0.5;
                tag.layer.cornerRadius = tag.py_height * 0.5;
            }
            break;
        case PYHotSearchStyleRectangleTag:
            self.hotSearches = self.hotSearches;
            break;
        case PYHotSearchStyleRankTag:
            self.rankTagBackgroundColorHexStrings = nil;
            break;
            
        default:
            break;
    }
}

- (void)setSearchViewControllerShowMode:(PYSearchViewControllerShowMode)searchViewControllerShowMode
{
    _searchViewControllerShowMode = searchViewControllerShowMode;
    if (_searchViewControllerShowMode == PYSearchViewControllerShowModeModal) { // modal
//        self.navigationItem.rightBarButtonItem = _cancelBarButtonItem;
//        self.navigationItem.leftBarButtonItem = nil;
    } else if (_searchViewControllerShowMode == PYSearchViewControllerShowModePush) { // push
//        self.navigationItem.hidesBackButton = YES;
//        self.navigationItem.leftBarButtonItem = _backBarButtonItem;
//        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)cancelDidClick{
    [self.searchHeaderView.searchBar resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(didClickCancel:)]) {
        [self.delegate didClickCancel:self];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backDidClick
{
    [self.searchHeaderView.searchBar resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(didClickBack:)]) {
        [self.delegate didClickBack:self];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardDidShow:(NSNotification *)noti
{
    NSDictionary *info = noti.userInfo;
    self.keyboardHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardShowing = YES;
    // Adjust the content inset of suggestion view
    self.searchSuggestionVC.tableView.contentInset = UIEdgeInsetsMake(-30, 0, self.keyboardHeight + 30, 0);
}


- (void)emptySearchHistoryDidClick
{
    [self.searchHistories removeAllObjects];
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
        [self.baseSearchTableView reloadData];
    } else {
        self.searchHistoryStyle = self.searchHistoryStyle;
    }
    if (YES == self.swapHotSeachWithSearchHistory) {
        self.hotSearches = self.hotSearches;
    }
    PYSEARCH_LOG(@"%@", [NSBundle py_localizedStringForKey:PYSearchEmptySearchHistoryLogText]);
}

- (void)tagDidCLick:(UITapGestureRecognizer *)gr
{
    UILabel *label = (UILabel *)gr.view;
    self.searchHeaderView.searchBar.text = label.text;
    // popular search tagLabel's tag is 1, search history tagLabel's tag is 0.
    if (1 == label.tag) {
        if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectHotSearchAtIndex:searchText:)]) {
            [self.delegate searchViewController:self didSelectHotSearchAtIndex:[self.hotSearchTags indexOfObject:label] searchText:label.text];
            [self saveSearchCacheAndRefreshView];
        } else {
            [self searchBarSearchButtonClicked:label.text];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchHistoryAtIndex:searchText:)]) {
            [self.delegate searchViewController:self didSelectSearchHistoryAtIndex:[self.searchHistoryTags indexOfObject:label] searchText:label.text];
            [self saveSearchCacheAndRefreshView];
        } else {
            [self searchBarSearchButtonClicked:label.text];
        }
    }
    PYSEARCH_LOG(@"Search %@", label.text);
}

- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:14];
    label.text = title;
    label.textColor = [UIColor py_colorWithHexString:@"#444444"];
    label.backgroundColor = [UIColor py_colorWithHexString:@"#F5F5F5"];
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.py_width += 20;
    label.py_height += 14;
    return label;
}

- (void)saveSearchCacheAndRefreshView
{
    UISearchBar *searchBar = self.searchHeaderView.searchBar;
    [searchBar resignFirstResponder];
    NSString *searchText = searchBar.text;
    if (self.removeSpaceOnSearchString) { // remove sapce on search string
        searchText = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if (self.showSearchHistory && searchText.length > 0) {
        [self.searchHistories removeObject:searchText];
        [self.searchHistories insertObject:searchText atIndex:0];
        
        if (self.searchHistories.count > self.searchHistoriesCount) {
            [self.searchHistories removeLastObject];
        }
        [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
        
        if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
            [self.baseSearchTableView reloadData];
        } else {
            self.searchHistoryStyle = self.searchHistoryStyle;
        }
    }
    
    [self handleSearchResultShow];
}

- (void)handleSearchResultShow
{
    switch (self.searchResultShowMode) {
        case PYSearchResultShowModePush:
            self.searchResultController.view.hidden = YES;
            [self.navigationController pushViewController:self.searchResultController animated:YES];
            break;
        case PYSearchResultShowModeEmbed:
            if (self.searchResultController) {
                [self.view addSubview:self.searchResultController.view];
                [self addChildViewController:self.searchResultController];
                self.searchResultController.view.hidden = NO;
                self.searchResultController.view.py_y = NO == self.navigationController.navigationBar.translucent ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
                self.searchResultController.view.py_height = self.view.py_height - self.searchResultController.view.py_y;
                self.searchSuggestionVC.view.hidden = YES;
            } else {
                PYSEARCH_LOG(@"PYSearchDebug： searchResultController cannot be nil when searchResultShowMode is PYSearchResultShowModeEmbed.");
            }
            break;
        case PYSearchResultShowModeCustom:
            
            break;
        default:
            break;
    }
}

#pragma mark - PYSearchSuggestionViewDataSource
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInSearchSuggestionView:)]) {
        return [self.dataSource numberOfSectionsInSearchSuggestionView:searchSuggestionView];
    }
    return 1;
}

- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:numberOfRowsInSection:)]) {
        NSInteger numberOfRow = [self.dataSource searchSuggestionView:searchSuggestionView numberOfRowsInSection:section];
        searchSuggestionView.hidden = self.searchSuggestionHidden || !self.searchHeaderView.searchBar.text.length || 0 == numberOfRow;
        self.baseSearchTableView.hidden = !searchSuggestionView.hidden;
        return numberOfRow;
    }
    return self.searchSuggestions.count;
}

- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:cellForRowAtIndexPath:)]) {
        return [self.dataSource searchSuggestionView:searchSuggestionView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:heightForRowAtIndexPath:)]) {
        return [self.dataSource searchSuggestionView:searchSuggestionView heightForRowAtIndexPath:indexPath];
    }
    return 44.0;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSearchWithSearchBar:searchText:)]) {
        [self.delegate searchViewController:self didSearchWithSearchBar:self.searchHeaderView.searchBar searchText:textField.text];
        [self saveSearchCacheAndRefreshView];
        return YES;
    }
    if (self.didSearchBlock) self.didSearchBlock(self, self.searchHeaderView.searchBar,textField.text);
    [self saveSearchCacheAndRefreshView];
    return YES;
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSearchWithSearchBar:searchText:)]) {
        [self.delegate searchViewController:self didSearchWithSearchBar:_searchBar searchText:string];
        [self saveSearchCacheAndRefreshView];
        return;
    }
    if (self.didSearchBlock) self.didSearchBlock(self, self.searchHeaderView.searchBar,string);
    [self saveSearchCacheAndRefreshView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (PYSearchResultShowModeEmbed == self.searchResultShowMode && self.showSearchResultWhenSearchTextChanged) {
        [self handleSearchResultShow];
        self.searchResultController.view.hidden = 0 == searchText.length;
    } else if (self.searchResultController) {
        self.searchResultController.view.hidden = YES;
    }
    self.baseSearchTableView.hidden = searchText.length && !self.searchSuggestionHidden && [self.searchSuggestionVC.tableView numberOfRowsInSection:0];
    self.searchSuggestionVC.view.hidden = self.searchSuggestionHidden || !searchText.length || ![self.searchSuggestionVC.tableView numberOfRowsInSection:0];
    if (self.searchSuggestionVC.view.hidden) {
        self.searchSuggestions = nil;
    }
    [self.view bringSubviewToFront:self.searchSuggestionVC.view];
    if ([self.delegate respondsToSelector:@selector(searchViewController:searchTextDidChange:searchText:)]) {
        [self.delegate searchViewController:self searchTextDidChange:searchBar searchText:searchText];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (PYSearchResultShowModeEmbed == self.searchResultShowMode) {
        self.searchResultController.view.hidden = 0 == searchBar.text.length || !self.showSearchResultWhenSearchBarRefocused;
        self.searchSuggestionVC.view.hidden = self.searchSuggestionHidden || !searchBar.text.length || ![self.searchSuggestionVC.tableView numberOfRowsInSection:0];
        if (self.searchSuggestionVC.view.hidden) {
            self.searchSuggestions = nil;
        }
        self.baseSearchTableView.hidden = searchBar.text.length && !self.searchSuggestionHidden && ![self.searchSuggestionVC.tableView numberOfRowsInSection:0];
    }
    [self setSearchSuggestions:self.searchSuggestions];
    return YES;
}

- (void)closeDidClick:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    [self.searchHistories removeObject:cell.textLabel.text];
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    [self.baseSearchTableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.baseSearchTableView.tableFooterView.hidden = 0 == self.searchHistories.count || !self.showSearchHistory;
    return self.showSearchHistory && PYSearchHistoryStyleCell == self.searchHistoryStyle ? self.searchHistories.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PYSearchHistoryCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = PYTextColor;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.backgroundColor = [UIColor clearColor];
        
        UIButton *closetButton = [[UIButton alloc] init];
        closetButton.py_size = CGSizeMake(cell.py_height, cell.py_height);
        [closetButton setImage:[NSBundle py_imageNamed:@"close"] forState:UIControlStateNormal];
        UIImageView *closeView = [[UIImageView alloc] initWithImage:[NSBundle py_imageNamed:@"close"]];
        [closetButton addTarget:self action:@selector(closeDidClick:) forControlEvents:UIControlEventTouchUpInside];
        closeView.contentMode = UIViewContentModeCenter;
        cell.accessoryView = closetButton;
        UIImageView *line = [[UIImageView alloc] initWithImage:[NSBundle py_imageNamed:@"cell-content-line"]];
        line.py_height = 0.5;
        line.alpha = 0.7;
        line.py_x = PYSEARCH_MARGIN;
        line.py_y = 43;
        line.py_width = tableView.py_width;
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:line];
    }
        cell.imageView.image = [NSBundle py_imageNamed:@"search_history"];
        cell.textLabel.text = self.searchHistories[indexPath.row];


    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.showSearchHistory && self.searchHistories.count && PYSearchHistoryStyleCell == self.searchHistoryStyle ? (self.searchHistoryTitle.length ? self.searchHistoryTitle : [NSBundle py_localizedStringForKey:PYSearchSearchHistoryText]) : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.searchHistories.count && self.showSearchHistory && PYSearchHistoryStyleCell == self.searchHistoryStyle ? 25 : 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchHeaderView.searchBar.text = cell.textLabel.text;
    
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchHistoryAtIndex:searchText:)]) {
        [self.delegate searchViewController:self didSelectSearchHistoryAtIndex:indexPath.row searchText:cell.textLabel.text];
        [self saveSearchCacheAndRefreshView];
    } else {
        [self searchBarSearchButtonClicked:@""];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.keyboardShowing) {
        // Adjust the content inset of suggestion view
        self.searchSuggestionVC.tableView.contentInset = UIEdgeInsetsMake(-30, 0, 30, 0);
        [self.searchHeaderView.searchBar resignFirstResponder];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    return self.navigationController.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
{
    return self.navigationController.viewControllers.count > 1;
}

@end
