//
//  ViewController.h
//  MyClock
//
//  Created by lim byeong cheol on 11. 11. 17..
//  Copyright (c) 2011년 SK M&S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
@interface ViewController : UIViewController<CPTPieChartDataSource>
{
    IBOutlet UILabel *clockLabel;
    NSTimer *myTicker;
    CPTXYGraph * graph;
	NSMutableArray *pieData;
}
-(void)runTimer;
-(void)showActivity;
-(void)updateChart;
@property(readwrite, retain, nonatomic) NSMutableArray *pieData;
@property (nonatomic,retain) CPTXYGraph * graph;
@property int i;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,retain)IBOutlet CPTGraphHostingView * hostingView;
@end
