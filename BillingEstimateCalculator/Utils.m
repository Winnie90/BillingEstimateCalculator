//
//  Utils.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#include "Utils.h"

@implementation Utils

static Utils *mgr = nil;

-(id)init
{
    return self;
}

+(Utils*)getInstance
{
    if(!mgr)
    {
        mgr = [[Utils alloc] init];
    }
    return mgr;
}


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

-(BOOL) isValidNumber:(NSString*)checkText{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    //Set the locale to US
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //Set the number style to Scientific
    [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    NSNumber* number = [numberFormatter numberFromString:checkText];
    if (number != nil) {
        return TRUE;
    }
    return FALSE;
}
@end
