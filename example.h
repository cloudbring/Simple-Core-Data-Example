//
//  example.h
//  CoreDataExample
//
//  Created by Wess Cope on 3/7/10.
//  Copyright 2010 FrenzyLabs. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface example :  NSManagedObject  
{
	NSNumber *digits;
	NSString *item;
}

@property (nonatomic, retain) NSNumber *digits;
@property (nonatomic, retain) NSString *item;

@end



