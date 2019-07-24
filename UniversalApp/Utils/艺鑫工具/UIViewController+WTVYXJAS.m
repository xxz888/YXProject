#import "UIViewController+WTVYXJAS.h"
#import <UMAnalytics/MobClick.h>
@implementation UIViewController (WTVYXJAS)

//参考资料：http://blog.leichunfeng.com/blog/2015/06/14/objective-c-method-swizzling-best-practice/
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL viewWillOriginaSelector = @selector(viewWillAppear:);
        SEL viewWillSwizzledSelector = @selector(as_viewWillAppear:);
        
        SEL viewWillDissOriginaSelector = @selector(viewWillDisappear:);
        SEL viewWillDissSwizzledSelector = @selector(as_viewWillDisappear:);
        
        Method viewWillAppear = class_getInstanceMethod(class, @selector(viewWillAppear:));
        Method as_viewWillAppear = class_getInstanceMethod(class, @selector(as_viewWillAppear:));
        BOOL viewWillSuccess = class_addMethod(class, viewWillOriginaSelector, method_getImplementation(as_viewWillAppear), method_getTypeEncoding(as_viewWillAppear));
        if (viewWillSuccess) {
            class_replaceMethod(class, viewWillSwizzledSelector, method_getImplementation(viewWillAppear), method_getTypeEncoding(viewWillAppear));
        }else{
            method_exchangeImplementations(viewWillAppear, as_viewWillAppear);
        }
        
        Method viewWillDisappear = class_getInstanceMethod(class, @selector(viewWillDisappear:));
        Method as_viewWillDisappear = class_getInstanceMethod(class, @selector(as_viewWillDisappear:));
        
        BOOL viewWillDissSuccess = class_addMethod(class, viewWillDissOriginaSelector, method_getImplementation(as_viewWillDisappear), method_getTypeEncoding(as_viewWillDisappear));
        if (viewWillDissSuccess) {
            class_replaceMethod(class, viewWillDissSwizzledSelector, method_getImplementation(viewWillDisappear), method_getTypeEncoding(viewWillDisappear));
        }else{
            method_exchangeImplementations(viewWillDisappear, as_viewWillDisappear);
        }
    });
}


- (void)as_viewWillAppear:(BOOL)animated{
    if (self.title.length) {
        NSLog(@"开始路径%@->%@ -> %s",NSStringFromClass(self.class),self.title,__func__);
        [MobClick beginLogPageView:self.title];
    }
    [self as_viewWillAppear:animated];
}

- (void)as_viewWillDisappear:(BOOL)animated{
    if (self.title.length) {
        NSLog(@"结束路径%@->%@ -> %s",NSStringFromClass(self.class),self.title,__func__);
        [MobClick endLogPageView:self.title];
    }
    [self as_viewWillDisappear:animated];
}

- (void)setUmLogAs:(NSString *)umLogAs{
    objc_setAssociatedObject(self, @selector(umLogAs), umLogAs, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSString *)umLogAs{
    //_cmd在Objective-C的方法中表示当前方法的selector，正如同self表示当前方法调用的对象实例一样。
    return objc_getAssociatedObject(self, _cmd);
}

@end
