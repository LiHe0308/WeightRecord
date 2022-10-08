//
//  AddWeightView.h
//  WeightTable
//
//  Created by 李贺 on 2022/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddWeightView : UIView

@property (nonatomic, copy) void(^addDaylyWeight)(void);

@end

NS_ASSUME_NONNULL_END
