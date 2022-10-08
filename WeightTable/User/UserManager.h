//
//  UserManager.h
//  WeightTable
//
//  Created by 李贺 on 2022/9/28.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject

+ (instancetype)shared;

/// 所有用户数据
- (NSArray <UserModel*> *)allUserModels;

/// 更新所有用户数据
- (void)updateUserModels:(NSArray <UserModel*> *)userModels;

/// 当前用户在所有用户中的idx
- (NSInteger)indexForAllUserModels:(UserModel *)userModel;

/// 在所有用户中idx的模型
- (UserModel *)modelForAllUserModels:(NSInteger)index;

- (void)addUser:(UserModel *)model;

@end

NS_ASSUME_NONNULL_END
