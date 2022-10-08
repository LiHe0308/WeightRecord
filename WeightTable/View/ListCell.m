//
//  ListCell.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/16.
//

#import "ListCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

@interface ListCell ()

@property (nonatomic, strong) UIImageView *dateImageView;

@property (nonatomic, strong) UILabel     *dateLabel;

@property (nonatomic, strong) UIImageView *weightImageView;

@property (nonatomic, strong) UILabel     *weightLabel;

@property (nonatomic, strong) UIImageView *tizhiImageView;

@property (nonatomic, strong) UILabel     *tizhiLabel;

@property (nonatomic, strong) UIView      *lineView;

@end

@implementation ListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.weightImageView];
    [self.contentView addSubview:self.weightLabel];
    [self.contentView addSubview:self.dateImageView];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.tizhiImageView];
    [self.contentView addSubview:self.tizhiLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.dateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.dateImageView.mas_right).offset(5);
    }];
    
    [self.weightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_centerX).offset(-25);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
    
    [self.weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.weightImageView.mas_right).offset(5);
    }];
    
    [self.tizhiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.weightImageView.mas_right).offset(90);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
    
    [self.tizhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.tizhiImageView.mas_right).offset(5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_offset(0.5);
    }];
}

- (void)setWeightDataModel:(WeightDataModel *)weightDataModel {
    _weightDataModel = weightDataModel;
    
    self.dateLabel.text = weightDataModel.EnterDate;
    self.weightLabel.text = [NSString stringWithFormat:@"%.1lf", weightDataModel.bodyWeight];
    self.tizhiLabel.text = [NSString stringWithFormat:@"%.1lf", weightDataModel.bodyFatRate];
}

- (UIImageView *)dateImageView {
    if (!_dateImageView) {
        _dateImageView = [[UIImageView alloc] init];
        _dateImageView.image = [UIImage imageNamed:@"dateIV"];
    }
    return _dateImageView;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor colorWithHexString:@"#8B93A6"];
        _dateLabel.font = ([UIFont fontWithName:@"PingFangSC-Regular" size:(12)]);
    }
    return _dateLabel;
}

- (UIImageView *)weightImageView {
    if (!_weightImageView) {
        _weightImageView = [[UIImageView alloc] init];
        _weightImageView.image = [UIImage imageNamed:@"tizhong"];
    }
    return _weightImageView;
}

- (UILabel *)weightLabel {
    if (!_weightLabel) {
        _weightLabel = [[UILabel alloc] init];
        _weightLabel.textColor = [UIColor colorWithHexString:@"#8B93A6"];
        _weightLabel.font = ([UIFont fontWithName:@"PingFangSC-Regular" size:(12)]);
    }
    return _weightLabel;
}

- (UIImageView *)tizhiImageView {
    if (!_tizhiImageView) {
        _tizhiImageView = [[UIImageView alloc] init];
        _tizhiImageView.image = [UIImage imageNamed:@"tizhi"];
    }
    return _tizhiImageView;
}

- (UILabel *)tizhiLabel {
    if (!_tizhiLabel) {
        _tizhiLabel = [[UILabel alloc] init];
        _tizhiLabel.textColor = [UIColor colorWithHexString:@"#8B93A6"];
        _tizhiLabel.font = ([UIFont fontWithName:@"PingFangSC-Regular" size:(12)]);
    }
    return _tizhiLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#1296db"];
        _lineView.alpha = 0.4;
    }
    return _lineView;
}

@end
