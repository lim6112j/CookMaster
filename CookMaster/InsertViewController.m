//
//  InsertViewController.m
//  CookMaster
//
//  Created by lim byeong cheol on 11. 11. 15..
//  Copyright (c) 2011년 ZenCom. All rights reserved.
//

#import "InsertViewController.h"

@implementation InsertViewController
@synthesize recipe=_recipe;
@synthesize textView;
-(void)dealloc
{
    [self setTextView:nil];
    [self setRecipe:nil];
    [super dealloc];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"완료" style:UIBarButtonItemStyleBordered target:self action:@selector(touchBackground)];
    self.textView.frame=CGRectMake(22, 20, 270, 200);
    /*
    UIView *containerView =
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 60)]
	 autorelease];
    
	//UIImageView *imageView=[[[UIImageView	alloc]initWithFrame:CGRectMake(5,0, 67, 67)]autorelease];
	//imageView.image=[UIImage imageNamed:@"text3791.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(insertTimer)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Timer" forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, 200.0, 80.0, 30.0);
    
    
	[containerView addSubview:button];
    [self.view addSubview:containerView];
    */
}
-(void)insertTimer
{
    NSLog(@"insertTimer button activated");
}
-(void)touchBackground
{
    
    self.recipe=textView.text;
    self.navigationItem.rightBarButtonItem=nil;
    [textView resignFirstResponder];
    self.textView.frame=CGRectMake(22, 20, 270, 330);
    
}
-(IBAction)registerRecipe:(id)sender
{
    [self parser:self.recipe];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)parser:(NSString *)string
{

    id appDelegate=[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[appDelegate managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription  entityForName:@"Event" inManagedObjectContext:context];
    NSManagedObject *managedObj=[NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    [managedObj setValue:string forKey:@"recipeDetail"];
    [managedObj setValue:[NSDate date] forKey:@"timeStamp"];
    [managedObj setValue:@"temp" forKey:@"ingredientName"];
    [managedObj setValue:@"0" forKey:@"ingredientCheck"];
    //[managedObj setValue:@"0.png" forKey:@"recipeIconName"];
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
    NSLog(@"core data added from detail");
    NSLog(@"string from core data is %@",[managedObj valueForKey:@"recipeDetail"]);
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"요리 등록";
    self.navigationController.navigationBarHidden=NO;
    // Do any additional setup after loading the view from its nib.

  
    
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
