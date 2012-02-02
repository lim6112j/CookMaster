//
//  ViewController.m
//  MyClock
//
//  Created by lim byeong cheol on 11. 11. 17..
//  Copyright (c) 2011년 SK M&S. All rights reserved.
//

#import "ViewController.h"
#import "CorePlot-CocoaTouch.h"
@implementation ViewController
@synthesize graph,pieData,i,timer;
@synthesize hostingView;
-(void)dealloc
{
    [pieData release];
	[graph release];
    [self setTimer:nil];
    [self setHostingView:nil];
	[super dealloc];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - timer
-(void)runTimer
{
    myTicker=[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(showActivity) userInfo:nil repeats:YES];
}
-(void)showActivity
{
    NSDateFormatter *dateFormat=[[[NSDateFormatter alloc]init]autorelease];
    NSDate *date=[NSDate date];
    [dateFormat setTimeStyle:NSDateFormatterMediumStyle];
    [clockLabel setText:[dateFormat stringFromDate:date]];
}
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.pieData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
	return [self.pieData objectAtIndex:index];
}
#pragma mark - View lifecycle
- (void)loadView {
	hostingView = [[CPTGraphHostingView alloc]initWithFrame:CGRectMake(10, 10, 200, 200)];
	self.view = hostingView;
	[hostingView release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    	// Do any additional setup after loading the view, typically from a nib.
    [self runTimer];
    graph = [[CPTXYGraph alloc] initWithFrame: CGRectMake(10, 10, 200, 200)];	
    hostingView = (CPTGraphHostingView *)self.view;
    hostingView.hostedGraph = graph;
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.pieRadius = 100.0;
    pieChart.identifier = @"PieChart1";
    pieChart.startAngle = M_PI_2;
    pieChart.sliceDirection = CPTPieDirectionClockwise;

    self.pieData=  [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:0.0], 
                    [NSNumber numberWithDouble:20.0],nil];
    
    [graph addPlot:pieChart];
    self.i=0;
    [pieChart release];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateChart) userInfo:nil repeats:YES];
}
-(void)updateChart
{
    self.i+=1;
    self.pieData=[NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:0.0+i], 
                  [NSNumber numberWithDouble:20.0-i],nil];
    if (self.i==20) {
        [self.timer invalidate];
    }
    [graph reloadData];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    /*
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
     */
    return YES;
}

@end
