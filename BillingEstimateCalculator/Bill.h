//
//  Bill.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company, Tier;

@interface Bill : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSNumber * estimatedArtefacts;
@property (nonatomic, retain) NSNumber * duplicates;
@property (nonatomic, retain) NSNumber * versions;
@property (nonatomic, retain) NSSet *tiers;
@property (nonatomic, retain) Company *company;
@end

@interface Bill (CoreDataGeneratedAccessors)

- (void)addTiersObject:(Tier *)value;
- (void)removeTiersObject:(Tier *)value;
- (void)addTiers:(NSSet *)values;
- (void)removeTiers:(NSSet *)values;

@end
