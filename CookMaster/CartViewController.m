//
//  CartViewController.m
//  Talking Reni
//
//  Created by lim byeong cheol on 11. 11. 25..
//  Copyright (c) 2011년 ZenCom. All rights reserved.
//

#import "CartViewController.h"

@implementation CartViewController
@synthesize myTableView,TestArray;
@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize managedObject=_managedObject;
@synthesize selectedIndexPathRow,ingArray,checkArray,isChanged,checkMutableArray;
#pragma mark - memory management
-(void)dealloc
{
    [self setMyTableView:nil];
    [self setTestArray:nil];
    [self setFetchedResultsController:nil];
    [self setManagedObjectContext:nil];
    [self setManagedObject:nil];
    [self setIngArray:nil];
    [self setCheckArray:nil];
    [self setCheckMutableArray:nil];

    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Ingredients";
    // Do any additional setup after loading the view from its nib.
    self.TestArray=[NSArray arrayWithObjects:@"라면 1개",@"파 1단",@"식초",@"계란", nil];
 
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (self.isChanged==YES) {
        NSString *string=[[[NSString alloc]init]autorelease];

        for (int i=0; i<[self.checkMutableArray count]; i++) {
            NSLog(@"index i = %d",i);
            if (i==[self.checkArray count]-1) {
                string=[string stringByAppendingFormat:@"%@",[self.checkMutableArray objectAtIndex:i]];
            } else
            {
                string=[string stringByAppendingFormat:@"%@;;",[self.checkMutableArray objectAtIndex:i]];
            }
        }
        NSLog(@"check array is %@",string);

        [self.managedObject setValue:string forKey:@"ingredientCheck"];
        // Save the context.
        NSError *error = nil;
        if (![[self.fetchedResultsController managedObjectContext] save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isChanged=NO;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.selectedIndexPathRow inSection:0];
    self.managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
   // NSLog(@"managedobject is %@",[self.managedObject description]);
    NSString *ingString=[self.managedObject valueForKey:@"ingredientName"];
    NSArray *array=[ingString componentsSeparatedByString:@";;"];
    // NSLog(@"indexpathrow is %d in carview",self.selectedIndexPathRow);
    self.ingArray=array;
    //NSLog(@"ingArray is %@",self.ingArray);
    NSString *checkString=[self.managedObject valueForKey:@"ingredientCheck"];
    self.checkArray=[checkString componentsSeparatedByString:@";;"];
    self.checkMutableArray=[NSMutableArray arrayWithArray:self.checkArray];
    NSLog(@"self.checkArray's number is %d",[self.checkArray count]);
    [self.myTableView reloadData];
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
#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ingArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
     //   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     //       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     //   }
    }

        [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.checkMutableArray objectAtIndex:indexPath.row] isEqualToString:@"0"]) 
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
        [self.checkMutableArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    } else
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone;
        [self.checkMutableArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }

    NSLog(@"indexpath row is %d",indexPath.row);
    self.isChanged=YES;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    // [NSFetchedResultsController deleteCacheWithName:@"Master"];
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    // Edit the entity name as appropriate.
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext=  [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"] autorelease];
    //aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    
/*
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.myTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.myTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.myTableView endUpdates];
    
}
 */
#pragma mark - configure cell
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{

    cell.backgroundColor=[UIColor colorWithRed:1.0 green:0.9254 blue:0.3607 alpha:1.0];
    cell.textLabel.text=[self.ingArray objectAtIndex:indexPath.row];
    NSLog(@"cell check or not : %@",[self.checkArray objectAtIndex:indexPath.row]);
    if ([[self.checkArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    } else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
   
    
  //  NSDateFormatter *format=[[[NSDateFormatter alloc]init]autorelease];
  //  [format setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
   // cell.detailTextLabel.text = [format stringFromDate:[self.managedObject valueForKey:@"timeStamp"]];
}
/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

@end
