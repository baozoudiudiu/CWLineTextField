//
//  ViewController.m
//  CWTextField
//
//  Created by 罗泰 on 2019/3/22.
//  Copyright © 2019 chenwang. All rights reserved.
//

#import "ViewController.h"

#import "CWTextFieldView.h"


@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) CWTextFieldView           *textFieldView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor   = UIColor.groupTableViewBackgroundColor;
    CGFloat width               = CGRectGetWidth(self.view.bounds);
    self.textFieldView          = [[CWTextFieldView alloc] initWithFrame:CGRectMake(20, 100, (width - 40), 30) done:^(NSString * _Nonnull text) {
        NSLog(@"text: %@", text);
    }];
    [self.view addSubview:self.textFieldView];
    self.textFieldView.textMargin = 20;
}
@end
