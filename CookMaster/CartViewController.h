//
//  CartViewController.h
//  Talking Reni
//
//  Created by lim byeong cheol on 11. 11. 25..
//  Copyright (c) 2011년 ZenCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface CartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@property(nonatomic,retain) IBOutlet UITableView *myTableView;
@property(nonatomic,retain) NSArray *TestArray;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (assign) int selectedIndexPathRow;
@property (nonatomic,retain) NSArray *ingArray;
@property (nonatomic,retain) NSArray *checkArray;
@property (nonatomic,retain) NSMutableArray *checkMutableArray;
@property BOOL isChanged;
@end
