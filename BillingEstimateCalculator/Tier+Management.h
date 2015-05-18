//
//  Tier+Management.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "Tier.h"

@interface Tier (Management)

+ (Tier*)tierWithPriceArtefactPerMonth:(NSNumber*)priceArtefactPerMonth artefactMax:(NSNumber*)artefactMax inManagedObjectContext:(NSManagedObjectContext *)context;

- (int)range;
- (int)clientArtefactNum;
- (float)priceTierPerMonth;

@end
