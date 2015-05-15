//
//  Company.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bill;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSSet *bills;
@property (nonatomic, retain) NSDate *lastUpdated;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addBillsObject:(Bill *)value;
- (void)removeBillsObject:(Bill *)value;
- (void)addBills:(NSSet *)values;
- (void)removeBills:(NSSet *)values;

@end
