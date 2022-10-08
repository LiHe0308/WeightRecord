//
//  UserModel.h
//  WeightTable
//
//  Created by 李贺 on 2022/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeightDataModel : NSObject

@property (nonatomic, copy) NSString *EnterDate;   // 录入日期
@property (nonatomic, assign) CGFloat bodyWeight;  // 体重
@property (nonatomic, assign) CGFloat bodyFatRate; // 体脂率

@end

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger sex;    // 1男 0女
@property (nonatomic, assign) CGFloat maxGoalWeight;
@property (nonatomic, assign) CGFloat minGoalWeight;
@property (nonatomic, strong) NSArray <WeightDataModel *> *weights;

@end

NS_ASSUME_NONNULL_END
