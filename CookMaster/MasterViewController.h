//
//  MasterViewController.h
//  CookMaster
//
//  Created by lim byeong cheol on 11. 11. 14..
//  Copyright (c) 2011년 SK M&S. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class InsertViewController;
@class TimerViewController;

#define kFileName @"InitialRecipe"
#import <CoreData/CoreData.h>

@interface MasterViewController : UIViewController <NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource>
-(void)coreDataInit;
-(NSString *)dataFilePath;
- (NSString *)applicationDocumentsDirectoryString; 
-(void)insertChart;
-(float)toColorValue:(float)rgbValue;
@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong,nonatomic) InsertViewController *insertViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)TimerViewController *timerViewController;
@property (nonatomic,retain)IBOutlet UITableView *myTableView;
@end
