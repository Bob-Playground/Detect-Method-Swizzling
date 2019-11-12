//
//  ViewController.m
//  Detection-Method-Swizzling
//
//  Created by HuangLibo on 2019/11/11.
//  Copyright © 2019 HuangLibo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self dosth];
}

- (void)dosth {
    NSLog(@"do sth");
    
    // 1. 在这里, `__PRETTY_FUNCTION__` 与 `__func__` 及 `__FUNCTION__` 的内容是一样的(使用不同编译器可能会不一样)
    // 2. 存的内容是该方法在`编译时`的方法描述, 数据类型是 `const char *`, 内容的格式为: "-[ViewController dosth]"
    NSString *prettyFunction = [[NSString alloc] initWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding];

    // ` `和`]`符号之间的内容是 SEL 名, 将其取出.
    NSRange range1 = [prettyFunction rangeOfString:@" "];
    NSRange range2 = [prettyFunction rangeOfString:@"]"];
    NSRange range3 = NSMakeRange(range1.location + 1, range2.location - range1.location - 1);
    // 编译时该方法的 SEL 名
    NSString *originFunctionName = [prettyFunction substringWithRange:range3];

    // _cmd 是方法当前的 SEL 名
    NSString *_cmdStr = NSStringFromSelector(_cmd);

    // 比较当前的 SEL 名和编译时的 SEL 名, 如果不一致, 则说明方法被 Hook 了.
    if (![originFunctionName isEqualToString:_cmdStr]) {
        NSLog(@"Hooked");
        // 检测到被 Hook 后, 可以做一些事情. 比如像微信那样提示用户可能会被封号.
        // ...
    }
}

@end
