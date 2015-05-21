//
//  UITextField+Validation.m
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 20/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "UITextField+Validation.h"
#import "NSString+Common.h"
#import "Utils.h"

@implementation UITextField (Validation)

- (BOOL)validEmail:(UIViewController*)vc errorString:(NSString*)errorString{
    BOOL valid = TRUE;
    valid = [self notBlank:vc];
    if(![self.text isValidEmailAddress]){
        [[Utils getInstance] errorAlert:vc title:@"Invalid Email" message:@"Email is not valid please enter a valid email address."];
        valid = FALSE;
    }
    [self checkValid:valid errorString:errorString];
    return valid;
}

- (BOOL)validNumber:(UIViewController*)vc errorString:(NSString*)errorString{
    BOOL valid = TRUE;
    valid = [self notBlank:vc];
    if(valid && ![self.text isValidNumber]){
        [[Utils getInstance] errorAlert:vc title:@"Invalid Number" message:@"Number is not valid please enter a valid number."];
        valid = FALSE;
    }
    [self checkValid:valid errorString:errorString];
    return valid;
}

- (BOOL)validPercentage:(UIViewController*)vc errorString:(NSString*)errorString{
    BOOL valid = TRUE;
    valid = [self validNumber:vc errorString:errorString];
    if (valid && [self.text floatValue] > 100.0) {
        [[Utils getInstance] errorAlert:vc title:@"Invalid Number" message:@"Number is not a valid percentage."];
        valid = FALSE;
    }
    [self checkValid:valid errorString:errorString];
    return valid;
}

- (BOOL)greaterThan:(int)number vc:(UIViewController*)vc errorString:(NSString*)errorString{
    BOOL valid = TRUE;
    valid = [self validNumber:vc errorString:errorString];
    if (valid && [self.text floatValue] < number) {
        [[Utils getInstance] errorAlert:vc title:@"Invalid Number" message:[[NSString alloc] initWithFormat:@"Number needs to be greater than %d.", number]];
        valid = FALSE;
    }
    [self checkValid:valid errorString:errorString];
    return valid;
}

- (BOOL)notBlank:(UIViewController*)vc{
    if ([self.text isBlank]) {
        [[Utils getInstance] errorAlert:vc title:@"Invalid Input" message:@"Text is blank please enter valid text."];
        return FALSE;
    }
    return TRUE;
}

- (void)checkValid:(BOOL)valid errorString:(NSString*)errorString{
    if (!valid) {
        self.text = nil;
        self.placeholder = errorString;
    }
}

@end