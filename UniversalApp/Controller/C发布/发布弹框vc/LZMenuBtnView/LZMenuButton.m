//
//  LZMenuButton.m
//  Case
//
//  Created by 栗子 on 2018/6/13.
//  Copyright © 2018年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import "LZMenuButton.h"
#import "LZMenuButtonCell.h"
//#import "ToolClass.h"

@interface LZMenuButton()

@property(nonatomic,strong)UIImage *effectImage;

@end

CGFloat animationTime = 0.55;
CGFloat rowHeight = 58.f;
NSInteger noOfRows = 0;
NSInteger tappedRow;
CGFloat previousOffset;
CGFloat buttonToScreenHeight;


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


@implementation LZMenuButton

-(id)initWithFrame:(CGRect)frame normalImage:(UIImage*)passiveImage andPressedImage:(UIImage*)activeImage withScrollview:(UIScrollView*)scrView effectImage:(UIImage *)effect menuWidth:(CGFloat)w{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.windowView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.windowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.mainWindow = [UIApplication sharedApplication].keyWindow;
        self.buttonView = [[UIView alloc]initWithFrame:frame];
        self.buttonView.backgroundColor = [UIColor clearColor];
        self.buttonView.userInteractionEnabled = YES;
        
        buttonToScreenHeight = SCREEN_HEIGHT - CGRectGetMaxY(self.frame);
        
        CGFloat X = CGRectGetMaxX(self.frame) - (self.frame.size.width/2) + (w/2) - 148;
        self.menuTable = [[UITableView alloc]initWithFrame:CGRectMake(X, 0, 148,SCREEN_HEIGHT - (SCREEN_HEIGHT - CGRectGetMaxY(self.frame)) )];
        self.menuTable.scrollEnabled = NO;
        self.menuTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, CGRectGetHeight(frame))];
        self.menuTable.delegate = self;
        self.menuTable.dataSource = self;
        self.menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.menuTable.backgroundColor = [UIColor clearColor];
        self.menuTable.transform = CGAffineTransformMakeRotation(-M_PI); //Rotate the table
        
        previousOffset = scrView.contentOffset.y;
        
        self.bgScroller = scrView;
        self.pressedImage = activeImage;
        self.normalImage = passiveImage;
        self.effectImage = effect;
        [self setupButton];
        
    }
    return self;
}
-(void)setHideWhileScrolling:(BOOL)hideWhileScrolling
{
    if (self.bgScroller!=nil)
    {
        _hideWhileScrolling = hideWhileScrolling;
        if (hideWhileScrolling)
        {
            [self.bgScroller addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}



-(void) setupButton
{
    _isMenuVisible = false;
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *buttonTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:buttonTap];
    
    UITapGestureRecognizer *buttonTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [_buttonView addGestureRecognizer:buttonTap3];
    
    self.bgView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.image =self.effectImage;
    self.bgView.userInteractionEnabled = YES;
//    [ToolClass blurEffect:self.bgView];
   
    UITapGestureRecognizer *buttonTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    buttonTap2.cancelsTouchesInView = NO;
    [self.bgView addGestureRecognizer:buttonTap2];
    
    
    self.normalImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.normalImageView.userInteractionEnabled = YES;
    self.normalImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.normalImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.normalImageView.layer.shadowRadius = 5.f;
    self.normalImageView.layer.shadowOffset = CGSizeMake(-10, -10);
    
    
    
    self.pressedImageView  = [[UIImageView alloc]initWithFrame:self.bounds];
    self.pressedImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.pressedImageView.userInteractionEnabled = YES;
    
    
    self.normalImageView.image = _normalImage;
    self.pressedImageView.image = _pressedImage;
    
    [self.bgView addSubview:self.menuTable];
    [self.buttonView addSubview:self.pressedImageView];
    [self.buttonView addSubview:self.normalImageView];
    [self addSubview:self.normalImageView];
    
}

-(void)handleTap:(id)sender //Show Menu
{
    if (self.isMenuVisible)
    {
        
        [self dismissMenu:nil];
    }
    else
    {
        [self.windowView addSubview:self.bgView];
        [self.windowView addSubview:self.buttonView];
        
        [_mainWindow addSubview:self.windowView];
        [self showMenu:nil];
    }
    self.isMenuVisible  = !self.isMenuVisible;
    
    
}




#pragma mark -- Animations
#pragma mark ---- button tap Animations

-(void) showMenu:(id)sender
{
    
    self.pressedImageView.transform = CGAffineTransformMakeRotation(M_PI);
    self.pressedImageView.alpha = 0.0; //0.3
    [UIView animateWithDuration:animationTime/2 animations:^
     {
         self.bgView.alpha = 1;
         self.normalImageView.transform = CGAffineTransformMakeRotation(-M_PI);
         self.normalImageView.alpha = 0.0; //0.7
         self.pressedImageView.transform = CGAffineTransformIdentity;
         self.pressedImageView.alpha = 1;
         noOfRows = self.labelArray.count;
         [self.menuTable reloadData];
         
     }completion:^(BOOL finished){
     }];
    
}

-(void) dismissMenu:(id) sender

{
    [UIView animateWithDuration:animationTime/2 animations:^
     {
         self.bgView.alpha = 0;
         self.pressedImageView.alpha = 0.f;
         self.pressedImageView.transform = CGAffineTransformMakeRotation(-M_PI);
         self.normalImageView.transform = CGAffineTransformMakeRotation(0);
         self.normalImageView.alpha = 1.f;
     } completion:^(BOOL finished)
     {
         noOfRows = 0;
         [self.bgView removeFromSuperview];
         [self.windowView removeFromSuperview];
         [self.mainWindow removeFromSuperview];
         
     }];
}

#pragma mark ---- Scroll animations

-(void) showMenuDuringScroll:(BOOL) shouldShow
{
    if (self.hideWhileScrolling)
    {
        
        if (!shouldShow)
        {
            [UIView animateWithDuration:animationTime animations:^
             {
                 self.transform = CGAffineTransformMakeTranslation(0, buttonToScreenHeight*6);
             } completion:nil];
        }
        else
        {
            [UIView animateWithDuration:animationTime/2 animations:^
             {
                 self.transform = CGAffineTransformIdentity;
             } completion:nil];
        }
    }
}


-(void) addRows
{
    NSMutableArray *ip = [[NSMutableArray alloc]init];
    for (int i = 0; i< noOfRows; i++)
    {
        [ip addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [_menuTable insertRowsAtIndexPaths:ip withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -- Observer for scrolling
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        
        CGFloat diff = previousOffset - _bgScroller.contentOffset.y;
        
        if (ABS(diff) > 15)
        {
            if (_bgScroller.contentOffset.y > 0)
            {
                [self showMenuDuringScroll:(previousOffset > _bgScroller.contentOffset.y)];
                previousOffset = _bgScroller.contentOffset.y;
            }
            else
            {
                [self showMenuDuringScroll:YES];
            }
        }
        
    }
}


#pragma mark -- Tableview methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return noOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(LZMenuButtonCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    double delay = (indexPath.row*indexPath.row) * 0.004;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.95, 0.95);
    CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(0,-(indexPath.row+1)*CGRectGetHeight(cell.nameImv.frame));
    cell.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
    cell.alpha = 0.f;
    
    [UIView animateWithDuration:animationTime/2 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         cell.transform = CGAffineTransformIdentity;
         cell.alpha = 1.f;
         
     } completion:^(BOOL finished)
     {
         
     }];
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    LZMenuButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        [_menuTable registerNib:[UINib nibWithNibName:@"LZMenuButtonCell" bundle:nil]forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.nameImv.image = IMAGE_NAMED(_imageArray[indexPath.row]);
    cell.nameLB.text    = [_labelArray objectAtIndex:indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate didSelectMenuOptionAtIndex:indexPath.row];
    
}



@end
