//
//  ListDetailViewController.h
//  WeightTable
//
//  Created by 李贺 on 2022/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListDetailViewController : UIViewController

- (instancetype)initWithMax:(CGFloat)max min:(CGFloat)min weights:(NSArray *)weights XTitleArray:(NSArray *)xTitles;

@end

NS_ASSUME_NONNULL_END
