//
//  ListCell.h
//  WeightTable
//
//  Created by 李贺 on 2022/9/16.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListCell : UITableViewCell

@property (nonatomic, strong) WeightDataModel *weightDataModel;

@end

NS_ASSUME_NONNULL_END
