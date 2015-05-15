//
//  Bill+Management.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "Bill+Management.h"
#import "Tier+Management.h"

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
    [bill createStandardTiers:context];
    return bill;
}

-(void)createStandardTiers:(NSManagedObjectContext *)context{
    Tier *tier1 = [Tier tierWithPriceArtefactPerMonth:[[NSNumber alloc] initWithFloat:1.00] artefactMax:[[NSNumber alloc] initWithInt:1000] inManagedObjectContext:context];
    Tier *tier2 = [Tier tierWithPriceArtefactPerMonth:[[NSNumber alloc] initWithFloat:0.70] artefactMax:[[NSNumber alloc] initWithInt:5000] inManagedObjectContext:context];
    tier2.lowerTier = tier1;
    Tier *tier3 = [Tier tierWithPriceArtefactPerMonth:[[NSNumber alloc] initWithFloat:0.50] artefactMax:[[NSNumber alloc] initWithInt:15000] inManagedObjectContext:context];
    tier3.lowerTier = tier2;
    NSSet *tiers = [NSSet setWithObjects: tier1, tier2, tier3, nil];
    [self addTiers:tiers];
}

@end
