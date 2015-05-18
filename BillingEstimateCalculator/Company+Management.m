//
//  Company+Management.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "Company+Management.h"

@implementation Company (Management)

+ (Company*)companyWithName:(NSString *)name customerId:(NSString*)customerId address:(NSString*)address email:(NSString*)email mobile:(NSString*)mobile phone:(NSString*)phone inManagedObjectContext:(NSManagedObjectContext *)context{
    Company *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:context];
    company.name = name;
    company.customerId = customerId;
    company.address = address;
    company.email = email;
    company.mobile = mobile;
    company.phone = phone;
    company.lastUpdated = [NSDate date];
    return company;
}

- (Company*)retrieveLastUsedCompany:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([Company class]) inManagedObjectContext:context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdated" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setFetchLimit:1];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (result == nil || result.count < 1) {
        return nil;
    }
    return (Company*)[result objectAtIndex:0];
}
@end
