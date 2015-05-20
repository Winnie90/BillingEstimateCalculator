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

-(BOOL) isStringBlank:(NSString*)checkString{
    return [checkString length] == 0;
}

-(void)errorAlert:(UIViewController*)vc title:(NSString*)title message:(NSString*)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}
@end
