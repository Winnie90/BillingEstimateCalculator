//
//  Tier.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bill;

@interface Tier : NSManagedObject

@property (nonatomic, retain) NSNumber * priceArtefactPerMonth;
@property (nonatomic, retain) NSNumber * artefactMax;
@property (nonatomic, retain) Bill *bill;
@property (nonatomic, retain) Tier *lowerTier;

@end
