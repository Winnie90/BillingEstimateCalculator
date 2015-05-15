//
//  Tier+Management.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "Tier+Management.h"

@implementation Tier (Management)

+ (Tier*)tierWithPriceArtefactPerMonth:(NSNumber*)priceArtefactPerMonth artefactMax:(NSNumber*)artefactMax inManagedObjectContext:(NSManagedObjectContext *)context{
    Tier *tier = (Tier*)[NSEntityDescription insertNewObjectForEntityForName:@"Tier" inManagedObjectContext:context];
    tier.priceArtefactPerMonth = priceArtefactPerMonth;
    tier.artefactMax = artefactMax;
    tier.lowerTier = nil;
    return tier;
}

@end