//
//  Bill+Management.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "Bill+Management.h"

#import "Company+Management.h"

@implementation Bill (Management)

//Create empty bill with name and title 
+ (Bill*)billWithName:(NSString *)name title:(NSString*)title inManagedObjectContext:(NSManagedObjectContext *)context;
{
    Bill* bill = (Bill*)[NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:context];
    bill.name = name;
    bill.title = title;
    bill.estimatedArtefacts = [[NSNumber alloc] initWithInt:15000];
    bill.duplicates = [[NSNumber alloc] initWithFloat:0.15];
    bill.versions = [[NSNumber alloc] initWithFloat:0.1];
    [bill createStandardTiers:context];
    [bill addCompany:context];
    
    //update times
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

- (Tier*)getTierWithHighestArtefactMax{
    NSArray *sortedTiers = [self orderTiersByArtefactMax];
    return [sortedTiers lastObject];
}

- (NSArray*)orderTiersByArtefactMax{
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"artefactMax" ascending:YES];
    return [self.tiers sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
}

- (int)removedArtefacts{
   return (int)([self.estimatedArtefacts floatValue] * [self.duplicates floatValue]);
}

- (int)foldedInVersions{
    return (int)(([self.estimatedArtefacts floatValue] - [self removedArtefacts]) * [self.versions floatValue]);
}

- (int)totalUnits{
    return [self.estimatedArtefacts intValue] - [self removedArtefacts] - [self foldedInVersions];
}

- (float)pricePerMonth{
    float totalPricePerMonth = 0.0;
    for (Tier *tier in self.tiers) {
        totalPricePerMonth += tier.priceTierPerMonth;
    }
    return totalPricePerMonth;
}

- (float)averagePricePerDrawingPerMonth{
    if (self.totalUnits > 0) {
        return self.pricePerMonth/self.totalUnits;
    } else {
        return 0.0;
    }
}

- (float)pricePerYear{
    return self.pricePerMonth * 12;
}

- (void)addCompany:(NSManagedObjectContext *)context{
    Company *company = [Company companyWithName:@"Enter the company name" customerId:@"Enter the company id" address:@"Enter the company address" email:@"Enter the company email" mobile:@"Enter the company mobile" phone:@"Enter the company phone" inManagedObjectContext:context];
    
    [company addBillsObject:self];
}

- (Bill*)retrieveLastUsedBill:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([Bill class]) inManagedObjectContext:context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdated" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setFetchLimit:1];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (result == nil || result.count < 1) {
        return nil;
    }
    return (Bill*)[result objectAtIndex:0];
}


@end
