//
//  DYMAssistiveTouch.h
//  DYMAssistiveTouchDemo
//
//  Created by Bean on 15/9/10.
//  Copyright (c) 2015年 Bean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYMAssistiveTouch : UIImageView

+(instancetype)sharedInstance;
+(void)showInViewController:(UIViewController*)viewCtrl;
@end
