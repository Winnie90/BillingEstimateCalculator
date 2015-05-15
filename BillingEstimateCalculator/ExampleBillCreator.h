//
//  ExampleBillCreator.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface ExampleBillCreator : NSObject

-(void) createExampleBill;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
