//
//  NSString+Common.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 20/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

-(BOOL) isBlank;
-(BOOL) isValidEmailAddress;
-(BOOL) isValidNumber;

@end