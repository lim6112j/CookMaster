//
//  MyGeniScheduler.m
//  CookMaster
//
//  Created by lim byeong cheol on 11. 11. 16..
//  Copyright (c) 2011년 ZenCom. All rights reserved.
//

#import "MyGeniScheduler.h"
#import "AppDelegate.h"
@implementation MyGeniScheduler
@synthesize i,maxLines,array,numberOfQuestion,originalArray;

-(void)dealloc
{
    [self setOriginalArray:nil];
    [self setArray:nil];

    [super dealloc];
}
-(id)init
{
    if (self=[super init]) {
        NSLog(@"scheduler initiated");

        self.i=0;
        self.numberOfQuestion=0;
        
    }
    return self;
}
-(NSMutableString *)parserStrToHTML:(NSString *)string
{
    // <img  src="24956-2-29690.jpg" alt=""  width="100"/>
    NSArray *tempArray=[string componentsSeparatedByString:@"\n"];
    NSInteger numOfArray=[tempArray count];
    NSMutableString *mutableString=[[[NSMutableString alloc]init]autorelease];
    NSError *error;
    NSRegularExpression *regexForAll= [NSRegularExpression regularExpressionWithPattern:@"((y|n)\\d)*(-|!|i|\\?|#\\d*):"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:&error];
    NSRegularExpression *regexForImage = [NSRegularExpression regularExpressionWithPattern:@"i:"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
    for (int idx=0; idx<numOfArray; idx++) {
        NSString *tempStr;
        NSString *arrayStr=[tempArray objectAtIndex:idx];
        
        if (idx==0) 
        {
            tempStr=[NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" ><head><meta http-equiv=\"content-type\" content=\"text/html; charset=iso-8859-1\" />	<script type=\"text/javascript\"></script><style type=\"text/css\" media=\"all\">@import \"iPhone.css\";</style></head><body>%@",arrayStr];
        }
        else
        {

                NSInteger numberOfMatching=[regexForImage numberOfMatchesInString:arrayStr options:0 range:NSMakeRange(0, [arrayStr length])];
                tempStr=[regexForAll stringByReplacingMatchesInString:arrayStr options:0 range:NSMakeRange(0, [arrayStr length]) withTemplate:@""];
                if (numberOfMatching!=0) {
                    tempStr=[NSString stringWithFormat:@" <div class=\"myStyle\"><img src=\"%@\" width=\"100\" /></div><br><li>",tempStr];
                    NSLog(@"tempstr = %@",tempStr);
                } else
                {
                    tempStr=[NSString stringWithFormat:@"<br><li>%@",tempStr];
                }
            
        }
          [mutableString appendFormat:@"%@",tempStr];

    }
    NSLog(@"mutable string is %@",mutableString);
    return mutableString;
}
-(NSMutableDictionary *)parser:(NSMutableString *)string
{
    /*
     NSError *error = NULL;
     NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#"
     options:NSRegularExpressionCaseInsensitive
     error:&error];
     NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
     options:0
     range:NSMakeRange(0, [string length])];
     
     NSArray *array=[string componentsSeparatedByString:@"\n"];
     NSInteger numOfscenario=pow(2,numberOfMatches);
     NSLog(@"몇 줄? %d, 분기 몇번? %d",[array count], numOfscenario);
     */
    NSError *error = NULL;
    NSRegularExpression *regexForReading = [NSRegularExpression regularExpressionWithPattern:@"-:"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSRegularExpression *regexForQuestion = [NSRegularExpression regularExpressionWithPattern:@"#\\d+:"
                                                                                     options:NSRegularExpressionCaseInsensitive
                                                                                       error:&error];
    NSRegularExpression *regexForTimer = [NSRegularExpression regularExpressionWithPattern:@"!:"
                                                                                     options:NSRegularExpressionCaseInsensitive
                                                                                       error:&error];
    NSRegularExpression *regexForImage = [NSRegularExpression regularExpressionWithPattern:@"i:"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
    NSRegularExpression *regexForListening = [NSRegularExpression regularExpressionWithPattern:@"\\?:"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
     NSRegularExpression *regexForAll= [NSRegularExpression regularExpressionWithPattern:@"((y|n)\\d)*(-|!|i|\\?|#\\d*):"
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:&error];
    NSString *recipeText=[regexForAll stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    //NSLog(@"parsed text : %@",recipeText);
    
    NSInteger numberOfMatching=[regexForAll numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    //NSLog(@"match number is : %d",numberOfMatching);
    NSTextCheckingResult *match= [regexForAll firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    NSString *code=[string substringWithRange:[match rangeAtIndex:0]];
    NSLog(@"%@", code);
    NSMutableDictionary *dic=[[[NSMutableDictionary alloc]init]autorelease];  
    [dic setValue:recipeText forKey:@"recipe"];
    [dic setValue:code forKey:@"code"];
    if (numberOfMatching==0) {
        //NSLog(@"cook name");
        [dic setValue:kReadingActivated forKey:@"flag"];
        NSLog(@"dic's recipename is %@",[dic valueForKey:@"recipe"]);
    }
    else 
    {   
        NSLog(@"dic's recipename is %@",[dic valueForKey:@"recipe"]);
        
        NSLog(@"code lenggh is %d",[code length]);


        if ([code length]<=2) {
            if ([regexForListening numberOfMatchesInString:code options:0 range:NSMakeRange(0, 2)]==1) {
            //    NSLog(@"listening start!");
                [dic setValue:kListeningActivated forKey:@"flag"];
            }
            if ([regexForReading numberOfMatchesInString:code options:0 range:NSMakeRange(0, 2)]==1) {
              //  NSLog(@"reading start!");
                [dic setValue:kReadingActivated forKey:@"flag"];
            }
            if ([regexForTimer numberOfMatchesInString:code options:0 range:NSMakeRange(0, 2)]==1) {
               // NSLog(@"timer Activated");
                [dic setValue:kTimerActivated forKey:@"flag"];
            }
            if ([regexForImage numberOfMatchesInString:code options:0 range:NSMakeRange(0, 2)]==1) {
                // NSLog(@"timer Activated");
                [dic setValue:kImageActivated forKey:@"flag"];
            }

        } else
        {
            if ([regexForImage numberOfMatchesInString:[code substringWithRange:NSMakeRange([code length]-2, 2)] options:0 range:NSMakeRange(0, 2)]==1) {
                //   NSLog(@"image start!");
                [dic setValue:kImageActivated forKey:@"flag"];
            }
            if ([regexForListening numberOfMatchesInString:[code substringWithRange:NSMakeRange([code length]-2, 2)] options:0 range:NSMakeRange(0, 2)]==1) {
             //   NSLog(@"listening start!");
                [dic setValue:kListeningActivated forKey:@"flag"];
            }
            if ([regexForReading numberOfMatchesInString:[code substringWithRange:NSMakeRange([code length]-2, 2)] options:0 range:NSMakeRange(0, 2)]==1) {
            //    NSLog(@"reading start!");
                [dic setValue:kReadingActivated forKey:@"flag"];
            }
            if ([regexForTimer numberOfMatchesInString:[code substringWithRange:NSMakeRange([code length]-2, 2)] options:0 range:NSMakeRange(0, 2)]==1) {
            //    NSLog(@"timer Activated");
                [dic setValue:kTimerActivated forKey:@"flag"];
            }
            if ([regexForQuestion numberOfMatchesInString:[code substringWithRange:NSMakeRange([code length]-3, 3)] options:0 range:NSMakeRange(0, 3)]==1) {
           //     NSLog(@"question Activated");
                [dic setValue:kQuestionActivated forKey:@"flag"];
            }
        }

    }
    return dic;
}

-(void)readRecipe:(NSString *)recipeString
{
    NSLog(@"mygenischeduler reading text");
}
-(void)timer
{
    
}


@end
