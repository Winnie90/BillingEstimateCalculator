//
//  Company+Management.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "Company.h"

@interface Company (Management)

+ (Company*)companyWithName:(NSString *)name customerId:(NSString*)customerId address:(NSString*)address email:(NSString*)email mobile:(NSString*)mobile phone:(NSString*)phone inManagedObjectContext:(NSManagedObjectContext *)context;

@end
