//
//  Bill+Management.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "Bill+Management.h"
#import "Tier+Management.h"
#import "Company+Management.h"

@implementation Bill (Management)

//Create empty bill with name and title 
+ (Bill*)billWithName:(NSString *)name title:(NSString*)title inManagedObjectContext:(NSManagedObjectContext *)context;
{
    Bill* bill = (Bill*)[NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:context];
    bill.name = name;
    bill.title = title;
    bill.estimatedArtefacts = [[NSNumber alloc] initWithInt:0];
    bill.duplicates = [[NSNumber alloc] initWithFloat:0.0];
    bill.versions = [[NSNumber alloc] initWithFloat:0.0];
    [bill createStandardTiers:context];
    [bill addCompany:context];
    bill.createdDate = [NSDate date];
    bill.lastUpdated = [NSDate date];
    return bill;
}

- (void)createStandardTiers:(NSManagedObjectContext *)context{
    // create the three standard tiers
    Tier *tier1 = [Tier tierWithPriceArtefactPerMonth:[[NSNumber alloc] initWithFloat:1.00] artefactMax:[[NSNumber alloc] initWithInt:1000] inManagedObjectContext:context];
    Tier *tier2 = [Tier tierWithPriceArtefactPerMonth:[[NSNumber alloc] initWithFloat:0.70] artefactMax:[[NSNumber alloc] initWithInt:5000] inManagedObjectContext:context];
    tier2.lowerTier = tier1;
    Tier *tier3 = [Tier tierWithPriceArtefactPerMonth:[[NSNumber alloc] initWithFloat:0.50] artefactMax:[[NSNumber alloc] initWithInt:15000] inManagedObjectContext:context];
    tier3.lowerTier = tier2;
    NSSet *tiers = [NSSet setWithObjects: tier1, tier2, tier3, nil];
    [self addTiers:tiers];
}

- (void)addCompany:(NSManagedObjectContext *)context{
    Company *company = [self retrieveLastUsedCompany:context];
    if (company == nil) {
        company = [Company companyWithName:@"Example Company" customerId:@"Example Company Id" address:@"88 Example Company Street, Example Company Way, Exampleton, EXA 1MP" email:@"example@example.com" mobile:@"012456789" phone:@"012456789" inManagedObjectContext:context];
    }
    [company addBillsObject:self];
}

- (Company*)retrieveLastUsedCompany:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([Company class]) inManagedObjectContext:context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdated" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setFetchLimit:1];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (result == nil || result.count < 1) {
        return nil;
    }
    return (Company*)[result objectAtIndex:0];
}

@end
