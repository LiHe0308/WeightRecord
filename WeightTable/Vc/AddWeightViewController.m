//
//  AddWeightViewController.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/19.
//

#import "AddWeightViewController.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import "WSDatePickerView.h"
#import "UIView+Toast.h"

@interface AddWeightViewController ()

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIView *view1;

@property (nonatomic, strong) UITextField *weightField;

@property (nonatomic, strong) UIView *view2;

@property (nonatomic, strong) UITextField *tizhiField;

@property (nonatomic, strong) UIView *view3;

@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation AddWeightViewController

- (instancetype)initWithDate:(NSString *)date
                      weight:(NSString *)weight
                       tizhi:(NSString *)tizhi {
    self = [super init];
    if (self) {
        if (date.length > 0 && weight.length > 0 && tizhi.length > 0) {
            self.weightField.text = weight;
            self.tizhiField.text = tizhi;
            self.dateLabel.text = date;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.dateLabel];
    [self.view addSubview:self.weightField];
    [self.view addSubview:self.tizhiField];
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];
    [self.view addSubview:self.view3];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.right.equalTo(@(-30));
        make.top.equalTo(@(120));
    }];
    
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(75));
        make.right.equalTo(@(-75));
        make.top.equalTo(self.dateLabel.mas_bottom).offset(7);
        make.height.offset(1);
    }];
    
    [self.weightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.right.equalTo(@(-30));
        make.top.equalTo(self.view1.mas_bottom).offset(30);
    }];
    
    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(75));
        make.right.equalTo(@(-75));
        make.top.equalTo(self.weightField.mas_bottom).offset(7);
        make.height.offset(1);
    }];
    
    [self.tizhiField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.right.equalTo(@(-30));
        make.top.equalTo(self.view2.mas_bottom).offset(30);
    }];
    
    [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(75));
        make.right.equalTo(@(-75));
        make.top.equalTo(self.tizhiField.mas_bottom).offset(7);
        make.height.offset(1);
    }];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view3.mas_bottom).offset(50);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    self.saveButton.layer.cornerRadius = 30;
    self.saveButton.layer.masksToBounds = 30;
}

- (void)saveBtnClick {
    
    if (self.weightField.text.length <= 0) {
        [self.view makeToast:@"请填写体重" duration:0.5 position:CSToastPositionTop];
        return;
    }
    
    if (self.tizhiField.text.length <= 0) {
        [self.view makeToast:@"请填写体脂率" duration:0.5 position:CSToastPositionTop];
        return;
    }
    
    if (self.saveDailyData) {
        self.saveDailyData(self.dateLabel.text, self.weightField.text, self.tizhiField.text);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)chooseDate {
    __weak typeof(self) ws = self;
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowMonthDay CompleteBlock:^(NSDate *selectDate) {
        NSString *date = [selectDate stringWithFormat:@"YYYY.MM.dd"];
        [ws.dateLabel setText:date];
    }];
    datepicker.dateLabelColor = [UIColor colorWithHexString:@"1296db"];
    datepicker.doneButtonColor = [UIColor colorWithHexString:@"1296db"];
    [datepicker show];
}

- (NSString*)getCurrentTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTime = [formatter stringFromDate:dateNow];
    return currentTime;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.text = [self getCurrentTimes];
        _dateLabel.userInteractionEnabled = YES;
        [_dateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseDate)]];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = [UIColor colorWithHexString:@"1296db"];
    }
    return _dateLabel;
}

- (UITextField *)weightField {
    if (!_weightField) {
        _weightField = [[UITextField alloc] init];
        _weightField.placeholder = @"请输入体重(斤)";
        _weightField.textColor = [UIColor colorWithHexString:@"1296db"];
        _weightField.textAlignment = NSTextAlignmentCenter;
        _weightField.font = [UIFont systemFontOfSize:15];
        _weightField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _weightField;
}

- (UITextField *)tizhiField {
    if (!_tizhiField) {
        _tizhiField = [[UITextField alloc] init];
        _tizhiField.placeholder = @"请输入体脂率(%)";
        _tizhiField.textColor = [UIColor colorWithHexString:@"1296db"];
        _tizhiField.textAlignment = NSTextAlignmentCenter;
        _tizhiField.font = [UIFont systemFontOfSize:15];
        _tizhiField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _tizhiField;
}

- (UIView *)view1 {
    if (!_view1) {
        _view1 = [[UIView alloc] init];
        _view1.backgroundColor = [UIColor colorWithHexString:@"1296db"];
        _view1.alpha = 0.3;
    }
    return _view1;
}

- (UIView *)view2 {
    if (!_view2) {
        _view2 = [[UIView alloc] init];
        _view2.backgroundColor = [UIColor colorWithHexString:@"1296db"];
        _view2.alpha = 0.3;
    }
    return _view2;
}

- (UIView *)view3 {
    if (!_view3) {
        _view3 = [[UIView alloc] init];
        _view3.backgroundColor = [UIColor colorWithHexString:@"1296db"];
        _view3.alpha = 0.3;
    }
    return _view3;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setBackgroundColor:[UIColor colorWithHexString:@"1296db"]];
        [_saveButton setTitle:@"save" forState:0];
        [_saveButton setTitle:@"save" forState:1];
        [_saveButton addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

@end
