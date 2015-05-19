//
//  Utils.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#include "Utils.h"

@implementation Utils

-(NSString*) formatDateToDateString:(NSDate*)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd-MM-yyyy";
    return [format stringFromDate:date];
}

-(NSString*) formatDateToDateTimeString:(NSDate*)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH:mm:ss dd-MM-yyyy";
    return [format stringFromDate:date];
}
@end
