//
//  ListDetailViewController.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/16.
//

#import "ListDetailViewController.h"
#import "WSLineChartView.h"
#import "AppDelegate.h"
#import <Masonry/Masonry.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "BEMSimpleLineGraphView.h"

@interface ListDetailViewController () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (nonatomic, strong) WSLineChartView *wsLine;

@property (nonatomic, strong) UIBarButtonItem *leftItem;

@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) CGFloat min;
@property (nonatomic, strong) NSArray *weights;
@property (nonatomic, strong) NSArray *xTitles;
@end

@implementation ListDetailViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat w = [[UIScreen mainScreen] bounds].size.width - 44;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height - 49;
    self.wsLine = [[WSLineChartView alloc] initWithFrame:CGRectMake(44, 0, w, h) xTitleArray:self.xTitles yValueArray:self.weights yMax:self.max yMin:self.min yTypeName:@"体重" xTypeName:@"日期" unit:@"斤"];
    [self.view addSubview:self.wsLine];
}

- (instancetype)initWithMax:(CGFloat)max min:(CGFloat)min weights:(NSArray *)weights XTitleArray:(NSArray *)xTitles  {
    self = [super init];
    if (self) {
        self.max = max;
        self.min = min;
        self.weights = weights;
        self.xTitles = xTitles;
    }
    return self;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"体重折线图";
    
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_interactivePopDisabled = YES;
    
//    BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(15, 0, 320, 260)];
//    myGraph.dataSource = self;
//    myGraph.delegate = self;
//
//    myGraph.enableXAxisLabel = YES;
//    myGraph.colorXaxisLabel = [UIColor blackColor];
//    myGraph.colorBackgroundXaxis = [UIColor yellowColor];
//
//    myGraph.colorTop = [UIColor whiteColor];
//    myGraph.colorBottom = [UIColor colorWithRed:190/255.0 green:218/255.0 blue:246/255.0 alpha:1];
//    myGraph.colorLine = [UIColor colorWithRed:124/255.0 green:181/255.0 blue:236/255.0 alpha:1];
//    myGraph.colorPoint = [UIColor colorWithRed:124/255.0 green:181/255.0 blue:236/255.0 alpha:1];
//    myGraph.widthLine = 3;
//    myGraph.sizePoint = 10;
//    myGraph.alwaysDisplayDots = YES;
//    myGraph.colorReferenceLines = [UIColor lightGrayColor];
//    myGraph.enableLeftReferenceAxisFrameLine = NO;
//    myGraph.enablePopUpReport = YES;
//    myGraph.enableReferenceAxisFrame = YES;
//    myGraph.enableBezierCurve = YES;
//    myGraph.enableTouchReport = YES;
//    myGraph.alwaysDisplayPopUpLabels = YES;
//    [self.view addSubview:myGraph];
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.xTitles.count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    NSString *weight = self.weights[index];
    return [weight floatValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    if (index % 2 == 0) {
        return self.xTitles[index];
    } else {
        return @"";
    }
}

//- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
//    return 2;
//}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    // 即将开始转屏
    [self viewWillBeginTransitionWithSize:size];
    __weak typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [weakSelf viewDidEndTransitionWithSize:size];
    }];
}
/// 子视图即将开始旋转
- (void)viewWillBeginTransitionWithSize:(CGSize)size {
    [self.wsLine removeFromSuperview];
}
/// 子视图旋转完成
- (void)viewDidEndTransitionWithSize:(CGSize)size {
    if (size.width > size.height) { // 横屏
        CGFloat w = [[UIScreen mainScreen] bounds].size.width - 44;
        CGFloat h = [[UIScreen mainScreen] bounds].size.height - 49;
        self.wsLine = [[WSLineChartView alloc] initWithFrame:CGRectMake(44, 0, w, h) xTitleArray:self.xTitles yValueArray:self.weights yMax:self.max yMin:self.min yTypeName:@"体重" xTypeName:@"日期" unit:@"斤"];
    } else {
        CGFloat w = [[UIScreen mainScreen] bounds].size.width;
        self.wsLine = [[WSLineChartView alloc] initWithFrame:CGRectMake(0, 0, w, w) xTitleArray:self.xTitles yValueArray:self.weights yMax:self.max yMin:self.min yTypeName:@"体重" xTypeName:@"日期" unit:@"斤"];
    }
    [self.view addSubview:self.wsLine];
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

- (void)pop:(UIButton *)sender {
    [AppDelegate setInterfaceOrientation:UIInterfaceOrientationPortrait];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
