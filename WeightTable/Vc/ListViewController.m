//
//  ListViewController.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/16.
//

#import "ListViewController.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UserModel.h"
#import "ListCell.h"
#import "AddWeightView.h"
#import "DGPopUpViewController.h"
#import "ListDetailViewController.h"
#import "AddWeightViewController.h"
#import "UserManager.h"
#import "AppDelegate.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIBarButtonItem             *leftItem;

@property (nonatomic, strong) UIBarButtonItem             *rightItem;

@property (nonatomic, strong) AddWeightView               *headerView;

@property (nonatomic, strong) UITableView                 *tableView;

@property (nonatomic, strong) NSArray <WeightDataModel *> *weights;

@property (nonatomic, assign) NSInteger                   index;

@property (nonatomic, strong) UserModel                   *userModel;

@end

@implementation ListViewController

- (instancetype)initWithIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        self.index = index;
        self.userModel = [[UserManager shared] modelForAllUserModels:index];
        self.weights = self.userModel.weights;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
}

- (void)setupNav {
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = self.rightItem;
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - 添加数组

- (void)addDate:(NSString *)date weight:(NSString *)weight tizhi:(NSString *)tizhi {
    AddWeightViewController *addVc = [[AddWeightViewController alloc] initWithDate:date weight:weight tizhi:tizhi];
    __weak typeof(self) weakSelf = self;
    addVc.saveDailyData = ^(NSString * _Nonnull date, NSString * _Nonnull weight, NSString * _Nonnull tizhi) {
        WeightDataModel *weightDataModel = [WeightDataModel new];
        weightDataModel.EnterDate = date;
        weightDataModel.bodyWeight = [weight floatValue];
        weightDataModel.bodyFatRate = [tizhi floatValue];
        [weakSelf addDailyModel:weightDataModel];
    };
    [self presentViewController:addVc animated:YES completion:nil];
}

- (void)addDailyModel:(WeightDataModel *)weightDataModel {
    
    NSMutableArray *localWeights = @[].mutableCopy;
    if (self.weights.count > 0) {
        [localWeights addObjectsFromArray:self.weights];
        __block NSInteger index = -1;
        [self.weights enumerateObjectsUsingBlock:^(WeightDataModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.EnterDate isEqualToString:weightDataModel.EnterDate]) {
                index = idx;
                *stop = YES;
            }
        }];
        
        if (index != -1) {
            [localWeights replaceObjectAtIndex:index withObject:weightDataModel];
        } else {
            [localWeights addObject:weightDataModel];
        }
    } else {
        [localWeights addObject:weightDataModel];
    }
    
    NSArray *weights = [self sortByDes:localWeights.copy];
    self.userModel.weights = weights;
    self.weights = weights;
    
    NSMutableArray *localUserModels = [[UserManager shared] allUserModels].mutableCopy;
    [localUserModels replaceObjectAtIndex:self.index withObject:self.userModel];
    [[UserManager shared] updateUserModels:localUserModels.copy];
    
    [self.tableView reloadData];
}

// 根据日期降序保存, 便于列表展示
- (NSArray *)sortByDes:(NSArray <WeightDataModel *> *)array {
    NSMutableArray <WeightDataModel *> *arrayM = @[].mutableCopy;
    [arrayM addObjectsFromArray:array];
    for (int i = 0; i < [arrayM count] ; i++) {
        for (int j = 0; j < [arrayM count] - i - 1; j++) {
            double date1 = [[NSDate dateWithString:arrayM[j].EnterDate format:@"YYYY.MM.dd"] timeIntervalSince1970];
            double date2 = [[NSDate dateWithString:arrayM[j+1].EnterDate format:@"YYYY.MM.dd"] timeIntervalSince1970];
            if (date1 < date2) {
                WeightDataModel *temp = arrayM[j];
                arrayM[j] = arrayM[j+1];
                arrayM[j+1] = temp;
            }
        }
    }
    return arrayM.copy;
}

#pragma mark - 折线图展示

- (void)lineAction {

    // 折线图日期要升序
    self.weights = [self sortByAes:self.weights];
    NSMutableArray *weights = @[].mutableCopy;
    NSMutableArray *dates = @[].mutableCopy;
    NSMutableArray *tizhis = @[].mutableCopy;
    [self.weights enumerateObjectsUsingBlock:^(WeightDataModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *weight = [NSString stringWithFormat:@"%.1lf", obj.bodyWeight];
        NSString *date = [obj.EnterDate substringFromIndex:5];
        NSString *tizhi = [NSString stringWithFormat:@"%.1lf", obj.bodyFatRate];
        [weights addObject:weight];
        [dates addObject:date];
        [tizhis addObject:tizhi];
    }];

    ListDetailViewController *detailVc = [[ListDetailViewController alloc] initWithMax:self.userModel.maxGoalWeight min:self.userModel.minGoalWeight weights:weights.copy XTitleArray:dates.copy tizhis:tizhis];
    [self.navigationController pushViewController:detailVc animated:YES];
}

// 根据日期升序, 便于折线图展示
- (NSArray *)sortByAes:(NSArray <WeightDataModel *> *)array {
    NSMutableArray <WeightDataModel *> *arrayM = @[].mutableCopy;
    [arrayM addObjectsFromArray:array];
    for (int i = 0; i < [arrayM count] ; i++) {
        for (int j = 0; j < [arrayM count] - i - 1; j++) {
            double date1 = [[NSDate dateWithString:arrayM[j].EnterDate format:@"YYYY.MM.dd"] timeIntervalSince1970];
            double date2 = [[NSDate dateWithString:arrayM[j+1].EnterDate format:@"YYYY.MM.dd"] timeIntervalSince1970];
            if (date1 > date2) {
                WeightDataModel *temp = arrayM[j];
                arrayM[j] = arrayM[j+1];
                arrayM[j+1] = temp;
            }
        }
    }
    return arrayM.copy;
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell_ID" forIndexPath:indexPath];
    cell.weightDataModel = self.weights[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeightDataModel *model = self.weights[indexPath.row];
    [self addDate:model.EnterDate weight:[NSString stringWithFormat:@"%.1lf", model.bodyWeight] tizhi:[NSString stringWithFormat:@"%.1lf", model.bodyFatRate]];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F8F9"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.separatorStyle = NO;
        [_tableView registerClass:[ListCell class] forCellReuseIdentifier:@"ListCell_ID"];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (AddWeightView *)headerView {
    if (!_headerView) {
        _headerView = [[AddWeightView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _headerView.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        _headerView.addDaylyWeight = ^{
            [weakSelf addDate:nil weight:nil tizhi:nil];
        };
    }
    return _headerView;
}

- (UIBarButtonItem *)leftItem {
    if (!_leftItem) {
        UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBarBtn.widthAnchor constraintEqualToConstant:50].active =YES;
        [leftBarBtn.heightAnchor constraintEqualToConstant:25].active =YES;
        [leftBarBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -18, 0, 18)];
        [leftBarBtn setImage:[UIImage imageNamed:@"nav_back_dark"] forState:UIControlStateNormal];
        [leftBarBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        _leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    }
    return _leftItem;
}

- (UIBarButtonItem *)rightItem {
    if (!_rightItem) {
        UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBarBtn setImage:[UIImage imageNamed:@"line"] forState:UIControlStateNormal];
        [leftBarBtn addTarget:self action:@selector(lineAction) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    }
    return _rightItem;
}

@end
