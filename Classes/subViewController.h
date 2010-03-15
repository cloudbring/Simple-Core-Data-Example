//
//  subViewController.h
//  CoreDataExample
//
//  Created by Wess Cope on 3/12/10.
//  Copyright 2010 FrenzyLabs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface subViewController : UIViewController {
	UITextField *textField;
	UITextField *numField;
}

- (IBAction)saveEdit:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UITextField *numField;

@end
