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

-(BOOL) isValidEmailAddress:(NSString*)checkString{
    //lax email regex
    NSString *emailRegex = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
@end
