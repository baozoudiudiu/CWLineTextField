//
//  CWTextFieldView.m
//  CWTextField
//
//  Created by 罗泰 on 2019/3/22.
//  Copyright © 2019 chenwang. All rights reserved.
//

#import "CWTextFieldView.h"


/**
 输入框单元格
 */
@interface CWTextFieldViewCell: UICollectionViewCell {
    
}
/**
 下划线
 */
@property (nonatomic, strong) UIView                    *lineView;

/**
 文字
 */
@property (nonatomic, strong) UILabel                   *valueLabel;

/**
 是否为当前待输入单元格
 */
@property (nonatomic, assign) BOOL                      isCurrent;

/**
 高亮时,下划线的颜色
 */
@property (nonatomic, strong) UIColor                   *selectedColor;

/**
 非高亮时,下划线的颜色
 */
@property (nonatomic, strong) UIColor                   *normalColor;

/**
 下划线layout数组
 */
@property (nonatomic, strong) NSArray                   *lineLayouts;

/**
 下划线高度
 */
@property (nonatomic, assign) CGFloat                   lineHeight;
@end

@implementation CWTextFieldViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        // 创建下划线
        self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
        self.lineView.translatesAutoresizingMaskIntoConstraints = NO;
        self.lineView.backgroundColor = UIColor.blackColor;
        [self.contentView addSubview:self.lineView];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[line]-0-|" options:kNilOptions metrics:@{} views:@{@"line" : self.lineView}]];
        self.lineLayouts = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(==height)]-0-|" options:kNilOptions metrics:@{@"height" : @(self.lineHeight)} views:@{@"line" : self.lineView}];
        [self.contentView addConstraints:self.lineLayouts];
        
        // 创建label
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.valueLabel.textColor = UIColor.blackColor;
        self.valueLabel.font      = [UIFont systemFontOfSize:18];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        self.valueLabel.text      = @"A";
        [self.contentView addSubview:self.valueLabel];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label]-0-|" options:kNilOptions metrics:@{} views:@{@"label" : self.valueLabel}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label]-0-|" options:kNilOptions metrics:@{} views:@{@"label" : self.valueLabel}]];
    }
    return self;
}


/**
 是否为当前输入下标位子

 @param isCurrent isCurrent description
 */
- (void)setIsCurrent:(BOOL)isCurrent {
    _isCurrent = isCurrent;
    self.lineView.backgroundColor = isCurrent ? self.selectedColor : self.normalColor;
}


/// 重置下划线高度
- (void)resetLineHeight:(CGFloat)height {
    if (self.lineHeight != height) {
        self.lineHeight = height;
        [self.contentView removeConstraints:self.lineLayouts];
        self.lineLayouts =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(==height)]-0-|" options:kNilOptions metrics:@{@"height" : @(self.lineHeight)} views:@{@"line" : self.lineView}];
        [self.contentView addConstraints:self.lineLayouts];
        [self.contentView layoutIfNeeded];
    }
}
@end




/**
 输入框的inputAccessoryView
 */
@interface CWInputView: UIView
@property (nonatomic, strong) UILabel                   *contentLabel;
@property (nonatomic, strong) UIButton                  *doneBtn;
@property (nonatomic, weak) UITextField                 *textField;
@end

@implementation CWInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.groupTableViewBackgroundColor;
        self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.doneBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [self.doneBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        self.doneBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.doneBtn addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneBtn];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[button]-0-|" options:kNilOptions metrics:@{} views:@{@"button" : self.doneBtn}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==50)]-4-|" options:kNilOptions metrics:@{} views:@{@"button" : self.doneBtn}]];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.textColor     = UIColor.lightGrayColor;
        self.contentLabel.font          = [UIFont systemFontOfSize:14];
        [self addSubview:self.contentLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label]-0-|" options:kNilOptions metrics:@{} views:@{@"label": self.contentLabel}]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        self.contentLabel.text = @"";
    }
    return self;
}


/// 完成按钮点击回调
- (void)doneClick:(UIButton *)sender {
    if(self.textField) {
        [self.textField endEditing:YES];
    }
}
@end




@interface CWTextFieldView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
{}
@property (nonatomic, strong) UICollectionView          *collectionView;
@property (nonatomic, strong) UITextField               *textField;

/**
 数据源
 */
@property (nonatomic, strong) NSArray<NSString *>       *dataArr;

/**
 当前输入光标位置
 */
@property (nonatomic, assign) NSInteger                 currentIndex;

/**
 输入完成回调
 */
@property (nonatomic, copy) void (^editComplete) (NSString *text);


/**
 键盘上方工具栏
 */
@property (nonatomic, strong) CWInputView               *inputView;
@end


@implementation CWTextFieldView

+ (NSString *)version {
    return @"1.0";
}


- (instancetype)initWithFrame:(CGRect)frame done:(void (^)(NSString * _Nonnull))complete {
    if (self = [self initWithFrame:frame]) {
        [self setEditComplete:complete];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self defaultData];
        [self configureUI];
    }
    return self;
}


/// 设置默认数据
- (void)defaultData {
    self.dataArr                = [NSArray array];
    self.count                  = 8;
    self.textMargin             = 12;
    self.textColor              = UIColor.blackColor;
    self.textFont               = [UIFont systemFontOfSize:18];
    self.lineHeight             = 1.5;
    self.lineHighlightedColor   = UIColor.cyanColor;
    self.lineNormalColor        = UIColor.blackColor;
    _isShowInputAccessoryView = YES;
}


/// 开始编辑
- (void)startEdit {
    [self.textField becomeFirstResponder];
}


/// 结束编辑
- (void)endEdit {
    [self.textField endEditing:YES];
}


/// 配置控件
- (void)configureUI {
    // CollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self addSubview:self.collectionView];
    self.collectionView.delegate            = self;
    self.collectionView.dataSource          = self;
    self.collectionView.backgroundColor     = UIColor.clearColor;
    [self.collectionView registerClass:[CWTextFieldViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    // textField
    self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self addSubview:self.textField];
    self.textField.delegate = self;
    self.textField.hidden = YES;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.keyboardType = UIKeyboardTypeNamePhonePad;
    [self bringSubviewToFront:self.collectionView];
    self.inputView = [[CWInputView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 44)];
    if (self.isShowInputAccessoryView) {
        self.textField.inputAccessoryView = self.inputView;
        self.inputView.textField = self.textField;
    }
}


#pragma mark - Setter
- (void)setIsShowInputAccessoryView:(BOOL)isShowInputAccessoryView {
    if (self.isShowInputAccessoryView != isShowInputAccessoryView)
    {
        _isShowInputAccessoryView = isShowInputAccessoryView;
        if (_isShowInputAccessoryView) {
            self.textField.inputAccessoryView = self.inputView;
            self.inputView.textField = self.textField;
        }else {
            self.textField.inputAccessoryView = nil;
            self.inputView.textField = nil;
        }
    }
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.textField.isFirstResponder == YES) {
        NSInteger row = indexPath.row;
        if (row <= self.dataArr.count - 1) {
            UITextPosition *position = [self.textField positionFromPosition:self.textField.beginningOfDocument offset:row];
            UITextRange *range = [self.textField textRangeFromPosition:position toPosition:position];
            [self.textField setSelectedTextRange:range];
            [collectionView reloadData];
        }else if(self.dataArr.count > 0){
            UITextPosition *position = [self.textField positionFromPosition:self.textField.beginningOfDocument offset:self.dataArr.count];
            UITextRange *range = [self.textField textRangeFromPosition:position toPosition:position];
            [self.textField setSelectedTextRange:range];
            [collectionView reloadData];
        }
    }else {
        [self.textField becomeFirstResponder];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CWTextFieldViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    [self configureCell:cell];
    if(self.dataArr.count > 0 && row <= self.dataArr.count - 1) {
        cell.valueLabel.text = self.dataArr[row];
    }else{
        cell.valueLabel.text = @"";
    }
    cell.isCurrent = (row == self.currentIndex && self.textField.isFirstResponder );
    return cell;
}


- (void)configureCell:(CWTextFieldViewCell *)cell {
    cell.valueLabel.textColor   = self.textColor;
    cell.valueLabel.font        = self.textFont;
    cell.selectedColor          = self.lineHighlightedColor;
    cell.normalColor            = self.lineNormalColor;
    [cell resetLineHeight:self.lineHeight];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (CGRectGetWidth(self.frame) - self.textMargin * (self.count - 1)) / self.count;
    CGFloat height = CGRectGetHeight(self.frame);
    return CGSizeMake(width, height);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.textMargin;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    [self.collectionView reloadData];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.collectionView reloadData];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.collectionView reloadData];
    if (self.editComplete) {
        self.editComplete(textField.text);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL tag = YES;
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (str.length > self.count) {
        str = [str substringToIndex:self.count];
        self.textField.text = str;
        tag = NO;
    }
    [self reloadDataArrWithStr:str];
    return tag;
}


- (void)reloadDataArrWithStr:(NSString *)str {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < str.length; i++) {
        unichar s = [str characterAtIndex:i];
        NSString *ss = [NSString stringWithCharacters:&s length:1];
        [arr addObject:ss];
    }
    self.dataArr = arr;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self != nil) {
                [self.collectionView reloadData];
                self.inputView.contentLabel.text = str;
            }
        });
    });
}

#pragma mark - Setter && Getter
- (NSInteger)currentIndex {
    NSInteger offset = [self.textField offsetFromPosition:self.textField.beginningOfDocument toPosition:self.textField.selectedTextRange.start];
//    NSInteger endOffset = [self.textField offsetFromPosition:self.textField.beginningOfDocument toPosition:self.textField.endOfDocument];
//    if (offset == endOffset) {
//        return offset;
//    }else {
        return offset;
//    }
}

@end
