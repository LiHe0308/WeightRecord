//
//  UserInfoCell.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/15.
//

#import "UserInfoCell.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>

@interface UserInfoCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iv;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *weightIv;

@property (nonatomic, strong) UILabel *weightLabel;

@property (nonatomic, strong) UIImageView *weightStateImageView;

@property (nonatomic, strong) UILabel *weightStateLabel;

@property (nonatomic, strong) UIImageView *tizhiIv;

@property (nonatomic, strong) UILabel *tizhiLabel;

@property (nonatomic, strong) UIImageView *tizhiStateImageView;

@property (nonatomic, strong) UILabel *tizhiStateLabel;

@end

@implementation UserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.bgView addSubview:self.iv];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.weightIv];
    [self.bgView addSubview:self.weightLabel];
    [self.bgView addSubview:self.tizhiIv];
    [self.bgView addSubview:self.tizhiLabel];
    [self.bgView addSubview:self.weightStateImageView];
    [self.bgView addSubview:self.weightStateLabel];
    [self.bgView addSubview:self.tizhiStateImageView];
    [self.bgView addSubview:self.tizhiStateLabel];
    
    [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(15);
        make.size.mas_offset(CGSizeMake(65, 65));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iv.mas_top);
        make.left.equalTo(self.iv.mas_right).offset(15);
    }];
    
    [self.weightIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.left.equalTo(self.iv.mas_right).offset(15);
        make.size.mas_offset(CGSizeMake(14, 14));
    }];
    
    [self.weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weightIv);
        make.left.equalTo(self.weightIv.mas_right).offset(5);
        make.width.equalTo(@(90));
    }];
    
    [self.tizhiIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weightIv);
        make.size.mas_offset(CGSizeMake(14, 14));
        make.left.equalTo(self.weightLabel.mas_right).offset(15);
    }];
    
    [self.tizhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weightIv);
        make.left.equalTo(self.tizhiIv.mas_right).offset(5);
        make.width.equalTo(@(90));
    }];
    
    [self.weightStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weightIv.mas_bottom).offset(11);
        make.left.equalTo(self.iv.mas_right).offset(15);
        make.size.mas_offset(CGSizeMake(14, 14));
    }];
    
    [self.weightStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weightStateImageView);
        make.left.equalTo(self.weightStateImageView.mas_right).offset(5);
        make.width.equalTo(@(90));
    }];
    
    [self.tizhiStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weightStateImageView);
        make.size.mas_offset(CGSizeMake(14, 14));
        make.left.equalTo(self.weightStateLabel.mas_right).offset(15);
    }];
    
    [self.tizhiStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weightStateImageView);
        make.left.equalTo(self.tizhiStateImageView.mas_right).offset(5);
        make.width.equalTo(@(90));
    }];
}

- (void)setModel:(UserModel *)model {
    _model = model;
    self.iv.image = [UIImage imageNamed:model.icon];
    self.nameLabel.text = model.name;
    
    if (model.weights.count > 0) {
        NSArray <WeightDataModel *> *weightDataModels = model.weights;

        // weights数据是最新的最前面, 所以最新数据为:
        WeightDataModel *firstM = weightDataModels.firstObject;
        
        self.weightLabel.text = [NSString stringWithFormat:@"%.1f", firstM.bodyWeight];
        self.tizhiLabel.text = [NSString stringWithFormat:@"%.1f%%", firstM.bodyFatRate];
        
        // 最旧为:
        WeightDataModel *lastM = weightDataModels.lastObject;
    
        // 体重增减:
        CGFloat weightDif = firstM.bodyWeight - lastM.bodyWeight;
        NSString *placeHoldeW;
        if (weightDif > 0 ) {
            placeHoldeW = @"shangsheng";
        } else if (weightDif == 0) {
            placeHoldeW = @"hold";
        } else {
            placeHoldeW = @"xiajiang";
        }
        self.weightStateImageView.image = [UIImage imageNamed:placeHoldeW];
        self.weightStateLabel.text = [NSString stringWithFormat:@"%.1lf", fabs(weightDif)];
        
        // 体脂增减:
        CGFloat tizhiDif = firstM.bodyFatRate - lastM.bodyFatRate;
        NSString *placeHoldeT;
        if (tizhiDif > 0 ) {
            placeHoldeT = @"shangsheng";
        } else if (tizhiDif == 0) {
            placeHoldeT = @"hold";
        } else {
            placeHoldeT = @"xiajiang";
        }
        self.tizhiStateImageView.image = [UIImage imageNamed:placeHoldeT];
        self.tizhiStateLabel.text = [NSString stringWithFormat:@"%.1lf%%", fabs(tizhiDif)];
    } else {
        _tizhiStateLabel.text = @"-";
        _tizhiLabel.text = @"-";
        _weightLabel.text = @"-";
        _weightStateLabel.text = @"-";
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 12;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#535353"];
        _nameLabel.font = ([UIFont fontWithName:@"PingFangSC-Medium" size:(16)]);
    }
    return _nameLabel;
}

- (UIImageView *)iv {
    if (!_iv) {
        _iv = [[UIImageView alloc] init];
        _iv.layer.cornerRadius = 20.0;
        _iv.layer.masksToBounds = YES;
    }
    return _iv;
}

- (UIImageView *)weightIv {
    if (!_weightIv) {
        _weightIv = [[UIImageView alloc] init];
        _weightIv.image = [UIImage imageNamed:@"tizhong"];
    }
    return _weightIv;
}

- (UILabel *)weightLabel {
    if (!_weightLabel) {
        _weightLabel = [[UILabel alloc] init];
        _weightLabel.textColor = [UIColor colorWithHexString:@"#8B93A6"];
        _weightLabel.font = ([UIFont fontWithName:@"PingFangSC-Regular" size:(13)]);
    }
    return _weightLabel;
}

- (UIImageView *)weightStateImageView {
    if (!_weightStateImageView) {
        _weightStateImageView = [[UIImageView alloc] init];
        _weightStateImageView.image = [UIImage imageNamed:@"hold"];
    }
    return _weightStateImageView;
}

- (UILabel *)weightStateLabel {
    if (!_weightStateLabel) {
        _weightStateLabel = [[UILabel alloc] init];
        _weightStateLabel.textColor = [UIColor colorWithHexString:@"#8B93A6"];
        _weightStateLabel.font = ([UIFont fontWithName:@"PingFangSC-Regular" size:(13)]);
    }
    return _weightStateLabel;
}

- (UIImageView *)tizhiIv {
    if (!_tizhiIv) {
        _tizhiIv = [[UIImageView alloc] init];
        _tizhiIv.image = [UIImage imageNamed:@"tizhi"];
    }
    return _tizhiIv;
}

- (UILabel *)tizhiLabel {
    if (!_tizhiLabel) {
        _tizhiLabel = [[UILabel alloc] init];
        _tizhiLabel.textColor = [UIColor colorWithHexString:@"#8B93A6"];
        _tizhiLabel.font = ([UIFont fontWithName:@"PingFangSC-Regular" size:(13)]);
    }
    return _tizhiLabel;
}

- (UIImageView *)tizhiStateImageView {
    if (!_tizhiStateImageView) {
        _tizhiStateImageView = [[UIImageView alloc] init];
        _tizhiStateImageView.image = [UIImage imageNamed:@"hold"];
    }
    return _tizhiStateImageView;
}

- (UILabel *)tizhiStateLabel {
    if (!_tizhiStateLabel) {
        _tizhiStateLabel = [[UILabel alloc] init];
        _tizhiStateLabel.textColor = [UIColor colorWithHexString:@"#8B93A6"];
        _tizhiStateLabel.font = ([UIFont fontWithName:@"PingFangSC-Regular" size:(13)]);
    }
    return _tizhiStateLabel;
}

@end
