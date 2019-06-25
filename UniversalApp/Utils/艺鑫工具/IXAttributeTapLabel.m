//
//  IXAttributeTapLabel.m
//  AttributeStringDemo
//
//  Created by Seven on 2018/1/30.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "IXAttributeTapLabel.h"
#import <CoreText/CoreText.h>
typedef enum
{VerticalAlignmentTop = 0, VerticalAlignmentMiddle,VerticalAlignmentBottom} VerticalAlignment;

@implementation IXAttributeModel
@end

@interface IXAttributeTapLabel()

@property (nonatomic, strong) NSArray   * targetStringArray;
@property (nonatomic) VerticalAlignment verticalAlignment;
@end

@implementation IXAttributeTapLabel

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}
- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    self.verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}
-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}
- (void)setText:(NSString *)text
     attributes:(NSDictionary *)attr
 tapStringArray:(NSArray <IXAttributeModel *>*)stringArray
{
    _targetStringArray = stringArray;
    
    __block NSMutableAttributedString   * attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttributes:attr range:NSMakeRange(0, text.length)];
    
    [stringArray enumerateObjectsUsingBlock:^(IXAttributeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [attStr addAttributes:obj.attributeDic range:obj.range];
        
        if (obj.alertImg) {
            NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
            attchImage.image = obj.alertImg;
            attchImage.bounds = CGRectMake(0, 0, 9, 20);
            NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
            [attStr insertAttributedString:stringImage atIndex:obj.range.location + obj.range.length];
        }
    }];
    
    self.attributedText = attStr;
    self.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch * touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [self touchPoint:p];
}

- (void)touchPoint:(CGPoint)p
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    CTFrameRef  frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedText.length), path, NULL);
    CFRange     range = CTFrameGetVisibleStringRange(frame);
    
    if (self.attributedText.length > range.length) {
        UIFont *font = nil;
        if ([self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil]) {
            font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        } else if (self.font){
            font = self.font;
        } else {
            font = [UIFont systemFontOfSize:17];
        }
        
        CGPathRelease(path);
        path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + font.lineHeight));
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    }
    
    CFArrayRef  lines = CTFrameGetLines(frame);
    CFIndex     count = CFArrayGetCount(lines);
    NSInteger   numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines,count) : count;
    
    if (!numberOfLines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(path);
        return;
    }
    
    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), origins);
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);;
    CGFloat verticalOffset = 0;
    
    for (CFIndex i = 0; i < numberOfLines; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGFloat ascent = 0.0f;
        CGFloat descent = 0.0f;
        CGFloat leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat height = ascent + fabs(descent*2) + leading;
        
        CGRect flippedRect = CGRectMake(p.x, p.y , width, height);
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, 0);
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        NSParagraphStyle *style = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        
        CGFloat lineSpace;
        
        if (style) {
            lineSpace = style.lineSpacing;
        } else {
            lineSpace = 0;
        }
        
        CGFloat lineOutSpace = (self.bounds.size.height - lineSpace * (count - 1) -rect.size.height * count) / 2;
        rect.origin.y = lineOutSpace + rect.size.height * i + lineSpace * i;
        
//        if (CGRectContainsPoint(rect, p)) {
            CGPoint relativePoint = CGPointMake(p.x, p.y);
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            CGFloat offset;
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            
            NSInteger link_count = self.targetStringArray.count;
            
            for (int j = 0; j < link_count; j++) {
                IXAttributeModel *model = self.targetStringArray[j];
                NSRange tmp = model.range;
                if (model.alertImg) {
                    //如果有图片，则后延识别范围
                    tmp.length += 2;
                }
                if (NSLocationInRange(index, tmp)) {
                    if (self.tapBlock) {
                        self.tapBlock(model.string);
                    }
                }
            }
//        }
    }
    
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(path);
}

@end

