//
//  TimerViewController.m
//  Talking Reni
//
//  Created by lim byeong cheol on 11. 11. 28..
//  Copyright (c) 2011년 ZenCom. All rights reserved.
//

#import "TimerViewController.h"

@implementation TimerViewController
@synthesize ChartTimer,timerView,imageView,timerImageIndex,ctx,timerTime,timeLabel;

-(void)dealloc
{
    [self setChartTimer:nil];
    [self setTimerView:nil];
    [self setImageView:nil];
    [self setTimeLabel:nil];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIButton *chartButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [chartButton addTarget:self.view 
                        action:@selector(removeFromSuperview)
              forControlEvents:UIControlEventTouchUpInside];
        [chartButton setTitle:@"Timer 중지" forState:UIControlStateNormal];
        chartButton.frame = CGRectMake(80.0, 300.0, 160.0, 40.0);
        [self.view addSubview:chartButton];
    }

    return self;
}

-(void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
   
}
*/
-(void)viewWillAppear:(BOOL)animated
{
    NSTimeInterval interval=self.timerTime/180;
    
    self.ChartTimer=[NSTimer scheduledTimerWithTimeInterval:interval  target:self selector:@selector(updateTimerImage) userInfo:nil repeats:YES];
    //[self.navigationController setNavigationBarHidden:YES];

}
-(void)viewWillDisappear:(BOOL)animated
{
    if (self.ChartTimer!=nil) {
        if ([self.ChartTimer isValid]) {
            [self.ChartTimer invalidate];
            NSLog(@"timer invalidated");
            // [self.timerLabel setHidden:YES];
        }
    }

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"타이머";
    
    //self.timerView=[[TimerView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    //self.view=self.timerView;
    //self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self.timerView selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    self.timerImageIndex=0;
    self.timerTime=10.0;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.ctx=UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 1 ,0.3529, 0.2, 1);
    CGContextFillEllipseInRect(ctx, CGRectMake(60, 60, 200, 200));
    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokePath(self.ctx);
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
-(void)updateTimerImage
{
    if (self.timerImageIndex<360) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [imageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]; // 이줄이 없으면 이전 라인이 지워진다. 지워보면 무슨말인지 안다. 시계바늘처럼 됨. 타이머 모양안나옴.
        self.ctx=UIGraphicsGetCurrentContext();
        CGContextSetLineCap(self.ctx, kCGLineCapRound);
        CGContextSetLineWidth(self.ctx, 5.0);
        CGContextSetRGBStrokeColor(self.ctx,1,0.9254, 0.3607 , 1.0);
        CGContextBeginPath(self.ctx);
        
        //1 ,0.3529, 0.2  red
        //0.7058, 0.8117, 0.4, 1.0 바늘의 색깔 - 연두색
        //1,0.9254, 0.3607   원의 색깔 - 노란색
        float rad=M_PI_2-self.timerImageIndex*M_PI/180;
        CGContextMoveToPoint(self.ctx, 160, 160);
        CGContextAddLineToPoint(self.ctx, 160+98*cosf(rad),160-98*sinf(rad));
        CGContextStrokePath(self.ctx);
        imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.timerImageIndex+=2;
    } else
        [self.ChartTimer invalidate];


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
