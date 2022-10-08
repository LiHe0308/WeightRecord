//
//  AddWeightView.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/16.
//

#import "AddWeightView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>

@interface AddWeightView ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation AddWeightView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.image = [UIImage imageNamed:@"tianjiashujukubiao"];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.titleLable = [[UILabel alloc] init];
    self.titleLable.text = @"添加(更新)日常数据";
    self.titleLable.textColor = [UIColor colorWithHexString:@"#8B93A6"];
    self.titleLable.font = ([UIFont fontWithName:@"PingFangSC-Regular" size:(12)]);
    
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(5));
        make.left.equalTo(@(15));
        make.bottom.equalTo(@(-5));
        make.right.equalTo(@(-15));
    }];
    
    [bgView addSubview:self.iconView];
    [bgView addSubview:self.titleLable];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.equalTo(bgView.mas_centerX).offset(-15);
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(self.titleLable.mas_left).offset(-5);
        make.size.mas_offset(CGSizeMake(34, 34));
    }];
}

- (void)tapClick {
    if (self.addDaylyWeight) {
        self.addDaylyWeight();
    }
}

@end
