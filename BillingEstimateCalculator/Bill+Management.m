//
//  Bill+Management.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "Bill+Management.h"

@implementation Bill (Management)

//Create empty bill with name and title 
+ (Bill*)billWithName:(NSString *)name title:(NSString*)title inManagedObjectContext:(NSManagedObjectContext *)context;
{
    Bill* bill = (Bill*)[NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:context];
    bill.name = name;
    bill.title = title;
    bill.date = [NSDate date];
    bill.estimatedArtefacts = [[NSNumber alloc] initWithInt:0];
    bill.duplicates = [[NSNumber alloc] initWithFloat:0.0];
    bill.versions = [[NSNumber alloc] initWithFloat:0.0];
    return bill;
}

@end
