//
//  JListCellView.h
//  WeightTable
//
//  Created by 李贺 on 2022/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JListCellView : UIView

@property (nonatomic, strong) UIView *rootFlexContainer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *contentField;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *headPicImageView;
@property (nonatomic, strong) UIButton *sexButton;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) void(^callBack)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
