//
//  Company+Management.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "Company+Management.h"

@implementation Company (Management)

+ (Company*)companyWithName:(NSString *)name companyId:(NSString*)companyId address:(NSString*)address email:(NSString*)email mobile:(NSString*)mobile phone:(NSString*)phone inManagedObjectContext:(NSManagedObjectContext *)context{
    Company *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:context];
    company.name = name;
    company.companyId = companyId;
    company.address = address;
    company.email = email;
    company.mobile = mobile;
    company.phone = phone;
    company.lastUpdated = [NSDate date];
    return company;
}

@end
