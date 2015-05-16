//
//  utils.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

-(NSString*) formatDatetoDateString:(NSDate*)date;
-(NSString*) formatDatetoDateTimeString:(NSDate*)date;
@end

