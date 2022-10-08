//
//  JListHeaderView.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/15.
//

#import "JListHeaderView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>

@interface JListHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 74)];
    if (self) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(34);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = ([UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0]);
        _titleLabel.font = ([UIFont fontWithName:@"PingFangSC-Semibold" size:(35)]);
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end
