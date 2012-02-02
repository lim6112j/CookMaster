//
//  TimerView.m
//  Talking Reni
//
//  Created by lim byeong cheol on 11. 11. 27..
//  Copyright (c) 2011년 ZenCom. All rights reserved.
//

#import "TimerView.h"

@implementation TimerView
@synthesize ctx,i;
-(void)dealloc
{

   // [self setCtx:nil];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.i=0;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 0, 0, 255, 0.1);
    CGContextSetRGBStrokeColor(contextRef, 0, 0, 255, 0.5);
    
    // Draw a circle (filled)
    //CGContextFillEllipseInRect(contextRef, CGRectMake(100, 100, 100, 100));
    
    // Draw a circle (border only)
   // CGContextStrokeEllipseInRect(contextRef, CGRectMake(100, 100, 100, 100));
    
    // Get the graphics context and clear it
    self.ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    // Draw a green solid circle
    CGContextSetRGBFillColor(ctx, 0, 255, 0, 1);
    CGContextFillEllipseInRect(ctx, CGRectMake(100, 100, 120, 120));

    CGContextSetLineWidth(ctx, 2.0);

    [self updateTimer];
    
    // Draw a purple triangle with using lines
    //CGContextSetRGBStrokeColor(ctx, 255, 0, 255, 1);
    //CGPoint points[6] = { CGPointMake(100, 200), CGPointMake(150, 250),
     //   CGPointMake(150, 250), CGPointMake(50, 250),
     //   CGPointMake(50, 250), CGPointMake(100, 200) };
    //CGContextStrokeLineSegments(ctx, points, 6);

}
-(void)updateTimer
{
    
    if (self.i<360) {
        float rad=M_PI_2-self.i*M_PI/180;
        CGContextMoveToPoint(self.ctx, 160, 160);
        CGContextAddLineToPoint(self.ctx, 160+60*cosf(rad),160-60*sinf(rad));
        CGContextStrokePath(self.ctx);
        self.i+=1;
        NSLog(@"updating timer");

    } else
    {
        NSLog(@"updating timer ends");
    
    }

}
@end
