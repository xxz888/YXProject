//
//  YXHomeXueJiaPinPaiDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/7.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiDetailViewController.h"
#import "YXHomeXueJiaDetailTableViewCell.h"
#import "CatZanButton.h"
#import "YXHomeXueJiaPinPaiLastDetailViewController.h"
#import "YXPublishFootViewController.h"
#import "POPAnimation.h"

@interface YXHomeXueJiaPinPaiDetailViewController()<ClickLikeBtnDelegate,UIWebViewDelegate>{
    UIImage * _selImage;
    UIImage * _unImage;
    CGFloat section0Height;
    CGFloat tagHeight;
    CGFloat stringHeight;
}

@end
@implementation YXHomeXueJiaPinPaiDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setSpace];

    [self initData];
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
    [self.webView loadHTMLString:[self adaptWebViewForHtml:cellData[@"intro"]] baseURL: baseUrl];

}
- (void)webViewDidFinishLoad:(UIWebView *)wb{
      tagHeight = [[wb stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    [self.tableView reloadData];
}
//HTML适配图片文字
- (NSString *)adaptWebViewForHtml:(NSString *) htmlStr
{
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
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = 10.0;
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    //, NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    return  ceilf(size.height);
    
}

-(void)initData{
    NSDictionary * cellData = self.dicStartData;

    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaDetailTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法

    
    
    _selImage = [UIImage imageNamed:@"Zan"];
    _unImage = [UIImage imageNamed:@"UnZan"];

    self.title = cellData[@"cigar_brand"];
    
    
    NSString * str = [(NSMutableString *)cellData[@"photo"] replaceAll:@" " target:@"%20"];
    [self.section1ImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.section1ImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.section1TextView.text = kGetString(cellData[@"intro"]);
    self.section1TitleLbl.text = [NSString stringWithFormat:@"%@",cellData[@"cigar_brand"]];

    ViewBorderRadius(self.section1GuanZhuBtn, 5, 1, self.section1GuanZhuBtn.titleLabel.textColor);
    
    self.section1countLbl.text = [kGetString(self.dicData[@"concern_number"]) append:@" 人关注"];
    BOOL isGuanZhu = [self.dicData[@"is_concern"] integerValue] == 1;
      [ShareManager setGuanZhuStatus:self.section1GuanZhuBtn status:!isGuanZhu alertView:NO];
    
    

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
        return [self.dicData[@"data"] count];//商品颜色的数组
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        NSDictionary * cellData = self.dicData[@"data"][indexPath.row];
        YXHomeXueJiaDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaDetailTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        NSString * url = [cellData[@"photo_list"] count] > 0 ? cellData[@"photo_list"][0][@"photo_url"] : @"";
        NSString * str = [(NSMutableString *)url replaceAll:@" " target:@"%20"];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [cell.section2ImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        cell.whereCome = self.whereCome;
        cell.section2TitleLbl.text = cellData[@"cigar_name"];
        cell.section2Lbl1.text = [kGetString(cellData[@"ring_gauge"]) concate:@"环径:"] ;
        cell.section2Lbl2.text = [kGetString(cellData[@"length"]) concate:@"长度:"];
        cell.section2Lbl3.text = [kGetString(cellData[@"shape"]) concate:@"品型:"];
        cell.section2Lbl4.text = [kGetString(cellData[@"price_box_china"]) append:@"元"];
        cell.section2Lbl5.text = [kGetString(cellData[@"price_single_china"]) append:@"元/支"];
        cell.section2Lbl6.text = [NSString stringWithFormat:@"%@/盒(%@支)",cellData[@"price_box_china"],cellData[@"box_size"]];
        cell.cigar_id = kGetString(cellData[@"id"]);
        //yes为足迹进来 no为正常进入  足迹进来
        cell.stackView1.hidden = cell.likeBtn.hidden = cell.zanCountLbl.hidden = cell.lineView.hidden = self.whereCome;
        [cell.likeBtn setBackgroundImage:[cellData[@"is_collect"] integerValue] == 1  || !cellData[@"is_collect"] ? _selImage:_unImage forState:UIControlStateNormal];
        cell.zanCountLbl.text = kGetString(cellData[@"collect_number"]);
        if (self.whereCome) {
            tableView.separatorStyle = 0;
        }
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
        return self.whereCome ? 0 : [self.openBtn.titleLabel.text isEqualToString:@"↑ 收起"]  ? 430-120+tagHeight + 22 : 430;
    }else{
        //yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
        return self.whereCome ? 130 : 185;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        
         //yes为足迹进来 no为正常进入
        if (self.whereCome) {
             YXPublishFootViewController * footVC = [[YXPublishFootViewController alloc]init];
            footVC.cigar_id = kGetString(self.dicData[@"data"][indexPath.row][@"id"]);
            [self.navigationController pushViewController:footVC animated:YES];
//            [self presentViewController:footVC animated:YES completion:nil];
        }else{
            kWeakSelf(self);
  
                
                UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
                YXHomeXueJiaPinPaiLastDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiLastDetailViewController"];
                VC.startDic = [NSMutableDictionary dictionaryWithDictionary:self.dicData[@"data"][indexPath.row]];
            
            //请求六宫格图片
                NSString * tag = VC.startDic[@"cigar_name"];
                [YX_MANAGER requestGetDetailListPOST:@{@"type":@(1),@"tag":tag,@"page":@(1)} success:^(id object) {
                NSMutableArray * imageArray = [NSMutableArray array];
                for (NSDictionary * dic in object) {
                    [imageArray addObject:dic[@"photo1"]];
                }

                [VC.startDic setValue:self.title forKey:@"cigar_brand"];
                VC.imageArray = [NSMutableArray arrayWithArray:imageArray];
                [self.navigationController pushViewController:VC animated:YES];
                
            }];
    
        }

    }
}
-(void)requestLiuGongGe{

}
#pragma mark ========== 关注作者的方法 ==========
- (IBAction)section1GuanZhuAction:(id)sender {
    if ([userManager loadUserInfo]) {
        [self requestMy_concern_cigar];
    }else{
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
}
#pragma mark ========== 点赞按钮 ==========
-(void)clickLikeBtn:(BOOL)isZan cigar_id:(NSString *)cigar_id likeBtn:(nonnull UIButton *)likeBtn{
    kWeakSelf(self);
    if ([userManager loadUserInfo]) {
        [YX_MANAGER requestCollect_cigarPOST:@{@"cigar_id":cigar_id} success:^(id object) {
            [likeBtn setBackgroundImage:isZan ? _selImage:_unImage forState:UIControlStateNormal];
            [weakself requestCigar_brand_details];
        }];
    }else{
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
}
#pragma mark ========== 重新请求详情 ==========
-(void)requestCigar_brand_details{
    kWeakSelf(self);
    [YX_MANAGER requestCigar_brand_detailsPOST:@{@"cigar_brand_id":kGetString(self.dicStartData[@"id"])} success:^(id object) {
        weakself.dicData = [NSMutableDictionary dictionaryWithDictionary:object];
        [weakself.tableView reloadData];
        weakself.section1countLbl.text = [kGetString(self.dicData[@"concern_number"]) append:@" 人关注"];
        BOOL isGuanZhu = [self.dicData[@"is_concern"] integerValue] == 1;
        [ShareManager setGuanZhuStatus:self.section1GuanZhuBtn status:!isGuanZhu alertView:YES];
    }];
}
#pragma mark ========== 请求是否关注 ==========
-(void)requestMy_concern_cigar{
    kWeakSelf(self);
    NSDictionary * cellData = self.dicStartData;
    [YX_MANAGER requestMy_concern_cigarPOST:@{@"cigar_brand_id":cellData[@"id"]} success:^(id object) {
        [weakself requestCigar_brand_details];
//        BOOL isGuanZhu = [weakself.dicData[@"is_concern"] integerValue] == 1;
//        [ShareManager setGuanZhuStatus:weakself.section1GuanZhuBtn status:isGuanZhu];
    }];
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
