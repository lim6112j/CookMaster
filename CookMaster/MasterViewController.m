//
//  MasterViewController.m
//  CookMaster
//
//  Created by lim byeong cheol on 11. 11. 14..
//  Copyright (c) 2011년 SK M&S. All rights reserved.
//

#import "MasterViewController.h"
#import "InsertViewController.h"
#import "DetailViewController.h"
#import "TimerViewController.h"
#import "Event.h"
#import "AppDelegate.h"

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize insertViewController = _insertViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize timerViewController=_timerViewController;
@synthesize myTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"맛있는 요리", @"요리리스트");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
           // self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}
							
- (void)dealloc
{
    [_detailViewController release];
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [self setTimerViewController:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


-(NSString *)dataFilePath{
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	//NSLog(@"documentsDirectory is %@",[documentsDirectory stringByAppendingPathComponent:kFileName]);
	return [documentsDirectory stringByAppendingPathComponent:kFileName];
}
-(void)coreDataInit{
    
	self.managedObjectContext = [self.fetchedResultsController managedObjectContext];
	//Get path to copy the Bundle to the Documents directory...
	NSString *rootPath = [self applicationDocumentsDirectoryString];
	NSString *plistPath = [rootPath stringByAppendingPathComponent:kFileName];
	
	//Pull the data from the Bundle object in the Resources directory...
	NSFileManager *defaultFile = [NSFileManager defaultManager];
	BOOL isInstalled = [defaultFile fileExistsAtPath :plistPath];
	
	NSDictionary *plistData;
	
	if(isInstalled == NO)
	{		
        NSLog(@"Initial installation: retrieve and copy InitialRecipe.plist from Main Bundle");
		
		NSString *bundlePath = [[NSBundle mainBundle] pathForResource :@"InitialRecipe" ofType:@"plist"];
        NSLog(@"bundlepath is %@",bundlePath);
		plistData = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
		NSLog(@"plist data is %@",[plistData description]);
		if(plistData)
		{
            NSLog(@"plistData exists");
			[plistData writeToFile :plistPath atomically:YES];
			//OR... [defaultFile copyItemAtPath:bundlePath toPath:plistPath error:&errorDesc];
		}		
        
        
        //Process plistData to store in Photo and Person objects...
        
        for (int i=0; i<[plistData count]; i++) 
        {
            NSLog(@"while loop running");
            NSDictionary *dic=[plistData valueForKey:[NSString stringWithFormat:@"item%d",i]];
            Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
            [event setRecipeDetail:[dic valueForKey:@"recipeDetail"]];
            //NSLog(@"curr objectForkey : name is : %@",[curr objectForKey:@"name"]);
            //NSLog(@"photo.photoname is : %@",[photo photoName]);
            [event setRecipeIconName:[dic valueForKey:@"recipeIconName"]];
            [event setTimeStamp:[NSDate date]];
            NSDictionary *ingDic= [dic valueForKey:@"ingredients"];
            
            [event setIngredientName:[ingDic valueForKey:@"name"]];
            [event setIngredientCheck:[ingDic valueForKey:@"check"]];
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error saving after delete", @"Error saving after delete.") 
                                                                message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting.",@"Error was: %@, quitting."), [error localizedDescription]]
                                                               delegate:self 
                                                      cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts")
                                                      otherButtonTitles:nil];
                [alert show];
                
                exit(-1);
            }
        }
    }
    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[ UIApplication sharedApplication ] setIdleTimerDisabled: YES ];
	// Do any additional setup after loading the view, typically from a nib.
    // Set up the edit and add buttons.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)] autorelease];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    //UIColor *color=[UIColor colorWithRed:180.0 green:207.0 blue:102.0 alpha:1.0];
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor greenColor]];
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:0.0 green:0.18431373 blue:0.30196078 alpha:3.0]];
    UIView *containerView =
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 60)]
	 autorelease];
	UILabel *headerLabel =
	[[[UILabel alloc]
	  initWithFrame:CGRectMake(80, 12, 300, 40)]
	 autorelease];
	//UIImageView *imageView=[[[UIImageView	alloc]initWithFrame:CGRectMake(5,0, 67, 67)]autorelease];
	//imageView.image=[UIImage imageNamed:@"text3791.png"];
	headerLabel.text = NSLocalizedString(@"Delicious Cook", @"");
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:22];
	headerLabel.backgroundColor = [UIColor clearColor];
	[containerView addSubview:headerLabel];
	//[containerView addSubview:imageView];
	//self.tableView.tableHeaderView = containerView;
    UIView *containerFooterView =
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 60)]
	 autorelease];

	//UIImageView *imageView=[[[UIImageView	alloc]initWithFrame:CGRectMake(5,0, 67, 67)]autorelease];
	//imageView.image=[UIImage imageNamed:@"text3791.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self 
               action:@selector(insertNewObject)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"새로운 요리 등록" forState:UIControlStateNormal];
    button.frame = CGRectMake(60.0, 10.0, 200.0, 50.0);
  
    //button.backgroundColor=[UIColor colorWithRed:0.9607 green:0.5568 blue:0.7176 alpha:1.0];
    //UIImage* img = [UIImage imageNamed:@"button_cookstart_cookmaster.png"];
    //UIImage* pressedImg=[UIImage imageNamed:@"button_cookstart_pressed_cookmaster.png"];
    //[button setImage:img  forState:UIControlStateNormal];
    //[button setImage:pressedImg  forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"rect3189.png"] forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    //새로운 요리 등록 버튼을 보이려면 아래 주석을 해제 한다.
	[containerFooterView addSubview:button];
    
    
    UIButton *chartButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [chartButton addTarget:self 
               action:@selector(insertChart)
     forControlEvents:UIControlEventTouchUpInside];
    [chartButton setTitle:@"Chart" forState:UIControlStateNormal];
    chartButton.frame = CGRectMake(80.0, 10.0, 160.0, 40.0);
    
	//[containerFooterView addSubview:chartButton];
    
    self.myTableView.tableFooterView = containerFooterView;
   
    [self coreDataInit];
}
-(void)insertChart
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.timerViewController) {
	        self.timerViewController =[[TimerViewController alloc]initWithNibName:@"TimerViewController" bundle:nil];
        }

        //self.navigationController.navigationBarHidden=NO;
        [self.navigationController pushViewController:self.timerViewController animated:YES];
    }
    
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
    //self.navigationController.navigationBarHidden=YES;
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
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
     
  
}

// Customize the number of sections in the table view.
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil] autorelease];
	    }

        Event *event = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        NSDateFormatter *format=[[[NSDateFormatter alloc]init]autorelease];
        [format setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
        self.detailViewController.detailItem =[format stringFromDate:[event timeStamp]];   
      //  self.detailViewController.recipeTextView.text=nil;
        self.detailViewController.recipe=[event recipeDetail];
        self.detailViewController.selectedIndexPathRow=indexPath.row;
        NSLog(@"indexpathrow is %d in masterview",indexPath.row);
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.detailViewController.detailItem = selectedObject;    
    }
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
    aFetchedResultsController.delegate = self;
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

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *string=[managedObject valueForKey:@"recipeDetail"];
    NSArray *array=[string componentsSeparatedByString:@"\n"];
    //cell.textLabel.text = [[managedObject valueForKey:@"timeStamp"] description];
    cell.textLabel.text=[array objectAtIndex:0];
    cell.detailTextLabel.text=[managedObject valueForKey:@"recipeDetail"];
    [cell.imageView setClipsToBounds:NO];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10.0;
    if ([managedObject valueForKey:@"recipeIconName"]==nil) {
        NSLog(@"recipe icon image is null");
        cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"0.png"]];
    } else
    {
        cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:[managedObject valueForKey:@"recipeIconName"]]];
    }
    if ((indexPath.row)%2==1) {
        cell.backgroundColor=[UIColor colorWithRed:[self toColorValue:168] green:[self toColorValue:168] blue:[self toColorValue:168] alpha:1.0];
    } else
    {
        cell.backgroundColor=[UIColor colorWithRed:[self toColorValue:148] green:[self toColorValue:148] blue:[self toColorValue:148] alpha:1.0];

    }
}
-(float)toColorValue:(float)rgbValue
{
    return rgbValue/255;
}
- (void)insertNewObject
{
    /*
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        //
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         */
    
    /*
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    */
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.insertViewController) {
	        self.insertViewController = [[[InsertViewController alloc] initWithNibName:@"InsertViewController" bundle:nil] autorelease];
	    }

         self.navigationController.navigationBarHidden=NO;
        [self.navigationController pushViewController:self.insertViewController animated:YES];
    }
}
- (NSString *)applicationDocumentsDirectoryString 
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
@end
