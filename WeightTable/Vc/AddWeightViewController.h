//
//  AddWeightViewController.h
//  WeightTable
//
//  Created by 李贺 on 2022/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddWeightViewController : UIViewController

- (instancetype)initWithDate:(NSString *)date
                      weight:(NSString *)weight
                       tizhi:(NSString *)tizhi;

@property (nonatomic, copy) void(^saveDailyData)(NSString *date, NSString *weight, NSString *tizhi);

@end

NS_ASSUME_NONNULL_END
