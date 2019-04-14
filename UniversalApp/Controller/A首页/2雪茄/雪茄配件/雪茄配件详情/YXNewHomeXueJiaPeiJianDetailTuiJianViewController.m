//
//  YXNewHomeXueJiaPeiJianDetailTuiJianViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/4/14.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXNewHomeXueJiaPeiJianDetailTuiJianViewController.h"
#import "YXHomeXueJiaDetailTableViewCell.h"
#import "CatZanButton.h"
#import "YXHomeXueJiaPinPaiLastDetailViewController.h"
#import "YXPublishFootViewController.h"
#import "POPAnimation.h"
#import "CBSegmentView.h"
#import "YXHomeXueJiaTableViewCell.h"
@interface YXNewHomeXueJiaPeiJianDetailTuiJianViewController ()<ClickLikeBtnDelegate,UIWebViewDelegate>{
    UIImage * _selImage;
    UIImage * _unImage;
    CGFloat section0Height;
    CGFloat tagHeight;
    CGFloat stringHeight;
    NSMutableArray * typeArray;
}
@end

@implementation YXNewHomeXueJiaPeiJianDetailTuiJianViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self addUI];
    
    [self setSpace];
    
    [self initData];
    
    [self requestInfo];
    
}
-(void)addUI{
    self.dataArray = [[NSMutableArray alloc]init];
    typeArray = [[NSMutableArray alloc]init];
    kWeakSelf(self);
    [YX_MANAGER requestGetCigar_accessories_type:kGetString(self.dicStartData[@"id"]) success:^(id object) {
        if ([object count] > 0) {
            [typeArray removeAllObjects];
            [typeArray addObjectsFromArray:object];
            NSMutableArray * names = [NSMutableArray array];
            for (NSDictionary * dic in object) {
                [names addObject:kGetString(dic[@"type"])];
            }
            weakself.segIndex = kGetString(object[0][@"id"]);
            [weakself requestInfo];
            CBSegmentView *sliderSegmentView = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            [weakself.segmentView addSubview:sliderSegmentView];
            [sliderSegmentView setTitleArray:names withStyle:CBSegmentStyleSlider];
            sliderSegmentView.titleChooseReturn = ^(NSInteger x) {
                weakself.segIndex = kGetString(typeArray[x][@"id"]);
                [weakself requestInfo];
            };
        }
  
    }];
}
-(void)setSpace{


    
    
    NSDictionary * cellData = self.dicStartData;
    
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[cellData[@"intro"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    self.section1TextView.attributedText = attributedString;
    
    
    
    self.webView.delegate = self;
    //获取bundlePath 路径
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    //获取本地html目录 basePath
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",bundlePath,@"html"];
    //获取本地html目录 baseUrl
    NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
    //显示内容
    if (cellData[@"intro"]) {
        [self.webView loadHTMLString:[self adaptWebViewForHtml:cellData[@"intro"]] baseURL: baseUrl];
        
    }
    
}
- (void)webViewDidFinishLoad:(UIWebView *)wb{
    tagHeight = [[wb stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    [self.tableView reloadData];
}
//HTML适配图片文字
- (NSString *)adaptWebViewForHtml:(NSString *) htmlStr{
    
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    
    [headHtml appendString : @"<head>" ];
    
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
    
    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    
    //适配图片宽度，让图片宽度最大等于屏幕宽度
    //    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];
    
    
    //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '100%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    return bodyHtml;
    
}

-(void)initData{
    NSDictionary * cellData = self.dicStartData;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaTableViewCell"];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法
    
    
    
    _selImage = [UIImage imageNamed:@"Zan"];
    _unImage = [UIImage imageNamed:@"UnZan"];
    
    self.title = cellData[@"brand_name"];
    
    
    NSString * str = [(NSMutableString *)cellData[@"brand_logo"] replaceAll:@" " target:@"%20"];
    [self.section1ImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.section1ImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.section1TextView.text = kGetString(cellData[@"intro"]);
    self.section1TitleLbl.text = [NSString stringWithFormat:@"%@",cellData[@"brand_name"]];
    
}

-(void)setguanzhu{
    
    
}


//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){//
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return self.dataArray.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        NSDictionary * cellData = self.dataArray[indexPath.row];
        static NSString *identify = @"YXHomeXueJiaTableViewCell";
        YXHomeXueJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        NSString * url = [cellData[@"photo_list"] count] > 0 ? cellData[@"photo_list"][0][@"photo"] : @"";
        NSString * str = [(NSMutableString *)url replaceAll:@" " target:@"%20"];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        
        cell.cellLbl.text = cellData[@"name"];
        NSString * strprice = [NSString stringWithFormat:@"%@:%@",kGetString(cellData[@"price_a"]),kGetString(cellData[@"price_a"])];
        cell.cellAutherLbl.text = strprice;
        cell.cellImageView.layer.masksToBounds = YES;
        cell.cellImageView.layer.cornerRadius = 3;
        cell.cellDataLbl.hidden = YES;
        cell.cellLbl.hidden = cell.cellAutherLbl.hidden = cell.cellDataLbl.hidden = NO;

        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
        if (self.whereCome) {
            return 0;
        }else{
            return  [self.openBtn.titleLabel.text isEqualToString:@"↑ 收起"]  ? 460-120+tagHeight + 22  : 460 ;
        }
        
    }else{
        //yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
        return 100;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        kWeakSelf(self);
            UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
            YXHomeXueJiaPinPaiLastDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiLastDetailViewController"];
            VC.startDic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
            
            //请求六宫格图片
            NSString * tag = VC.startDic[@"cigar_name"];
            [YX_MANAGER requestGetDetailListPOST:@{@"type":@(0),@"tag":tag,@"page":@(1)} success:^(id object) {
                NSMutableArray * imageArray = [NSMutableArray array];
                for (NSDictionary * dic in object) {
                    [imageArray addObject:dic[@"photo1"]];
                }
                [VC.startDic setValue:self.title forKey:@"cigar_brand"];
                VC.imageArray = [NSMutableArray arrayWithArray:imageArray];
                [weakself.navigationController pushViewController:VC animated:YES];
            }];
    }
}
-(void)requestLiuGongGe{
    
}
#pragma mark ========== 点赞按钮 ==========
-(void)clickLikeBtn:(BOOL)isZan cigar_id:(NSString *)cigar_id likeBtn:(nonnull UIButton *)likeBtn{
    kWeakSelf(self);
    if ([userManager loadUserInfo]) {
        [YX_MANAGER requestCollect_cigarPOST:@{@"cigar_id":cigar_id} success:^(id object) {
            [likeBtn setBackgroundImage:isZan ? _selImage:_unImage forState:UIControlStateNormal];
        }];
    }else{
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
}
#pragma mark ========== 重新请求详情 ==========
-(void)requestInfo{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@/%@",self.segIndex,NSIntegerToNSString(self.requestPage),self.dicStartData[@"brand_name"]];
    par = [par replaceAll:@" " target:@"%20"];
    [YX_MANAGER requestCigar_accessoriesGET:par success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.tableView reloadData];
    }];
    
//    kWeakSelf(self);
//    [YX_MANAGER requestCigar_brand_detailsPOST:@{@"cigar_brand_id":kGetString(self.dicStartData[@"id"])} success:^(id object) {
//        weakself.dicData = [NSMutableDictionary dictionaryWithDictionary:object];
//        [weakself.tableView reloadData];
//        weakself.section1countLbl.text = [kGetString(self.dicData[@"concern_number"]) append:@" 人关注"];
//        BOOL isGuanZhu = [self.dicData[@"is_concern"] integerValue] == 1;
//        [ShareManager setGuanZhuStatus:self.section1GuanZhuBtn status:!isGuanZhu alertView:YES];
//    }];
}


- (IBAction)openAction:(id)sender {
    if ([self.openBtn.titleLabel.text isEqualToString:@"↓ 展开"]) {
        //        self.textViewHeight.constant =  stringHeight ;
        //        section0Height =  tagHeight - 120 + 20 + stringHeight ;
        self.zhushiHeight.constant = 22;
        self.textViewHeight.constant = tagHeight;
        [self.openBtn setTitle:@"↑ 收起" forState:UIControlStateNormal];
        
    }else{
        //        self.textViewHeight.constant = stringHeight  > 120 ? 120 : stringHeight ;
        //        section0Height = stringHeight  > 120 ? tagHeight : tagHeight - 120 + stringHeight ;
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        self.zhushiHeight.constant = 0;
        self.textViewHeight.constant = 120;
        
        [self.openBtn setTitle:@"↓ 展开" forState:UIControlStateNormal];
        
        
    }
    [self.tableView reloadData];
}

@end
