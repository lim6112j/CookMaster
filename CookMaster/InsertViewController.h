//
//  InsertViewController.h
//  CookMaster
//
//  Created by lim byeong cheol on 11. 11. 15..
//  Copyright (c) 2011년 ZenCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface InsertViewController : UIViewController <UITextViewDelegate>
{

 

}
-(void)touchBackground;
-(IBAction)registerRecipe:(id)sender;
-(void)parser:(NSString *)string;
-(void)insertTimer;
@property(nonatomic,retain) NSString *recipe;
@property(nonatomic,retain)     IBOutlet UITextView *textView;
@end
