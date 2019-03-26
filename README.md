# CWLineTextField
---
(输入框DIY)带下划线样式,带间距,带字数限制的明文输入框

### 效果图
![demo](https://github.com/baozoudiudiu/CWLineTextField/blob/master/demo.gif)

### 使用代码示例
1. 创建控件实例对象,并设置编辑完成后的回调.
```
    self.textFieldView = [[CWTextFieldView alloc] initWithFrame:CGRectMake(20, 100, (width - 40), 30) done:^(NSString * _Nonnull text) {
        NSLog(@"text: %@", text);
    }];
```
* 创建控件时支持使用autolayout布局
2. 添加到父视图, 简单易用
```
[self.view addSubview:self.textFieldView];
```
3. 相关属性设置

| 属性名 | 类型 | 效果 |
| ------ | ------ | ------ |
| textMargin | CGFloat | 文字间距 |
| textColor | UIColor | 文字颜色 |
| textFont | UIFont |  文字字体 |
| count | NSInteger |  输入框字数限制 |
| lineHeight | CGFloat | 下划线光标高度 |
| lineHighlightedColor | UIColor | 下划线光标颜色 |
| lineNormalColor | UIColor | 下划线颜色|
| isShowInputAccessoryView | BOOL |  弹出键盘时是否显示InputAccessoryView | 

### 具体实现 (未完待续)
