//
//  UserManager.m
//  WeightTable
//
//  Created by 李贺 on 2022/9/28.
//

#import "UserManager.h"

@interface UserManager ()

@property (nonatomic, copy) NSString *app_Name;

@end

@implementation UserManager

+ (instancetype)shared {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
        self.app_Name = app_Name;
    }
    return self;
}

- (NSArray <UserModel*> *)allUserModels {
    
    NSUbiquitousKeyValueStore *iCouldStore = [NSUbiquitousKeyValueStore defaultStore];
    [iCouldStore synchronize];
    NSArray *loaclUserModels = [iCouldStore objectForKey:self.app_Name];
//    NSArray *loaclUserModels = [[NSUserDefaults standardUserDefaults] valueForKey:self.app_Name];
    NSArray *userModels = [UserModel mj_objectArrayWithKeyValuesArray:loaclUserModels];
    return userModels;
}

- (void)updateUserModels:(NSArray <UserModel*> *)userModels {
    NSArray *loaclUserModels = [UserModel mj_keyValuesArrayWithObjectArray:userModels];
    NSUbiquitousKeyValueStore *iCouldStore = [NSUbiquitousKeyValueStore defaultStore];
    [iCouldStore synchronize];
    [iCouldStore setArray:loaclUserModels forKey:self.app_Name];
//    [[NSUserDefaults standardUserDefaults] setValue:loaclUserModels forKey:self.app_Name];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)indexForAllUserModels:(UserModel *)userModel {
    NSArray *userModels = [self allUserModels];
    __block NSInteger index = -1;
    [userModels enumerateObjectsUsingBlock:^(UserModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqual:userModel.name]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (UserModel *)modelForAllUserModels:(NSInteger)index {
    NSArray *userModels = [self allUserModels];
    return userModels[index];
}

- (void)addUser:(UserModel *)model {
    
}

@end
