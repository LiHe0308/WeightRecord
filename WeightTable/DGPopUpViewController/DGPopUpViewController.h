//
//  DGPopUpViewController.h
//  DGPopUpViewController
//
//  Created by 段昊宇 on 16/6/17.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DGPopUpViewController : UIViewController

- (void)showInTarget:(UIViewController *)aVc;

@property (nonatomic, copy) void(^confirmAction)(NSDictionary *dic);

@end
