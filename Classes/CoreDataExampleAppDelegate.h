//
//  CoreDataExampleAppDelegate.h
//  CoreDataExample
//
//  Created by Wess Cope on 3/7/10.
//  Copyright FrenzyLabs 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "example.h"

@interface CoreDataExampleAppDelegate : NSObject <UIApplicationDelegate, UITableViewDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
	
	UITextField *textField;
	UITextField *numberField;
	UIButton *saveButton;
	
	UITableView *tableView;
	NSMutableArray *itemArray;
}

- (NSString *)applicationDocumentsDirectory;
- (IBAction)saveAction:(id)sender;

@property (nonatomic, retain) NSMutableArray *itemArray;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UITextField *numberField;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;


@end

