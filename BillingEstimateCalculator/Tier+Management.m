//
//  Tier+Management.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "Tier+Management.h"
#import "Bill+Management.h"

@implementation Tier (Management)

+ (Tier*)tierWithPriceArtefactPerMonth:(NSNumber*)priceArtefactPerMonth artefactMax:(NSNumber*)artefactMax inManagedObjectContext:(NSManagedObjectContext *)context{
    Tier *tier = (Tier*)[NSEntityDescription insertNewObjectForEntityForName:@"Tier" inManagedObjectContext:context];
    tier.priceArtefactPerMonth = priceArtefactPerMonth;
    tier.artefactMax = artefactMax;
    return tier;
}

- (int)clientArtefactNum{
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"artefactMax" ascending:YES];
    NSArray *sortedTiers = [self.bill.tiers sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    int artefactsLeft = self.bill.totalUnits;
    //remove artefacts for the range of each tier
    for(Tier *tier in sortedTiers){
        //if there aren't any artefacts left
        if (artefactsLeft > 0) {
            artefactsLeft -= tier.range;
            if (tier == self) {
                if(artefactsLeft > 0 && tier.higherTier){
                    return tier.range;
                } else {
                    //the last tier
                    return tier.range + artefactsLeft;
                }
            }
        }
    }
    return 0;
}

- (int)range{
    return [self.artefactMax intValue] - [self.lowerTier.artefactMax intValue];
}

- (float)priceTierPerMonth{
    return self.clientArtefactNum * [self.priceArtefactPerMonth floatValue];
}
@end