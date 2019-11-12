//
//  ViewController+Hack.m
//  Detection-Method-Swizzling
//
//  Created by HuangLibo on 2019/11/11.
//  Copyright © 2019 HuangLibo. All rights reserved.
//

#import "ViewController+Hack.h"
#import <objc/runtime.h>

@implementation ViewController (Hack)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        // 由于 Hook 的是未暴露的方法, 这里需要添加编译选项来关闭"找不到SEL" 的Warning
        SEL originalSelector = @selector(dosth);
        #pragma clang diagnostic pop
        
        SEL swizzledSelector = @selector(dosth2);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)dosth2 {
    [self dosth2]; // 如果 hack 者在这里不调用原始的方法实现, 则无法检测到是否被 hook 了.
    
    NSLog(@"hacked");
}

@end
