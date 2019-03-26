//
//  CWTextFieldView.h
//  CWTextField
//
//  Created by 罗泰 on 2019/3/22.
//  Copyright © 2019 chenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWTextFieldView : UIView
#pragma mark - 属性
/**
 文字间距
 */
@property (nonatomic, assign) CGFloat                   textMargin;

/**
 文字颜色
 */
@property (nonatomic, strong) UIColor                   *textColor;

/**
 文字字体
 */
@property (nonatomic, strong) UIFont                    *textFont;

/**
 文字数量
 */
@property (nonatomic, assign) NSInteger                 count;

/**
 下划线高度
 */
@property (nonatomic, assign) CGFloat                   lineHeight;

/**
 下滑线高亮时的颜色
 */
@property (nonatomic, strong) UIColor                   *lineHighlightedColor;

/**
 下划线普通状态下的颜色
 */
@property (nonatomic, strong) UIColor                   *lineNormalColor;

/**
 是否显示InputAccessoryView (默认yes)
 */
@property (nonatomic, assign) BOOL                      isShowInputAccessoryView;

#pragma mark - 方法

/**
 构造方法

 @param frame 尺寸
 @param complete 编辑完成后的回调
 @return 实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                         done:(void(^)(NSString *text))complete;


/**
 开始编辑
 */
- (void)startEdit;


/**
 结束编辑
 */
- (void)endEdit;


/**
 控件版本号

 @return return value description
 */
+ (NSString *)version;
@end

NS_ASSUME_NONNULL_END
