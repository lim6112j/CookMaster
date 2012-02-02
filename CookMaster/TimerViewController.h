//
//  TimerViewController.h
//  Talking Reni
//
//  Created by lim byeong cheol on 11. 11. 28..
//  Copyright (c) 2011년 ZenCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerView.h"
@interface TimerViewController : UIViewController
-(void)updateTimerImage;
@property (nonatomic,retain)NSTimer *ChartTimer;
@property (nonatomic,retain)TimerView *timerView;
@property (nonatomic,retain)IBOutlet UIImageView *imageView;
@property int timerImageIndex;
@property (nonatomic,assign)CGContextRef ctx ;
@property float timerTime;
@property (nonatomic,retain)IBOutlet UILabel *timeLabel;
@end
