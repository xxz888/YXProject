//
//  ViewController.m
//  InputimageExample
//
//  Created by zorro on 15/3/6.
//  Copyright (c) 2015年 tutuge. All rights reserved.
//

#import "RichTextViewController.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"


#import "ImageTextAttachment.h"
#import "NSAttributedString+RichText.h"
#import "PictureModel.h"
#import "NSAttributedString+html.h"
#import "QiniuLoad.h"

//Image default max size，图片显示的最大宽度
#define IMAGE_MAX_SIZE (100)

#define ImageTag (@"[UIImageView]")
#define DefaultFont (12)
#define MaxLength (2000)

//导入头文件
#import "ImagePicker.h"
@interface RichTextViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate>{
    
    ImagePicker *imagePicker;
    
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (assign,nonatomic) NSUInteger finishImageNum;//纪录图片下载完成数目
@property (assign,nonatomic) NSUInteger apperImageNum; //纪录图片将要下载数目
//默认提示字
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


//设置
@property (nonatomic,assign) NSRange newRange;
@property (nonatomic,strong) NSString * newstr;
@property (nonatomic,assign) BOOL isBold;          //是否加粗
@property (nonatomic,strong) UIColor * fontColor;  //字体颜色
@property (nonatomic,assign) CGFloat  font;        //字体大小
@property (nonatomic,assign) NSUInteger location;  //纪录变化的起始位置
@property (nonatomic,strong) NSMutableAttributedString * locationStr;

@property (nonatomic,assign) CGFloat lineSapce;    //行间距
@property (nonatomic,assign) BOOL isDelete;        //是否是回删



@end

@implementation RichTextViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    imagePicker = [ImagePicker sharedManager];
    [self resetTextStyle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    if (self.content!=nil) { [self setContentArr:self.content];}
}

- (IBAction)paizhaoAction:(UIButton *)sender{
    [self.view endEditing:YES];
    [imagePicker dwSetPresentDelegateVC:self SheetShowInView:self.view InfoDictionaryKeys:(long)nil];
    [imagePicker dwGetpickerTypeStr:^(NSString *pickerTypeStr) {
    } pickerImagePic:^(UIImage *pickerImagePic) {
        [self appenReturn];
        [self setImageText:pickerImagePic withRange:self.textView.selectedRange appenReturn:YES];
        [self.textView becomeFirstResponder];
    }];
}

- (IBAction)nextAction:(id)sender {
    [self finishEdit];
}
-(void)finishEdit{
    kWeakSelf(self);
    
    if ([_textView.attributedText getImgaeArray].count > 0) {
        //先上传到七牛云图片  再提交服务器
        [QiniuLoad uploadImageToQNFilePath:[_textView.attributedText getImgaeArray] success:^(NSString *reslut) {
            NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
            NSString * essay = [weakself replacetagWithImageArray:qiniuArray];
            NSDictionary * parDic = @{@"title":self.titleTf.text,
                                      @"intro":@"",
                                      @"picture1":qiniuArray.count > 0  ? qiniuArray[0] : @"",
                                      @"picture2":qiniuArray.count > 1  ? qiniuArray[1] : @"",
                                      @"essay":essay,
                                      @"publish_site":@"现代野风之星",
                                      @"tag":@"000",
                                      };
        [YX_MANAGER requestEssayPOST:parDic success:^(id object) {
            if ([object isEqualToString:@"1"]) {
                [QMUITips showSucceed:@"发布成功" inView:weakself.view hideAfterDelay:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself finishPublish];
                });
            }else{
                [QMUITips showError:@"发布失败,请稍后重试" inView:weakself.view hideAfterDelay:2];
            }
        }];
        } failure:^(NSString *error) {
            NSLog(@"%@",error);
        }];
    }
    
 
    
    
    
    if (self.feedbackHtml) {
        if ([self.RTDelegate respondsToSelector:@selector(uploadImageArray:withCompletion:)]) {
            //实现上传图片的代理，用url替换图片标识
            
            __weak typeof(self) weakself=self;
            
            [self.RTDelegate uploadImageArray:[_textView.attributedText getImgaeArray] withCompletion:^NSString *(NSArray *urlArray) {
                return  [weakself replacetagWithImageArray:urlArray];
            }];
        }
    }
    else{
        //注意这下面的三种 数据
        //    NSLog(@"attributedText。getPlainString--%@",[_textView.attributedText getPlainString]);
        //    NSLog(@"attributedText--%@",self.textView.attributedText);
        
        
        //这个是返回数组，每个数组装有不同设置的字符串
        if (self.finished!=nil) {
            self.finished([_textView.attributedText getArrayWithAttributed],[_textView.attributedText getImgaeArray]);
            
        }
        
    }
}

#pragma mark - 完成发布
//完成发布
-(void)finishPublish{
    //2.block传值
    if (self.mDismissBlock != nil) {
        self.mDismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//block声明方法
-(void)toDissmissSelf:(dismissBlock)block{
    self.mDismissBlock = block;
}
//这里就开始上传图片，拼接图片地址
-(NSString *)replacetagWithImageArray:(NSArray *)picArr{
    NSMutableAttributedString * contentStr=[[NSMutableAttributedString alloc]initWithAttributedString:_textView.attributedText];
    [contentStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, contentStr.length)
                           options:0
                        usingBlock:^(id value, NSRange range, BOOL *stop) {
                            if (value && [value isKindOfClass:[ImageTextAttachment class]]) {
                                [contentStr replaceCharactersInRange:range withString:ImageTag];
                            }
                        }];
    NSMutableString * mutableStr=[[NSMutableString alloc]initWithString:[contentStr toHtmlString]];
    //这里是把字符串分割成数组，
    NSArray * strArr=[mutableStr  componentsSeparatedByString:ImageTag];
    NSString * newContent=@"";
    for (int i=0; i<strArr.count; i++) {
        PictureModel * picture= [[PictureModel alloc]init];
        picture.imageurl = strArr[i];
        NSString * imgTag=@"";
        if (i<picArr.count) {
            picture=[picArr objectAtIndex:i];
            imgTag=[NSString stringWithFormat:@"<img src=\"%@\" w=\"%d\" h=\"%d\"/>",picture,220,220];
        }
        //因为cutstr 可能是null
        NSString * cutStr=[strArr objectAtIndex:i];
        newContent=[NSString stringWithFormat:@"%@%@%@",newContent,cutStr,imgTag];
    }
    return newContent;
}



































+(instancetype)ViewController
{
    RichTextViewController * ctrl=[[UIStoryboard storyboardWithName:@"RichText" bundle:nil]instantiateViewControllerWithIdentifier:@"RichTextViewController"];
    
    return ctrl;
}
- (IBAction)coseViewAction:(id)sender {
    [self finishPublish];
}
-(void)CommomInit
{
    self.textView.delegate=self;
    //显示链接，电话
    self.textView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.font=DefaultFont;
    self.fontColor=[UIColor blackColor];
    self.location=0;
    self.isBold=NO;
    self.lineSapce=5;
    [self setInitLocation];
}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetTextStyle {
    //After changing text selection, should reset style.
    [self CommomInit];
    NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
    
    
    [_textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_textView.textStorage removeAttribute:NSForegroundColorAttributeName range:wholeRange];
    
    //字体颜色
    [_textView.textStorage addAttribute:NSForegroundColorAttributeName value:self.fontColor range:wholeRange];
    
    //字体加粗
    if (self.isBold) {
        [_textView.textStorage addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:self.font] range:wholeRange];
    }
    //字体大小
    else
    {
        
        [_textView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.font] range:wholeRange];
    }
    
    
    
}
-(void)setInitLocation
{
    
    
    self.locationStr=nil;
    self.locationStr=[[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
   
    
}
-(void)setStyle
{
    
    
    //把最新的内容进行替换
    [self setInitLocation];
    
    
    if (self.isDelete) {
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = self.lineSapce;// 字体的行间距
    NSDictionary *attributes=nil;
    if (self.isBold) {
        attributes = @{
                       NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font],
                       NSForegroundColorAttributeName:self.fontColor,
                       NSParagraphStyleAttributeName:paragraphStyle
                       };
        
    }
    else
    {
        attributes = @{
                       NSFontAttributeName:[UIFont systemFontOfSize:self.font],
                       NSForegroundColorAttributeName:self.fontColor,
                       NSParagraphStyleAttributeName:paragraphStyle
                       };
        
    }
    
    NSAttributedString * replaceStr=[[NSAttributedString alloc] initWithString:self.newstr attributes:attributes];
    [self.locationStr replaceCharactersInRange:self.newRange withAttributedString:replaceStr];
   
    _textView.attributedText =self.locationStr;
    
    //这里需要把光标的位置重新设定
    self.textView.selectedRange=NSMakeRange(self.newRange.location+self.newRange.length, 0);
   
}
#pragma mark textViewDelegate
/**
 *  点击图片触发代理事件
 */
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    NSLog(@"%@", textAttachment);
    return NO;
}

/**
 *  点击链接，触发代理事件
 */
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    [[UIApplication sharedApplication] openURL:URL];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //    textview 改变字体的行间距
    
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    if (range.length == 1)     // 回删
    {
       
        return YES;
    }
    else
    {
        
        // 超过长度限制
        if ([textView.text length] >= MaxLength+3)
        {
            
            return NO;
        }
    }

    
    return YES;
}
//- (void)textViewDidChangeSelection:(UITextView *)textView;
//{
//    NSLog(@"焦点改变");
//}
-(void)textViewDidChange:(UITextView *)textView
{
    
    if (self.textView.attributedText.length>0) {
        self.placeholderLabel.hidden=YES;
    }
    else
    {
        self.placeholderLabel.hidden=NO;
    }
    NSInteger len=textView.attributedText.length-self.locationStr.length;
    if (len>0) {
        
        self.isDelete=NO;
        self.newRange=NSMakeRange(self.textView.selectedRange.location-len, len);
        self.newstr=[textView.text substringWithRange:self.newRange];
        
    }
    else
    {
        self.isDelete=YES;
        
    }

    
# warning  如果出现输入问题，检查这里
    bool isChinese;//判断当前输入法是否是中文

    if ([[[textView textInputMode] primaryLanguage]  isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    NSString *str = [[ self.textView text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [ self.textView markedTextRange];
        
        //获取高亮部分
        UITextPosition *position = [ self.textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
//            NSLog(@"汉字");
            //              NSLog(@"str=%@; 本次长度=%lu",str,(unsigned long)[str length]);
            
            [self setStyle];
            if ( str.length>=MaxLength) {
                NSString *strNew = [NSString stringWithString:str];
                [ self.textView setText:[strNew substringToIndex:MaxLength]];
            }
        }
        else
        {
//            NSLog(@"没有转化--%@",str);
            if ([str length]>=MaxLength+10) {
                NSString *strNew = [NSString stringWithString:str];
                [ self.textView setText:[strNew substringToIndex:MaxLength+10]];
            }
            
        }
    }else{
//        NSLog(@"英文");
        
        [self setStyle];
        if ([str length]>=MaxLength) {
            NSString *strNew = [NSString stringWithString:str];
            [ self.textView setText:[strNew substringToIndex:MaxLength]];
        }
    }
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    
}
#pragma mark - Action

//设置图片
-(void)setImageText:(UIImage *)img withRange:(NSRange)range appenReturn:(BOOL)appen
{
    
 
    UIImage * image=img;
    
    if (image == nil)
    {
        return;
    }
    
   
    if (![image isKindOfClass:[UIImage class]])           // UIImage资源
    {
        
        return;
    }
    
    
    CGFloat ImgeHeight=image.size.height*IMAGE_MAX_SIZE/image.size.width;
    if (ImgeHeight>IMAGE_MAX_SIZE*2) {
        ImgeHeight=IMAGE_MAX_SIZE*2;
    }
    
    
    ImageTextAttachment *imageTextAttachment = [ImageTextAttachment new];
    
    //Set tag and image
    imageTextAttachment.imageTag = ImageTag;
    imageTextAttachment.image =image;
    
    //Set image size
    imageTextAttachment.imageSize = CGSizeMake(IMAGE_MAX_SIZE, ImgeHeight);


    if (appen) {
        //Insert image image
        [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]
                                              atIndex:range.location];
    }
    else
    {
        if (_textView.textStorage.length>0) {
           
            //Insert image image
            [_textView.textStorage replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]];
        }

    }

    
    //Move selection location
    _textView.selectedRange = NSMakeRange(range.location + 1, range.length);
    
    //设置locationStr的设置
    [self setInitLocation];
    if(appen)
    {
           [self appenReturn]; 
    }

}



-(void)appenReturn
{
    NSAttributedString * returnStr=[[NSAttributedString alloc]initWithString:@"\n"];
    NSMutableAttributedString * att=[[NSMutableAttributedString alloc]initWithAttributedString:_textView.attributedText];
    [att appendAttributedString:returnStr];
    
    _textView.attributedText=att;
}

#pragma mark - Keyboard notification

- (void)onKeyboardNotification:(NSNotification *)notification {
    //Reset constraint constant by keyboard height
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        CGRect keyboardFrame = ((NSValue *) notification.userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
        _bottomConstraint.constant = keyboardFrame.size.height;
    } else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        _bottomConstraint.constant = -40;
    }
    
    //Animate change
    [UIView animateWithDuration:0.8f animations:^{
        [self.view layoutIfNeeded];
    }];
}






#pragma mark setter
-(void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText=placeholderText;
    self.placeholderLabel.text=placeholderText;
}

#pragma mark  设置内容

-(void)setContentArr:(NSArray *)content
{
    
    if (content.count<=0) {
        self.placeholderLabel.hidden=NO;
        return;
    }
    self.placeholderLabel.hidden=YES;
    
    //将要下载的图片数目
    self.apperImageNum=0;

    NSMutableArray * imageArr=[NSMutableArray array];
    
    NSMutableAttributedString * mutableAttributedStr=[[NSMutableAttributedString alloc]init];
    for (NSDictionary * dict in content) {
        if (dict[@"image"]!=nil) {
            NSMutableDictionary * imageMutableDict=[NSMutableDictionary dictionaryWithDictionary:[self imageUrlRX:dict[@"image"]]];

            [imageMutableDict setObject:[NSNumber numberWithInteger:mutableAttributedStr.length] forKey:@"locLenght"];
            [imageArr addObject:imageMutableDict];
            self.apperImageNum++;
            
//            //默认图片

//            [mutableAttributedStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
            
            UIImage * image=[UIImage imageNamed:@"richtext_image"];
            CGFloat ImgeHeight=image.size.height*IMAGE_MAX_SIZE/image.size.width;
            if (ImgeHeight>IMAGE_MAX_SIZE*2) {
                ImgeHeight=IMAGE_MAX_SIZE*2;
            }
            
            ImageTextAttachment *imageTextAttachment = [ImageTextAttachment new];
            imageTextAttachment.image =image;
            
            //Set image size
            imageTextAttachment.imageSize = CGSizeMake(IMAGE_MAX_SIZE, ImgeHeight);
 
                //Insert image image
                [mutableAttributedStr insertAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]
                                                      atIndex:mutableAttributedStr.length];
            continue;
        }

        NSString * plainStr=dict[@"title"];
        NSMutableAttributedString * attrubuteStr=[[NSMutableAttributedString alloc]initWithString:plainStr];
        //设置初始内容
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = [dict[@"lineSpace"] floatValue];// 字体的行间距
        
        //是否加粗
        if ([dict[@"bold"] boolValue]) {
            NSDictionary *attributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:[dict[@"font"] floatValue] ],NSFontAttributeName,[UIColor colorWithHexString:dict[@"color"]],NSForegroundColorAttributeName,paragraphStyle,NSParagraphStyleAttributeName,nil ];
            [attrubuteStr addAttributes:attributes range:NSMakeRange(0, attrubuteStr.length)];
        }
        else
        {
            NSDictionary *attributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:[dict[@"font"] floatValue]],NSFontAttributeName,[UIColor colorWithHexString:dict[@"color"]],NSForegroundColorAttributeName,paragraphStyle,NSParagraphStyleAttributeName,nil ];
            [attrubuteStr addAttributes:attributes range:NSMakeRange(0, attrubuteStr.length)];
        }


        [mutableAttributedStr appendAttributedString:attrubuteStr];
    }
    
    self.textView.attributedText =mutableAttributedStr;


    //没有图片需要下载
    if (self.apperImageNum==0) {
        return;
    }

   
    self.finishImageNum=0;

    NSUInteger locLength=0;
    //替换带有图片标签的,设置图片
    for (int i=0; i<imageArr.count; i++) {
       NSDictionary * imageDict=[imageArr objectAtIndex:i];
       locLength=[imageDict[@"locLenght"]integerValue] ;
        //完成之后，纪录的位置移动1,图片长度为1
//        locLength+=i;
        //只取第一个
        [self downLoadImageWithUrl:(NSString *)imageDict[@"src"]                                                                                                                                                    WithRange:NSMakeRange(locLength, 1)];

    }
    
    //设置光标到末尾
    self.textView.selectedRange=NSMakeRange(self.textView.attributedText.length, 0);
    
    
}

-(void)downLoadImageWithUrl:(NSString *)url WithRange:(NSRange)range
{
    
    __weak typeof(self) weakSelf=self;
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    
    [manager downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if(finished)
        {
            self.finishImageNum++;
             NSLog(@"下载图片成功");
            if (self.finishImageNum==self.apperImageNum) {
                  NSLog(@"下载图片完成");
            }
          
            [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:url]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf setImageText:image withRange:range appenReturn:NO];
            });
            
            
            
        }
        else
        {
            NSLog(@"下载图片失败");
        }
    }];
    
}
//输出正则里面的内容//输出正则里面的内容
-(NSDictionary *)imageUrlRX:(NSString *)string
{
    NSString *pattern = @"<img src=\"([^\\s]*)\" w=\"([^\\s]*)\" h=\"([^\\s]*)\"\\s*/>";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:0
                                                                                  error:NULL];
    NSArray *lines = [expression matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    NSMutableArray * resultArr=[NSMutableArray array];
    for (NSTextCheckingResult *textCheckingResult in lines) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        
        //0 代表整个正则内容
        NSString* value1 = [string substringWithRange:[textCheckingResult rangeAtIndex:1]];
        NSString* value2 = [string substringWithRange:[textCheckingResult rangeAtIndex:2]];
        NSString* value3 = [string substringWithRange:[textCheckingResult rangeAtIndex:3]];
        
        result[@"src"] = value1;
        result[@"w"] = value2;
        result[@"h"] = value3;
        [resultArr addObject:result];
        
    }
    
    
    return resultArr.firstObject;
}


@end
