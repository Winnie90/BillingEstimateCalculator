//
//  utils.h
//  BillingEstimateCalculator
//
//  Created by Christopher Winstanley on 15/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "UIKit/UIKit.h"

@interface Utils : NSObject

+(Utils*)getInstance;
-(NSString*) formatDateToDateString:(NSDate*)date;
-(NSString*) formatDateToDateTimeString:(NSDate*)date;
-(void)errorAlert:(UIViewController*)vc title:(NSString*)title message:(NSString*)message;
@end

