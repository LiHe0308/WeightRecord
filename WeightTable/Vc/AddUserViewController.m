//
//  AddUserViewController.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/15.
//

#import "AddUserViewController.h"
#import "JListView.h"
#import "JListHeaderView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import "JListCellView.h"
#import "UserModel.h"
#import <SDWebImage/SDWebImage.h>
#import "UserManager.h"
#import "ListViewController.h"

@interface AddUserViewController () <JListViewDelegate>

@property (nonatomic, strong) UIBarButtonItem       *leftItem;
@property (nonatomic, strong) JListView             *jList;
@property (nonatomic, strong) JListHeaderView       *headerView;
@property (nonatomic, strong) UserModel             *userModel;
@property (nonatomic, strong) NSArray               *cellTitles;
@property (nonatomic, strong) NSArray <UserModel *> *userModels;
@property (nonatomic, assign) BOOL                  isUpdate;
@property (nonatomic, assign) BOOL                  isSameName;
@property (nonatomic, assign) NSInteger             currentModelIndex;

@end

@implementation AddUserViewController

- (instancetype)initWithModel:(UserModel *)userModel {
    self = [super init];
    if (self) {
        self.cellTitles = @[@"头像",
                            @"姓名",
                            @"性别",
                            @"最大目标体重(斤)",
                            @"最小目标体重(斤)"];
        
        self.userModels = [[UserManager shared] allUserModels];
        self.userModel  = userModel;
        self.isUpdate   = YES;
        self.currentModelIndex = [[UserManager shared] indexForAllUserModels:self.userModel];
        
        if (!self.userModel) {
            // 初始化新用户默认值
            self.isUpdate         = NO;
            NSArray *imgsAry      = @[@"t1.png",@"t3.png"];
            NSInteger randomIndex = arc4random()%imgsAry.count;
    
            self.userModel        = [UserModel new];
            self.userModel.icon   = [imgsAry objectAtIndex:randomIndex];
            self.userModel.name   = [NSString stringWithFormat:@"用户%02lu", self.userModels.count + 1];
            self.userModel.sex    = 1;
            self.userModel.maxGoalWeight = 160.0;
            self.userModel.minGoalWeight = 140.0;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
    [self.jList reloadData];
}

- (void)setupNav {
    self.navigationItem.leftBarButtonItem = self.leftItem;
}

- (void)setupUI{
    self.jList.JListViewheadView = self.headerView;
    [self.view addSubview:self.jList];
    [self.jList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
}

#pragma mark -- JListView section个数
- (NSInteger)JListViewNumberForSection{
    return 2;
}

#pragma mark -- JListView cell个数
- (NSInteger)JListViewNumberOfCellForSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 0;
}

#pragma mark -- JListView cell高度
- (CGFloat)JListViewCellHeightWithSection:(NSInteger)section row:(NSInteger)row{
    return 60;
}

#pragma mark -- JListView headView高度
- (CGFloat)JListViewOfHeaderViewHeightWithSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 65;
    } else {
        return 0;
    }
}

#pragma mark -- JListView 分区圆角
- (CGFloat)JListViewSectionCornerRadiusWithSection:(NSInteger)section{
    return 8;
}

#pragma mark -- JListView headView高度
- (UIColor *)JListViewSectionShaowColorWithSection:(NSInteger)section{
    return [UIColor colorWithWhite:0 alpha:0.1];
}

#pragma mark -- JListView headView样式
- (UIView *)JListViewOfHeadViewWithSection:(NSInteger)section{
    if (section == 1) {
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        UIButton *deleteBtn = [[UIButton alloc] init];
        deleteBtn.clipsToBounds = YES;
        deleteBtn.layer.cornerRadius = 23;
        deleteBtn.titleLabel.font = ([UIFont fontWithName:@"PingFangSC-Semibold" size:(18)]);
        deleteBtn.frame = CGRectMake(15, 30, kScreenWidth-30, 45);
        [deleteBtn setTitle:@"确定" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1296db"]] forState:UIControlStateNormal];
        [cellView addSubview:deleteBtn];
        return cellView;
    }
    return [UIView new];
}

#pragma mark -- JListView cell样式
- (UIView *)JListViewForCell:(NSIndexPath *)indexPath{
    
    JListCellView * cellView = [[JListCellView alloc] init];
    cellView.index = indexPath.row;
    cellView.titleLabel.text = self.cellTitles[indexPath.row];
    
    if (indexPath.row == 0) {
        cellView.contentField.hidden = YES;
        cellView.sexButton.hidden = YES;
        cellView.headPicImageView.hidden = NO;
    } else if (indexPath.row == 2){
        cellView.contentField.hidden = YES;
        cellView.sexButton.hidden = NO;
        cellView.headPicImageView.hidden = YES;
    } else {
        cellView.contentField.hidden = NO;
        cellView.sexButton.hidden = YES;
        cellView.headPicImageView.hidden = YES;
    }
    
    if (indexPath.row == 4) {
        cellView.lineView.hidden = YES;
    } else {
        cellView.lineView.hidden = NO;
    }
    
    cellView.backgroundColor = [UIColor whiteColor];
    cellView.frame = CGRectMake(15, 0, kScreenWidth-30, 0);
    
    cellView.contentField.keyboardType = UIKeyboardTypeDecimalPad;
    NSString *content;
    switch (indexPath.row) {
        case 0:
            [cellView.headPicImageView setImage:[UIImage imageNamed:self.userModel.icon]];
            break;
        case 1:
            content = self.userModel.name;
            cellView.contentField.keyboardType = UIKeyboardTypeDefault;
            break;
        case 2:
            content = self.userModel.sex == 1 ? @"男" : @"女";
            cellView.sexButton.selected = self.userModel.sex == 0;
            break;
        case 3:
            content = [NSString stringWithFormat:@"%.1lf", self.userModel.maxGoalWeight];
            break;
        case 4:
            content = [NSString stringWithFormat:@"%.1lf", self.userModel.minGoalWeight];
            break;
        default:
            break;
    }
    cellView.contentField.text = content;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(cellView) cv = cellView;
    cellView.callBack = ^(NSInteger index) {
        switch (index) {
            case 1:
                weakSelf.userModel.name = cv.contentField.text;
                break;
            case 2:
            {
                weakSelf.userModel.sex = cv.sexButton.selected ? 0 : 1;
                NSArray *imgsAry = weakSelf.userModel.sex == 1 ? @[@"t1.png",@"t3.png"] : @[@"t2.png",@"t4.png"];
                NSInteger randomIndex = arc4random()%imgsAry.count;
                weakSelf.userModel.icon = [imgsAry objectAtIndex:randomIndex];
                [weakSelf.jList reloadData];
            }
                break;
            case 3:
                weakSelf.userModel.maxGoalWeight = cv.contentField.text.floatValue;
                break;
            case 4:
                weakSelf.userModel.minGoalWeight = cv.contentField.text.floatValue;
                break;
            default:
                break;
        }
    };
    return cellView;
}

- (void)JListViewDidScroll:(CGFloat)offSetY {
    if (offSetY < 0) {
        [self.view setNeedsLayout];
    }
    if (offSetY >= 30) {
        self.navigationItem.title = @"用户信息";
    } else {
        self.navigationItem.title = nil;
    }
}

- (JListView *)jList{
    if(!_jList){
        _jList = [[JListView alloc]init];
        _jList.backgroundColor = [UIColor whiteColor];
        _jList.delegate = self;
        _jList.autoAdaptation = NO;
        _jList.separatorStyle = YES;
    }
    return _jList;
}

- (JListHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JListHeaderView alloc] initWithFrame:CGRectZero];
        _headerView.title = @"添加用户";
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

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction {
    
    NSMutableArray *localUserModels = @[].mutableCopy;
    [localUserModels addObjectsFromArray:self.userModels];
    
    __weak typeof(self) weakSelf = self;
    if (self.isUpdate && self.currentModelIndex != -1) {
        [localUserModels replaceObjectAtIndex:self.currentModelIndex withObject:weakSelf.userModel];
    } else {
        if (self.userModels.count > 0) {
            [self uniqueName];
        }
        [localUserModels addObject:self.userModel];
    }
    
    [[UserManager shared] updateUserModels:localUserModels.copy];

    if (self.isUpdate) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // 进入子页面添加weights 数据
        NSInteger idx = [[UserManager shared] indexForAllUserModels:self.userModel];
        ListViewController *listVc = [[ListViewController alloc] initWithIndex:idx];
        
        NSMutableArray *tempMutableArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in tempMutableArray) {
            if (vc == self) {
                [tempMutableArray removeObject:vc];
                break;
            }
        }
        [tempMutableArray addObject:listVc];
        [self.navigationController setViewControllers:tempMutableArray animated:YES];
    }
}

// 使用户名唯一
- (void)uniqueName {
    
    __weak typeof(self) weakSelf = self;
    self.isSameName = NO;
    [self.userModels enumerateObjectsUsingBlock:^(UserModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqual:weakSelf.userModel.name]) {
            // 同名用户追加随机数字
            NSInteger randomIndex = arc4random()%1000000;
            weakSelf.userModel.name = [NSString stringWithFormat:@"%@%ld", weakSelf.userModel.name, (long)randomIndex];
            weakSelf.isSameName = YES;
            *stop = YES;
        }
    }];
    
    if (self.isSameName) {
        [self uniqueName];
    }
}

@end
