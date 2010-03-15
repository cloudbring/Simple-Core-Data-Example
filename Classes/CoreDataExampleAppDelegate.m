//
//  CoreDataExampleAppDelegate.m
//  CoreDataExample
//
//  Created by Wess Cope on 3/7/10.
//  Copyright FrenzyLabs 2010. All rights reserved.
//

#import "CoreDataExampleAppDelegate.h"


@interface CoreDataExampleAppDelegate (PrivateCoreDataStack)
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation CoreDataExampleAppDelegate

@synthesize window, textField, numberField, saveButton, tableView;
@synthesize itemArray;

#pragma mark -
#pragma mark View actions
-(IBAction)saveAction:(id)sender
{
	example *ex = (example *)[NSEntityDescription insertNewObjectForEntityForName:@"example" inManagedObjectContext:managedObjectContext];
	
	NSNumberFormatter *numFormat = [[NSNumber alloc] init];
	[numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
	
	NSNumber *digits =[NSNumber numberWithInt:[self.numberField.text intValue] ];

	NSLog(@"Number: %@", self.numberField.text);
	ex.digits = digits;
	
	//ex.digits = [NSNumber numberWithInt:100];
	
	ex.item = self.textField.text;
	NSError *error;
	if (![self.managedObjectContext save:&error])
	{
		NSLog(@"Core Data error: %@, %@", error, [error userInfo]);
		exit(-1);
	}
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Item Added" message:@"Your text has been added" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];

	self.textField.text = @"";
	self.numberField.text = @"";
	
	[self.itemArray addObject:ex];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"example" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSError *error;
	NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	self.itemArray = [[NSMutableArray alloc] initWithArray:results];
	
	[fetchRequest release];	
    [window makeKeyAndVisible];
	
	
	return YES;
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"CoreDataExample.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark tableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.itemArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	example *ex = [self.itemArray objectAtIndex:[indexPath indexAtPosition:1]];
	NSString *exampleResult = [[NSString alloc] initWithFormat:@"%@ / %@", ex.item, ex.digits];
	cell.textLabel.text = exampleResult;
	
	//[ex release];
	[exampleResult release];
	
    return cell;
}

- (void)tableView:(UITableView *)myTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.

		NSError *error;
		
		example *ex = [self.itemArray objectAtIndex:[indexPath indexAtPosition:1]];
		[self.managedObjectContext deleteObject:ex];
		[self.managedObjectContext save:&error];

		[self.itemArray removeObjectAtIndex:[indexPath indexAtPosition:1]];

		[myTableView beginUpdates];
		[myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[myTableView endUpdates];
		
		if([self.itemArray count] == 0)
			[tableView reloadData];
		
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
	[super dealloc];
}


@end

