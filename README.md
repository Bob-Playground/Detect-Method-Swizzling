# 检测 Method-Swizzling

## 原理

- `__PRETTY_FUNCTION__` 存储的是**编译时**方法的描述（格式为 "-[MyObject selector]"）
- `_cmd` 是方法的隐藏参数，存储的是方法**当前的** selector。

比对这两个 selector，如果不一样，则说明被 hook 了。

## 限制

这样做的前提是 hack 者在 hook 时会调用原始的方法实现，如果不调用，就无法获知方法是否被 hook 了（因为没有调用检测方法的时机了）。

## 实现

请看此项目的代码。

## 参考资料

- 《macOS软件安全与逆向分析》，Page/411
    - 书籍源码：https://github.com/feicong/macbook
    - 作者专栏：https://zhuanlan.zhihu.com/macos-sec
- https://nshipster.cn/method-swizzling/



