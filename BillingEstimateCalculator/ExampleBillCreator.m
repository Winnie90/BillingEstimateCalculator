//
//  ExampleBillCreator.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "ExampleBillCreator.h"
#import "Bill+Management.h"

@implementation ExampleBillCreator

@synthesize managedObjectContext = _managedObjectContext;

-(void) createExampleBill {
    [Bill billWithName:@"Example Bill" title:@"Example Bill Title" inManagedObjectContext:self.managedObjectContext];
    NSError* error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@, %@", [error localizedDescription], [error userInfo]);
    }
}

@end
