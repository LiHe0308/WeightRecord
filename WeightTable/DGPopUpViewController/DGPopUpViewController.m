//
//  DGPopUpViewController.m
//  DGPopUpViewController
//
//  Created by 段昊宇 on 16/6/17.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "DGPopUpViewController.h"
#import "DGPopUpView.h"

@interface DGPopUpViewController ()

@property (nonatomic, strong) DGPopUpView *popUpView;

@end

@implementation DGPopUpViewController

- (void)showInTarget:(UIViewController *)aVc {
    [self.view addSubview:self.popUpView];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(endAnimation:)
                                                 name: @"confirm"
                                               object: nil];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    __weak typeof(self) ws = self;
    [aVc presentViewController:ws animated:YES completion:^{
        [ws showPopUpView];
    }];
}

- (void)removeAnimation:(NSDictionary *)dic {
    __weak typeof(self) ws = self;
    [ws dismissViewControllerAnimated:YES completion:^{
        if (ws.confirmAction) {
            ws.confirmAction(dic);
        }
    }];
}

- (void)endAnimation:(NSNotification *)noti {
    NSDictionary *dic = noti.object;
    [self removeAnimation:dic];
}

- (void)showPopUpView {
    [UIView animateWithDuration: 0.25
                          delay: 0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
        self.popUpView.transform = CGAffineTransformMakeScale(1, 1);
        self.popUpView.alpha = 1;
    }
                     completion: ^(BOOL finished) {
        
    }];
}

- (DGPopUpView *) popUpView {
    if (!_popUpView) {
        _popUpView = [[DGPopUpView alloc] init];
        _popUpView.center = self.view.center;
        _popUpView.alpha = 0.0;
    }
    return _popUpView;
}

@end
