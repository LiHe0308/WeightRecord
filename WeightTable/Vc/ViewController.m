//
//  ViewController.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/15.
//

#import "ViewController.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "AddUserViewController.h"
#import "UserInfoCell.h"
#import "UserModel.h"
#import "ListViewController.h"
#import "UserManager.h"

// 1296db

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIBarButtonItem *rightItem;

@property (nonatomic, strong) UITableView     *tableView;

@property (nonatomic, strong) UIButton        *addUserButton;

@property (nonatomic, strong) NSArray         *userModels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dealUI];
}

- (void)setupNav {
    self.navigationItem.title = @"Weight Record";
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8F9"];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addUserButton];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    [self.addUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)dealUI {
    self.userModels = [[UserManager shared] allUserModels];
    if (self.userModels.count > 0) {
        self.addUserButton.hidden = YES;
        self.tableView.hidden = NO;
        self.navigationItem.rightBarButtonItem = self.rightItem;
        [self.tableView reloadData];
    } else {
        self.addUserButton.hidden = NO;
        self.tableView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        [self clearAllUserDefaultsData];
    }
}


- (void)clearAllUserDefaultsData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

// 添加用户
- (void)addUserButtonClick {
    AddUserViewController *addUserVc = [[AddUserViewController alloc] initWithModel:nil];
    [self.navigationController pushViewController:addUserVc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID" forIndexPath:indexPath];
    UserModel *model = self.userModels[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ListViewController *listVc = [[ListViewController alloc] initWithIndex:indexPath.row];
    [self.navigationController pushViewController:listVc animated:YES];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    
    __weak typeof(self) weakSelf = self;
    UIContextualAction *deleteAction1 = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        // 这句很重要，退出编辑模式，隐藏左滑菜单
        [tableView setEditing:NO animated:YES];
        // 删除操作
        NSMutableArray *localUserModels = weakSelf.userModels.mutableCopy;
        [localUserModels removeObjectAtIndex:indexPath.row];
        weakSelf.userModels = localUserModels.copy;
        [[UserManager shared] updateUserModels:weakSelf.userModels];
        [weakSelf dealUI];
    }];
    
    UIContextualAction *deleteAction2 = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [tableView setEditing:NO animated:YES];
        // 编辑操作
        AddUserViewController *addUserVc = [[AddUserViewController alloc] initWithModel:weakSelf.userModels[indexPath.row]];
        [weakSelf.navigationController pushViewController:addUserVc animated:YES];
    }];
    // 只能设置背景颜色，图片，文字
    deleteAction1.backgroundColor = [UIColor colorWithHexString:@"#F7F8F9"];
    deleteAction1.image = [UIImage imageNamed:@"home_cellDelete"];
    
    deleteAction2.backgroundColor = [UIColor colorWithHexString:@"#F7F8F9"];
    deleteAction2.image = [UIImage imageNamed:@"home_cellEdit"];
    
    NSArray<UIContextualAction*> *contextualAction = @[deleteAction1,deleteAction2];
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:contextualAction];
    actions.performsFirstActionWithFullSwipe = NO;       // 禁止侧滑无线拉伸
    return actions;
}

- (UIButton *)addUserButton {
    if (!_addUserButton) {
        _addUserButton = [[UIButton alloc] init];
        [_addUserButton setImage:[UIImage imageNamed:@"home_addUser"] forState:0];
        [_addUserButton setImage:[UIImage imageNamed:@"home_addUser"] forState:1];
        [_addUserButton addTarget:self action:@selector(addUserButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addUserButton;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F8F9"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 96;
        _tableView.separatorStyle = NO;
        [_tableView registerClass:[UserInfoCell class] forCellReuseIdentifier:@"CELL_ID"];
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    }
    return _tableView;
}

- (UIBarButtonItem *)rightItem {
    if (!_rightItem) {
        UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBarBtn setImage:[UIImage imageNamed:@"home_rightItem_addUser"] forState:UIControlStateNormal];
        [leftBarBtn addTarget:self action:@selector(addUserButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    }
    return _rightItem;
}

@end
