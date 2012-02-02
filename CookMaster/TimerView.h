//
//  TimerView.h
//  Talking Reni
//
//  Created by lim byeong cheol on 11. 11. 27..
//  Copyright (c) 2011년 ZenCom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerView : UIView
-(void)updateTimer;

@property (nonatomic,assign)CGContextRef ctx ;
@property int i;
@end
