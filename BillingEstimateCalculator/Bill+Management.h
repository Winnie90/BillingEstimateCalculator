//
//  Bill+Management.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//
#import "Bill.h"
#import "Tier+Management.h"

@interface Bill (Management)

+ (Bill*)billWithName:(NSString *)name title:(NSString*)title inManagedObjectContext:(NSManagedObjectContext *)context;
- (Bill*)retrieveLastUsedBill:(NSManagedObjectContext *)context;
- (Tier*)getTierWithHighestArtefactMax;
- (int)removedArtefacts;
- (int)foldedInVersions;
- (int)totalUnits;
- (float)pricePerMonth;
- (float)averagePricePerDrawingPerMonth;
- (float)pricePerYear;
- (NSArray*)orderTiersByArtefactMax;
@end
