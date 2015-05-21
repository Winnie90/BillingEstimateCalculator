//
//  UITextField+Validation.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 20/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Validation)

- (BOOL)validEmail:(UIViewController*)vc errorString:(NSString*)errorString;
- (BOOL)validNumber:(UIViewController*)vc errorString:(NSString*)errorString;
- (BOOL)validPercentage:(UIViewController*)vc errorString:(NSString*)errorString;
- (BOOL)greaterThan:(int)number vc:(UIViewController*)vc errorString:(NSString*)errorString;
- (BOOL)notBlank:(UIViewController*)vc;
@end