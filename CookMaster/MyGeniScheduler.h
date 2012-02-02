//
//  MyGeniScheduler.h
//  CookMaster
//
//  Created by lim byeong cheol on 11. 11. 16..
//  Copyright (c) 2011년 ZenCom. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define kTimerActivated @"0"
#define kReadingActivated @"1"
#define kListeningActivated @"2"
#define kQuestionActivated @"3"
#define kImageActivated @"4"
#define kSDK_KEY @"8676040210f7459374d5cfcfcd873d03"
@interface MyGeniScheduler : NSObject 
@property (nonatomic,assign) int i;
@property (nonatomic,assign) int maxLines;
@property (nonatomic,retain) NSArray *array;

@property (nonatomic,assign) int numberOfQuestion;
@property (nonatomic,retain) NSArray *originalArray;

-(NSMutableDictionary *)parser:(NSMutableString *)string;
-(NSMutableString *)parserStrToHTML:(NSString *)string;
-(void)readRecipe:(NSString *)recipeString;
-(void)timer;
@end
