//
//  DGPopUpView.m
//  DGPopUpViewController
//
//  Created by 段昊宇 on 16/6/18.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "DGPopUpView.h"
#import "DGPopUpViewLoginButton.h"
#import "DGPopUpViewTextView.h"
#import <Masonry/Masonry.h>

@interface DGPopUpView()

@property (nonatomic, strong) UILabel *popViewTitle;
@property (nonatomic, strong) DGPopUpViewLoginButton *loginButton;
@property (nonatomic, strong) DGPopUpViewTextView *textView;
@property (nonatomic, strong) DGPopUpViewTextView *textView_2;

@end

@implementation DGPopUpView

#pragma mark - Overide
- (instancetype) initWithFrame: (CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 300)]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowOffset = CGSizeMake(0.2, 0.2);
        
        self.loginButton = [[DGPopUpViewLoginButton alloc] init];
        [self addSubview: self.loginButton];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(closeAnimation)
                                                     name: @"NEXT_Button"
                                                   object: nil];
        
        self.textView = [[DGPopUpViewTextView alloc] initWithName: @"Body weight"];
        self.textView_2 = [[DGPopUpViewTextView alloc] initWithName: @"Body fat percentage"];
        [self addSubview: self.textView];
        [self addSubview: self.textView_2];
        
        self.popViewTitle = [[UILabel alloc] initWithFrame: CGRectMake(0, 20, 320, 40)];
        self.popViewTitle.text = @"Information Input";
        self.popViewTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview: self.popViewTitle];
        
        [self setlayout];
    }
    return self;
}

#pragma mark - Layout
- (void) setlayout {
    self.loginButton.frame = CGRectMake(0, self.frame.size.height - self.loginButton.frame.size.height, self.loginButton.frame.size.width, self.loginButton.frame.size.height);
    
    self.textView.frame = CGRectMake(0, 80, 320, 60);
    self.textView_2.frame = CGRectMake(0, 160, 320, 60);
}

#pragma mark - Close Animation
- (void) closeAnimation {
    
    if (self.textView.text.length <= 0){
        return;
    }
    if (self.textView_2.text.length <= 0){
        return;
    }
    
    self.transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration: 0.25
                          delay: 0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.superview.alpha = 1;
    }
                     completion: ^(BOOL finished) {
        NSDictionary *tempD = @{@"weight":self.textView.text,
                                @"tizhi":self.textView_2.text};
        [[NSNotificationCenter defaultCenter] postNotificationName: @"confirm" object: tempD];
        [self removeFromSuperview];
    }];
}

@end
