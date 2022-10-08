//
//  JListCellView.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/15.
//

#import "JListCellView.h"
#import <Masonry/Masonry.h>

@implementation JListCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


- (void)keyboardWillHide:(NSNotification *)notification{
    if (self.callBack) {
        self.callBack(self.index);
    }
}

- (void)setupUI {
    [self addSubview:self.rootFlexContainer];
    
    [self.rootFlexContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.right.equalTo(@(-15));
        make.top.bottom.equalTo(self);
    }];
    
    [self.rootFlexContainer addSubview:self.titleLabel];
    [self.rootFlexContainer addSubview:self.contentField];
    [self.rootFlexContainer addSubview:self.lineView];
    [self.rootFlexContainer addSubview:self.headPicImageView];
    [self.rootFlexContainer addSubview:self.sexButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rootFlexContainer).offset(15);
        make.centerY.equalTo(self.rootFlexContainer);
    }];
    
    [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rootFlexContainer).offset(-15);
        make.centerY.equalTo(self.rootFlexContainer);
        make.width.equalTo(@(200));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rootFlexContainer).offset(-15);
        make.left.equalTo(self.rootFlexContainer).offset(15);
        make.bottom.equalTo(self.rootFlexContainer);
        make.height.equalTo(@(0.5));
    }];
    
    [self.headPicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rootFlexContainer).offset(-15);
        make.centerY.equalTo(self.rootFlexContainer);
        make.size.mas_offset(CGSizeMake(36, 36));
    }];
    
    [self.sexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rootFlexContainer).offset(-15);
        make.centerY.equalTo(self.rootFlexContainer);
        make.size.mas_offset(CGSizeMake(36, 36));
    }];
}

- (void)sexButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.callBack) {
        self.callBack(self.index);
    }
}

#pragma mark - Getter
- (UIView *)rootFlexContainer {
    if (!_rootFlexContainer) {
        _rootFlexContainer = [[UIView alloc] init];
        _rootFlexContainer.backgroundColor = [UIColor clearColor];
    }
    return _rootFlexContainer;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = ([UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0]);
        _titleLabel.font = ([UIFont fontWithName:@"PingFangSC-Medium" size:(15)]);
    }
    return _titleLabel;
}

- (UITextField *)contentField {
    if (!_contentField) {
        _contentField = [[UITextField alloc] init];
        _contentField.textAlignment = NSTextAlignmentRight;
    }
    return _contentField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = ([UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]);
    }
    return _lineView;
}

- (UIImageView *)headPicImageView {
    if (!_headPicImageView) {
        _headPicImageView = [[UIImageView alloc] init];
        _headPicImageView.backgroundColor = ([UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]);
        _headPicImageView.layer.cornerRadius = 18.f;
        _headPicImageView.clipsToBounds = YES;
    }
    return _headPicImageView;
}

- (UIButton *)sexButton {
    if (!_sexButton) {
        _sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sexButton setTitle:@"男" forState:UIControlStateNormal];
        [_sexButton setTitle:@"女" forState:UIControlStateSelected];
        [_sexButton setTitleColor:[UIColor blackColor] forState:0];
        [_sexButton addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sexButton;
}

@end
