//
//  ListDetailViewController.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/16.
//

#import "ListDetailViewController.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import "ORLineChartView.h"


@interface ListDetailViewController () <ORLineChartViewDataSource, ORLineChartViewDelegate>

@property (nonatomic, strong) ORLineChartView *lineChartView;

@property (nonatomic, strong) UIBarButtonItem *leftItem;

@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) CGFloat min;
@property (nonatomic, strong) NSArray *weights;
@property (nonatomic, strong) NSArray *xTitles;
@property (nonatomic, strong) NSArray *tizhis;

@property (nonatomic, strong) ORLineChartView *weightView;
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) ORLineChartView *tizhiView;
@property (nonatomic, strong) UILabel *tizhiLabel;

@end

@implementation ListDetailViewController

- (instancetype)initWithMax:(CGFloat)max min:(CGFloat)min weights:(NSArray *)weights XTitleArray:(NSArray *)xTitles tizhis:(NSArray *)tizhis {
    self = [super init];
    if (self) {
        self.max = max;
        self.min = min;
        self.weights = weights;
        self.xTitles = xTitles;
        self.tizhis = tizhis;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据折线图";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.weightView];
    [self.view addSubview:self.weightLabel];
    [self.view addSubview:self.tizhiView];
    [self.view addSubview:self.tizhiLabel];
    
    [self.weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.weightView.mas_bottom).offset(10);
    }];
    
    [self.tizhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.tizhiView.mas_bottom).offset(10);
    }];
}

#pragma mark - ORLineChartViewDataSource

- (NSInteger)numberOfHorizontalDataOfChartView:(ORLineChartView *)chartView {
    if (chartView == self.weightView) {
        return _weights.count;
    }
    return _tizhis.count;
}

- (CGFloat)chartView:(ORLineChartView *)chartView valueForHorizontalAtIndex:(NSInteger)index {
    if (chartView == self.weightView) {
        return [_weights[index] floatValue];
    }
    return [_tizhis[index] floatValue];
}

- (NSInteger)numberOfVerticalLinesOfChartView:(ORLineChartView *)chartView {
    return 6;
}

- (NSAttributedString *)chartView:(ORLineChartView *)chartView attributedStringForIndicaterAtIndex:(NSInteger)index {
    if (chartView == self.weightView) {
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1lf斤", [_weights[index] floatValue]]];
        return string;
    }
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1lf%%", [_tizhis[index] floatValue]]];
    return string;
}

- (NSString *)chartView:(ORLineChartView *)chartView titleForHorizontalAtIndex:(NSInteger)index {
    return _xTitles[index];
}

- (NSDictionary<NSAttributedStringKey,id> *)labelAttrbutesForVerticalOfChartView:(ORLineChartView *)chartView {
    if (chartView == self.weightView) {
        return @{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#1296db"]};
    }
    return @{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#32CD32"]};
}

- (NSDictionary<NSAttributedStringKey,id> *)labelAttrbutesForHorizontalOfChartView:(ORLineChartView *)chartView {
    if (chartView == self.weightView) {
        return @{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#1296db"]};
    }
    return @{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#32CD32"]};
}

- (void)pop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)leftItem {
    if (!_leftItem) {
        UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBarBtn.widthAnchor constraintEqualToConstant:50].active =YES;
        [leftBarBtn.heightAnchor constraintEqualToConstant:25].active =YES;
        [leftBarBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -18, 0, 18)];
        [leftBarBtn setImage:[UIImage imageNamed:@"nav_back_dark"] forState:UIControlStateNormal];
        [leftBarBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
        _leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    }
    return _leftItem;
}

- (ORLineChartView *)weightView {
    if (!_weightView) {
        _weightView = [[ORLineChartView alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30, 300)];
        _weightView.dataSource = self;
        _weightView.delegate = self;
        
        _weightView.config.style = ORLineChartStyleControl;
        _weightView.config.gradientLocations = @[@(0.6), @(1.0)];

        _weightView.config.chartLineColor = [[UIColor colorWithHexString:@"#1296db"] colorWithAlphaComponent:0.5];
        _weightView.config.showVerticalBgline = NO;
        _weightView.config.showShadowLine = NO;
        _weightView.config.gradientColors = @[[[UIColor colorWithHexString:@"#1296db"] colorWithAlphaComponent:0.4], [[UIColor whiteColor] colorWithAlphaComponent:0.7]];
        
        _weightView.config.indicatorContentInset = 5;
        _weightView.config.indicatorTintColor = [[UIColor colorWithHexString:@"#1296db"] colorWithAlphaComponent:0.5];
        _weightView.config.indicatorLineColor = [[UIColor colorWithHexString:@"#1296db"] colorWithAlphaComponent:0.5];
        _weightView.config.topInset = -20;
        _weightView.config.leftWidth = 44;
        _weightView.config.animateDuration = 1.5;
        _weightView.defaultSelectIndex = self.weights.count - 1;
    }
    return _weightView;
}

- (ORLineChartView *)tizhiView {
    if (!_tizhiView) {
        _tizhiView = [[ORLineChartView alloc] initWithFrame:CGRectMake(15, 330, [UIScreen mainScreen].bounds.size.width - 30, 300)];
        _tizhiView.dataSource = self;
        _tizhiView.delegate = self;
        
        _tizhiView.config.style = ORLineChartStyleControl;
        _tizhiView.config.gradientLocations = @[@(0.6), @(1.0)];

        _tizhiView.config.chartLineColor = [[UIColor colorWithHexString:@"#32CD32"] colorWithAlphaComponent:0.5];
        _tizhiView.config.showVerticalBgline = NO;
        _tizhiView.config.showShadowLine = NO;
        _tizhiView.config.gradientColors = @[[[UIColor colorWithHexString:@"#32CD32"] colorWithAlphaComponent:0.4], [[UIColor whiteColor] colorWithAlphaComponent:0.7]];
        
        _tizhiView.config.indicatorContentInset = 5;
        _tizhiView.config.indicatorTintColor = [[UIColor colorWithHexString:@"#32CD32"] colorWithAlphaComponent:0.5];
        _tizhiView.config.indicatorLineColor = [[UIColor colorWithHexString:@"#32CD32"] colorWithAlphaComponent:0.5];
        _tizhiView.config.topInset = -20;
        _tizhiView.config.leftWidth = 44;
        _tizhiView.config.animateDuration = 1.5;
        _tizhiView.defaultSelectIndex = self.weights.count - 1;
    }
    return _tizhiView;
}

- (UILabel *)weightLabel {
    if (!_weightLabel) {
        _weightLabel = [[UILabel alloc] init];
        _weightLabel.textColor = [UIColor colorWithHexString:@"#8B93A6"];
        _weightLabel.font = ([UIFont fontWithName:@"PingFangSC-Regular" size:(13)]);
        _weightLabel.text = @"体重折线图(斤/日期)";
    }
    return _weightLabel;
}

- (UILabel *)tizhiLabel {
    if (!_tizhiLabel) {
        _tizhiLabel = [[UILabel alloc] init];
        _tizhiLabel.textColor = [UIColor colorWithHexString:@"#8B93A6"];
        _tizhiLabel.font = ([UIFont fontWithName:@"PingFangSC-Regular" size:(13)]);
        _tizhiLabel.text = @"体脂折线图(%/日期)";
    }
    return _tizhiLabel;
}

@end
