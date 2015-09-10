//
//  DYMAssistiveTouch.m
//  DYMAssistiveTouchDemo
//
//  Created by Bean on 15/9/10.
//  Copyright (c) 2015年 Bean. All rights reserved.
//

#import "DYMAssistiveTouch.h"

static DYMAssistiveTouch *sharedSingleton = nil;

@interface DYMAssistiveTouch()

@end

@implementation DYMAssistiveTouch

+(instancetype)sharedInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^(void) {
        sharedSingleton = [[DYMAssistiveTouch alloc] initWithFrame:CGRectMake(100,100,72,72)];
    });
    return sharedSingleton;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor clearColor];
        self.image = [UIImage imageNamed:@""];
    }
    return self;
}

+(void)showInViewController:(UIViewController *)viewCtrl
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [window addSubview:[DYMAssistiveTouch sharedInstance]];
    [[DYMAssistiveTouch sharedInstance] disableAction];
    if (CGRectEqualToRect([DYMAssistiveTouch sharedInstance].frame, CGRectMake(100,100,72,72))){
        [DYMAssistiveTouch sharedInstance].center = CGPointMake(CGRectGetWidth([DYMAssistiveTouch sharedInstance].superview.frame)-CGRectGetWidth([DYMAssistiveTouch sharedInstance].bounds)/2.0, CGRectGetHeight([DYMAssistiveTouch sharedInstance].superview.frame)-CGRectGetHeight([DYMAssistiveTouch sharedInstance].bounds)/2.0);
    }
}

-(void)disableAction
{
    
}

-(void)panGestureRecognizerAction:(UIPanGestureRecognizer*)panGestureRecognizer
{
    
}

-(void)tapGestureRecognizerAction:(UITapGestureRecognizer*)tapGestureRecognizer
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
